Return-Path: <linux-kernel-owner+w=401wt.eu-S1762488AbYAKT5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762488AbYAKT5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 14:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761686AbYAKT5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 14:57:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39931 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761675AbYAKT5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 14:57:18 -0500
Date: Fri, 11 Jan 2008 11:56:56 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org
Subject: Re: Make the 32 bit Frame Pointer backtracer fall back to
 traditional
Message-ID: <20080111115656.36048134@laptopd505.fenrus.org>
In-Reply-To: <alpine.LFD.1.00.0801111136520.3148@woody.linux-foundation.org>
References: <20080109220508.686bbda4@laptopd505.fenrus.org>
	<alpine.LFD.1.00.0801100816450.3148@woody.linux-foundation.org>
	<20080110203519.573567b7@laptopd505.fenrus.org>
	<alpine.LFD.1.00.0801111136520.3148@woody.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 11:41:40 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 10 Jan 2008, Arjan van de Ven wrote:
> > 
> > What do you think of this approach instead of your proposal?
> 
> Looks ok to me. I get the feeling that we *should* be able to make the
> 
> 	#ifdef CONFIG_FRAME_POINTER
> 	..
> 
> thing be a bit cleaner with this (since you have the
> non-frame-pointer thing inside the loop as well), and use one common
> routine for it all, with just certain helper functions always
> retuning a NULL or something for the non-frame-pointer thing.

ok I'll try that; I'm also trying some other cleanups
(right now we pick "ebp" and the stack pointer at different levels
in the call chain, so it gets a tad messy)

> 
> (I also wonder if we should limit the number of entries we print out. 
> Sometimes the stack frame ends up being so deep that we lose the 
> *important* stuff. I think it might be good idea to have some rule
> like "the first 5 entries go to the screen, the rest will be
> KERN_DEBUG and only go to the logs by default" - so a "dmesg" would
> show it all, but if the machine is hung, the screen won't have been
> scrolled away from all the other things by a long backtrace!)

that's... a ton more tricky, and realistically needs the patch
to make show_stack take a level argument in the first place.
(I have that done, it's just touching like 125+ files, so
I shelved it as "probably not important enough");


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
