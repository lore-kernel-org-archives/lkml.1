Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbZHYJ3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbZHYJ3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZHYJ3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:29:11 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:48601 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754027AbZHYJ3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:29:10 -0400
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
	memory  (f6f6e1a4), by kmemleak's scan_block()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1251192415.26351.5.camel@penberg-laptop>
References: <20090825071959.GA25877@elte.hu>
	 <19f34abd0908250104y6e877545y485a2104c2b97cfd@mail.gmail.com>
	 <20090825083222.GC17692@elte.hu> <1251189914.7261.11.camel@penberg-laptop>
	 <20090825084808.GA14003@elte.hu> <1251190466.7261.12.camel@penberg-laptop>
	 <19f34abd0908250203h52257f52v306545a3d8890577@mail.gmail.com>
	 <1251191507.26351.0.camel@penberg-laptop>
	 <1251192069.15678.21.camel@pc1117.cambridge.arm.com>
	 <1251192415.26351.5.camel@penberg-laptop>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 25 Aug 2009 10:28:54 +0100
Message-Id: <1251192534.15678.29.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Aug 2009 09:28:55.0247 (UTC) FILETIME=[775595F0:01CA2566]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 12:26 +0300, Pekka Enberg wrote:
> On Tue, 2009-08-25 at 10:21 +0100, Catalin Marinas wrote:
> > On Tue, 2009-08-25 at 12:11 +0300, Pekka Enberg wrote:
> > > On Tue, 2009-08-25 at 11:03 +0200, Vegard Nossum wrote:
> > > > I don't know so much about the kmemleak internals, but this I can say
> > > > about the kmemcheck part: According to your definition, an object is
> > > > initialized if all the bytes of an object are initialized.
> > > > 
> > > > Is it possible that because of this, if we have a partially
> > > > uninitialized object, kmemleak will not record the pointers found in
> > > > that object? If so, it might skip valid pointers, and deem an object
> > > > unreferenced. Which could make kmemleak give false-positives.
> > > > 
> > > > I think it would be better to ask kmemcheck on a per-pointer basis
> > > > (i.e. for each pointer-sized word in the object), whether it is
> > > > initialized or not.
> > > 
> > > Yeah, makes sense.
> > 
> > I think this patch should work. With a few minor (aesthetic) things
> > below and assuming that Ingo tests it (I don't have x86 hardware at hand
> > now):
> 
> Does this look OK to you?

For the kmemleak.c part:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

-- 
Catalin

