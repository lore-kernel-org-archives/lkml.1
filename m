Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYCHMf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYCHMf2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 07:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbYCHMfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 07:35:20 -0500
Received: from 1wt.eu ([62.212.114.60]:2326 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbYCHMfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 07:35:19 -0500
Date: Sat, 8 Mar 2008 13:34:36 +0100
From: Willy Tarreau <w@1wt.eu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Chris Snook <csnook@redhat.com>,
       Andrew Buehler <abuehler.kernel@gmail.com>,
       Frederik Deweerdt <deweerdt@free.fr>, belcampo <belcampo@zonnet.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: Hyperthreading performance oddities
Message-ID: <20080308123436.GA24982@1wt.eu>
References: <47BE9781.3030304@zonnet.nl> <20080222100630.GE5906@slug> <47D14526.2070103@gmail.com> <47D192BF.5090501@redhat.com> <87zltae3y7.fsf@basil.nowhere.org> <20080308073000.GH8953@1wt.eu> <20080308114655.GB27074@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080308114655.GB27074@one.firstfloor.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2008 at 12:46:55PM +0100, Andi Kleen wrote:
> > Well, in my experience, except for compiling, HT has always caused
> > massive slowdowns, especially on network-intensive applications.
> > Basically, network perf took a 20-30% hit, while compiling took
> 
> What network workload?

high session rate HTTP traffic. That means high packet rates, high
session lookup rates, etc...

> Networking tends to have a lot of cache misses
> and unless you're exceeding your memory bandwidth HT normally does 
> well on such workloads because it can do other things while the 
> CPU is waiting for loads.

On SMP, the load is generally divided with user-space on once CPU
and IRQs on the other one, but not well balanced though (less IRQ),
which means that SMP is rarely more than 50-60% faster than UP. On
HT, I normally observe lower performance than on UP.

> > 20-30% boost. But I must admit that I never tried HT on anything
> > more recent than a P4, maybe things have changed since.
> 
> There's nothing more recent out yet (unless you're talking non x86), 
> but there were many different P4 generations. In particular Prescott
> (90nm) was quite different from the earlier ones, but even before
> and after there were some improvements and changes.

OK. Amusingly, the HT flag is present on my C2D E8200 :

model name      : Intel(R) Core(TM)2 Duo CPU     E8200  @ 2.66GHz
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pni monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr lahf_lm

Cheers,
willy

