Return-Path: <linux-kernel-owner+w=401wt.eu-S1763318AbYD0U32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763318AbYD0U32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 16:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764368AbYD0U3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 16:29:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:5683 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764346AbYD0U3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 16:29:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Rdn4NEkvlt9a+5ZOb+/sXFQrUQBlAvZQ9gafNMgXJBCFMiz9W9SQyqNAo7A0eTODSE+A4FWyK5jZNu/ySuRTazZWyqnnigbWEfadTujLJqXhBLV8Z5fUzBi+pEbRO4YjI6eh1kCNxo99qyTROWjcX/NEw1M2ecYE/WPtWcTdft8=
Subject: Re: [PATCH] bitops: simplify generic bit finding functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org>
References: <1209327591.14173.74.camel@brick>
	 <alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sun, 27 Apr 2008 13:29:21 -0700
Message-Id: <1209328161.14173.77.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-04-27 at 13:26 -0700, Linus Torvalds wrote:
> 
> On Sun, 27 Apr 2008, Harvey Harrison wrote:
> >
> > No need for a sentinal if we explicitly catch the no bits/all bits set
> > cases, make it clear they are special cases returning size/BITS_PER_LONG.
> 
> These things need to be re-done anyway. David already complained that the 
> thing inlines to something much much too big.
> 
> Let's just make it not be an inline at all.

Oh, I didn't realize, I only did this because sparse started spewing out
lots of:
include/linux/bitops.h:166:32: warning: shift too big (65536) for type unsigned long

due to shift by size there, and again on line 202...I just wanted something
that sparse wouldn't warn about and was a little easier to understand to boot.

Cheers,

Harvey

