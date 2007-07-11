Return-Path: <linux-kernel-owner+w=401wt.eu-S933375AbXGKVBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375AbXGKVBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933550AbXGKU7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:59:43 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:51517
	"EHLO moonbase" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933673AbXGKU7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:59:41 -0400
X-Greylist: delayed 3269 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jul 2007 16:59:40 EDT
From: Daniel Phillips <phillips@phunq.net>
To: Zan Lynx <zlynx@acm.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Date: Wed, 11 Jul 2007 13:05:08 -0700
User-Agent: KMail/1.9.5
Cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200707111916.35036.jesper.juhl@gmail.com> <46951941.9080908@acm.org>
In-Reply-To: <46951941.9080908@acm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707111305.08603.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 July 2007 10:54, Zan Lynx wrote:
> Jesper Juhl wrote:
> > Hi,
> >
> > I'm wondering if it's time to make 4K stacks the default and to start
> > considering removing the 8K stack option alltogether soon?
> >
> > One of the big problem spots was XFS, but that got some stack usage
> > fixes recently, and the 4K stack option has been around for quite a
> > while now, so people really should have gotten around to fixing any
> > code that can't handle it.   Are there still any big problem areas
> > remaining?
>
> Has anyone fixed the infrequent crashes with 4K stacks and ext3 -> LVM
> snapshot -> LVM -> DM mirror -> libata?

Ahem: ext3 -> LVM snapshot -> LVM -> DM mirror -> DM crypt -> md -> libata,
or worse.

No, it's not fixed.  The model is wrong.  Virtual block drivers should not
be callling submit_bio.  The recursive IO submissions should be handled
on a dedicated stack, most probably allocated as part of the request queue.
This could be done easily in device mapper and md, or better, in
submit_bio.

Regards,

Daniel
