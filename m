Return-Path: <linux-kernel-owner+w=401wt.eu-S1030334AbXBZRUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030334AbXBZRUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030346AbXBZRUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:20:20 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54135 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030334AbXBZRUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:20:18 -0500
Date: Mon, 26 Feb 2007 09:10:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin LaHaise <bcrl@kvack.org>
cc: Jiri Slaby <jirislaby@gmail.com>, Uwe Bugla <uwe.bugla@gmx.de>,
       akpm@linux-foundation.org, bunk@stusta.de, linux-kernel@vger.kernel.org,
       Stephane Eranian <eranian@hpl.hp.com>, Andi Kleen <ak@suse.de>
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot
 be mounted without hanging up the whole system
In-Reply-To: <20070226163429.GL26583@kvack.org>
Message-ID: <Pine.LNX.4.64.0702260906540.12485@woody.linux-foundation.org>
References: <20070224175424.176030@gmx.net> <45E2B88B.1090706@gmail.com>
 <45E2F8C5.3080905@gmail.com> <Pine.LNX.4.64.0702260741040.12485@woody.linux-foundation.org>
 <20070226163429.GL26583@kvack.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Feb 2007, Benjamin LaHaise wrote:
> 
> Side note: this patch adds several function calls (4), several additional 
> L1 cache touches and a generally inefficient code path to *every single 
> interrupt that exits from the idle poll*, not to mention the extra (useless, 
> as it doesn't get used on 99.9% of deployed systems) function call and cache 
> touches to every single interrupt.

It is in fact possible that the floppy failure might just be from some 
timing-dependent thing, and the slowdown itself is the problem.

Although I do find that a bit unlikely, since machines these days are 
about a million times faster than they used to be, so even if it's 
unnecessarily slow, it shouldn't be noticeable for a floppy drive.

>  Keep in mind that systems acting as routers will often be sitting in 
> the idle loop when processing interrupts.  At the very least this 
> overhead (which is noticable on profiles) should be configurable.  I 
> don't think that my 586 class embedded routers really need this crap to 
> be going into the kernel.

I'm inclined to agree. Considering that the patch is known to cause 
problems, and that it's apparently broken on x86 *anyway* (the 
idle_notifier_register function isn't even exported), and considering that 
it's clearly bad for interrupt performance and could have been done a lot 
better, I would suggest just ripping it all out.

And I think we should do the same for x86-64 too..

		Linus
