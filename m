Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbYDXRAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbYDXRAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 13:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYDXRAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 13:00:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753AbYDXRAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 13:00:04 -0400
Date: Thu, 24 Apr 2008 09:58:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Jeff Garzik <jeff@garzik.org>, Rene Herman <rene.herman@keyaccess.nl>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [git patch] free_irq() fixes
In-Reply-To: <m1r6cvgpw2.fsf@frodo.ebiederm.org>
Message-ID: <alpine.LFD.1.10.0804240951520.2779@woody.linux-foundation.org>
References: <20080422221733.GA16260@havoc.gtf.org> <alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org> <480E6DE5.6010103@garzik.org> <alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org> <480E796E.4070001@garzik.org>
 <alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org> <20080423000529.GG28933@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org> <480F3ECC.1090809@keyaccess.nl> <480FEC1B.6040102@garzik.org>
 <alpine.LFD.1.10.0804231914270.2779@woody.linux-foundation.org> <m1od7zkd2s.fsf@frodo.ebiederm.org> <481066C1.1030805@garzik.org> <alpine.LFD.1.10.0804240806500.2779@woody.linux-foundation.org> <4810A9E6.1080201@garzik.org>
 <alpine.LFD.1.10.0804240847230.2779@woody.linux-foundation.org> <m1r6cvgpw2.fsf@frodo.ebiederm.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Apr 2008, Eric W. Biederman wrote:
> 
> Right now the irq number is very much an array index and that
> property is limiting.

That's simply not true. 

You are looking at some implementation detail, but other architectures 
have used other notions.

The number is just that: a number. Nothing else. If you think it's an 
array index, you are looking at it in all the wrong ways.

So you're now complaining about somethign totally different than the type, 
you're talking about simple implementation issues.

And the reason it's generally implemented as a vector is very simple: it's 
basic to the whole notion that the hardware gives us some cookie (which 
itself is _often_ a small number, but sometimes is something that we can 
program), and we want to look up that cookie into our internal irq 
handling data structures.

So even when we can program the hw cookie arbitrarily (eg MSI), we 
actually tend to *want* to program it with something we can use as an 
array index, simply because that's often the best way to then map the 
hardware cookie into the internal "struct irq_desc" things.

So your argument MAKES ABSOLUTELY NO SENSE!

The reason we use something that _looks_ like an array index is that we 
ourself (and hardware) MADE IT SO.

It has absolutely nothing to do with the type of "irq". Even if "irq" was 
a pointer to a struct, we'd *still* want to have that array-index-like 
thing, and the only thing you could do would be to then use an extra level 
of indirection to turn it into something else!

So "irq" looks like an array index because we _avoid_ the indirection 
(except for the lookup of "irq_desc", which we absolutely do NOT want to 
expose to drivers!)

Your argument is utter crap, in other words. It makes no sense.

			Linus
