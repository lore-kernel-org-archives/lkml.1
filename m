Return-Path: <linux-kernel-owner+w=401wt.eu-S1752448AbXJWJnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbXJWJnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXJWJnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:43:10 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26807 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbXJWJnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:43:08 -0400
Date: Tue, 23 Oct 2007 11:41:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
Message-ID: <20071023094142.GD5059@kernel.dk>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <Pine.LNX.4.64.0710222137520.7105@anakin> <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org> <20071022211617.31f5c63d@the-village.bc.nu> <alpine.LFD.0.999.0710221343330.30120@woody.linux-foundation.org> <20071022224343.4abf3c96@the-village.bc.nu> <alpine.LFD.0.999.0710221444220.30120@woody.linux-foundation.org> <471DBEF4.4030303@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471DBEF4.4030303@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, Boaz Harrosh wrote:
> On Mon, Oct 22 2007 at 23:47 +0200, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > On Mon, 22 Oct 2007, Alan Cox wrote:
> > 
> >> For structures, not array elements or stack objects. Does gcc now get
> >> aligned correct as an attribute on a stack object ?
> > 
> > I think m68k stack layout still guarantees 4-byte-alignment, no?
> > 
> >> Still doesn't answer the rather more important question - why not just
> >> stick a NULL on the end instead of all the nutty hacks ?
> > 
> > You still do need one bit for the discontiguous case, so it's not like you 
> > can avoid the hacks anyway (unless you just blow up the structure 
> > entirely) and make it a separate member). So once you have that 
> > bit+pointer, using a separate NULL entry isn't exactly prettier. 
> > 
> > Especially as we actally want to see the difference between 
> > "end-of-allocation" and "not yet filled in", so you shouldn't use NULL 
> > anyway, you should probably use something like "all-ones".
> > 
> > 			Linus
> > -
> 
> Every one is so hysterical about this sg-chaining problem. And massive
> patches produced, that when a simple none intrusive solution is proposed
> it is totally ignored because every one thinks, "I can not be that stupid".
> Well Einstein said: "Simplicity is the ultimate sophistication". So no one
> need to feel bad.

It's all about the end goal - having maintainable and resilient code.
And I think the sg code will be better once we get past the next day or
so, and it'll be more robust. That is what matters to me, not the
simplicity of the patch itself.

-- 
Jens Axboe

