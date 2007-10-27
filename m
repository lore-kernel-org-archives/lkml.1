Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbXJ0DNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbXJ0DNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 23:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbXJ0DNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 23:13:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49918 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbXJ0DNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 23:13:32 -0400
Date: Sat, 27 Oct 2007 04:13:09 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Jeff Dike <jdike@addtoit.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86 patch] Fix UML signal.h build errors
Message-ID: <20071027031309.GI8181@ftp.linux.org.uk>
References: <20071025130022.8720.77346.sendpatchset@balbir-laptop> <20071025150541.GB5968@c2.user-mode-linux.org> <4720B6E8.4090003@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4720B6E8.4090003@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 09:01:52PM +0530, Balbir Singh wrote:

> Thats nice, I wonder why I missed them searching on lkml in my gmail box
> :(
> 
> Is __arch_um__ the right thing to do or BITS_PER_LONG == 32? I prefer
> BITS_PER_LONG == 32 over #if defined(__i386__) || defined(__arch__um__).
> I guess its a matter of personal preference.

Huh?

a) we really shouldn't mess with compiler defines (i.e. we should not
undef __i386__ or __x86_64__)

b) I'd rather have __arch_um__ mentioned explicitly in 3 places where
we do care about difference between i386 and uml/i386 than have certain
to be forgotten rules for places like include/asm-x86

c) if you look at those places, you'll see
	* drivers/char/mem.c::uncached_access().  Really per-architecture
and I wonder if it might be include/asm-* fodder...
	* kernel/signal.c debugging printks.  Should die or be sanitized, IMO.
	* raid6 algorithms.  Hell knows - immediate reason why we don't do
those on uml is the lack of kernel_fpu_begin()/kernel_fpu_end() (and
boot_cpu_has(), but that's easier to add).  Do we care to implement that
stuff?

That's _all_.  Nothing else has to care.

