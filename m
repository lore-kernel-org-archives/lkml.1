Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZJNGSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZJNGSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZJNGSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:18:10 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:43446 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbZJNGSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:18:09 -0400
Date: Wed, 14 Oct 2009 11:47:27 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
       linux-acpi@vger.kernel.org, Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [v8 PATCH 2/8]: cpuidle: implement a list based approach to
	register a set of idle routines.
Message-ID: <20091014061727.GA8605@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20091008094828.GA20595@linux.vnet.ibm.com> <20091008095027.GC20595@linux.vnet.ibm.com> <1254998162.26976.270.camel@twins> <20091008104249.GJ20595@linux.vnet.ibm.com> <1254999033.26976.272.camel@twins> <8763akh4re.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <8763akh4re.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org> [2009-10-12 20:00:05]:

> Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> >
> > So does it make sense to have a set of sets?
> >
> > Why not integrate them all into one set to be ruled by this governor
> > thing?
> 
> cpuidle is currently optional, that is why the two level hierarchy
> is there so that you can still have simple idle selection without it.
> 
> % size drivers/cpuidle/*.o
>    text    data     bss     dec     hex filename
>    5514    1416      44    6974    1b3e drivers/cpuidle/built-in.o
> 
> Adding it unconditionally would add ~7k to everyone who wants idle functions.
> 
> I think making it unconditional would require putting it on a serious
> diet first.
> 

Hi Andi,

Yes, this is a valid point.

How about something like this..
If the arch does not enable CONFIG_CPU_IDLE, the cpuidle_idle_call
which is called from cpu_idle() should call default_idle without
involving the registering cpuidle steps. This should prevent bloating
up of the kernel for archs which dont want to use cpuidle.

--arun
> -Andi
> -- 
> ak@linux.intel.com -- Speaking for myself only.
