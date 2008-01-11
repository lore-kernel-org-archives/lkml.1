Return-Path: <linux-kernel-owner+w=401wt.eu-S1762231AbYAKTmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762231AbYAKTmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 14:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758232AbYAKTmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 14:42:13 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46953 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759541AbYAKTmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 14:42:12 -0500
Date: Fri, 11 Jan 2008 11:41:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org
Subject: Re: Make the 32 bit Frame Pointer backtracer fall back to
 traditional
In-Reply-To: <20080110203519.573567b7@laptopd505.fenrus.org>
Message-ID: <alpine.LFD.1.00.0801111136520.3148@woody.linux-foundation.org>
References: <20080109220508.686bbda4@laptopd505.fenrus.org> <alpine.LFD.1.00.0801100816450.3148@woody.linux-foundation.org> <20080110203519.573567b7@laptopd505.fenrus.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Jan 2008, Arjan van de Ven wrote:
> 
> What do you think of this approach instead of your proposal?

Looks ok to me. I get the feeling that we *should* be able to make the

	#ifdef CONFIG_FRAME_POINTER
	..

thing be a bit cleaner with this (since you have the non-frame-pointer 
thing inside the loop as well), and use one common routine for it all, 
with just certain helper functions always retuning a NULL or something for 
the non-frame-pointer thing.

In other words, I *think* the non-frame-pointer case should always be 
doable as a "series of single-word unverified frames", but if that kind of 
cleanup doesn't work, I certainly don't hate your patch either..

(I also wonder if we should limit the number of entries we print out. 
Sometimes the stack frame ends up being so deep that we lose the 
*important* stuff. I think it might be good idea to have some rule like 
"the first 5 entries go to the screen, the rest will be KERN_DEBUG and 
only go to the logs by default" - so a "dmesg" would show it all, but if 
the machine is hung, the screen won't have been scrolled away from all 
the other things by a long backtrace!)

		Linus
