Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbZKDMWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbZKDMWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 07:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbZKDMWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 07:22:51 -0500
Received: from www84.your-server.de ([213.133.104.84]:56678 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbZKDMWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:22:50 -0500
Subject: Re: [PATCH] update fix X86_64 procfs provide stack information for
 threads
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <20091104120019.GK31511@one.firstfloor.org>
References: <1257233486.22553.6.camel@wall-e>
	 <874opaa68v.fsf@basil.nowhere.org> <1257335404.2123.29.camel@wall-e>
	 <20091104120019.GK31511@one.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 04 Nov 2009 13:22:49 +0100
Message-ID: <1257337369.5594.15.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 04.11.2009, 13:00 +0100 schrieb Andi Kleen:
> > This is true, but i think it is better to get an outdated value than a
> > complete wrong value like -1.
> 
> -1 means "I don't know".  I don't think "completely wrong" 
> is the correct term to describe that.
>  
> > The truth is that KSTK_ESP always return an outdated value on a multi
> > core system if the process never do a system call.
> 
> I think not supporting updates on interrupts at least is very poor.
> Unfortunately there's no good way fast path way to detect this I know of
> (that is why I originally added -1 here)
> 

I am sorry, i did not know that was your code. But anyway.

> 
> > Question: is task_pt_regs(task)->sp set in 64 bit mode when the process
> > is blocked in an interrupt? If true, we can add two additional assembly
> > instruction to the system call handler and store the stack pointer into
> > this. Than KSTK_ESP wil be again a simple macro like
> 
> You want to add instructions to one of the hottest kernel paths
> for this hyper-obscure application?  Bad idea.
> 

You complain that the the value is outdated and i told you how you can
get a more accuracy value. I agree that this is bad idea.
 

> My recommendation would be to just deprecate this proc field
> and if anyone really wants that information they can use
> a trivial ptrace() based user program.
> 

I spend a lot of time doing this, it would be nice to give it a change a
fix the KSTK_ESP macro. It will be not only used by my code. It would be
great if we can do this together. 

You have the knowledge, so i will ask my question again:
Is task_pt_regs(task)->sp set in 64 bit mode when the process is block
in an interrupt? 
Is there a way to detected if a process is blocked by an interrupt?

If you answer both with true than i can fix KSTK_ESP without performance
penalty for the rest of the system.

Stefani


