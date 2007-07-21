Return-Path: <linux-kernel-owner+w=401wt.eu-S1765428AbXGUM27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765428AbXGUM27 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 08:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762391AbXGUM2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 08:28:51 -0400
Received: from ns.suse.de ([195.135.220.2]:54076 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762340AbXGUM2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 08:28:50 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86_64: use apic core id bits for core nums
Date: Sat, 21 Jul 2007 14:28:46 +0200
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>, joachim.deguara@amd.com,
       linux-kernel@vger.kernel.org
References: <86802c440707210056s745d44f1jc6437064741299eb@mail.gmail.com> <200707211022.47859.ak@suse.de> <86802c440707210421h33a4fa50n9856bfe95e5b386f@mail.gmail.com>
In-Reply-To: <86802c440707210421h33a4fa50n9856bfe95e5b386f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707211428.46711.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 July 2007 13:21:34 Yinghai Lu wrote:
> On 7/21/07, Andi Kleen <ak@suse.de> wrote:
> > On Saturday 21 July 2007 09:56:15 Yinghai Lu wrote:
> > > please check my version, we should use core id bits instead.
> > >
> > > it should replace
> > > [PATCH for review] [37/48] x86_64: make k8topology multi-core aware
> >
> > Yes, you're right the patch is not good. It should probably use
> > information from the regular CPU setup code, not touch cpuid
> > directly
> 
> need move some code into early_identify_cpu from identify_cpu in
> arch/x86_64/kernel/setup.c
> then could use that bits in bsp cpu info.

Yes something like this
 
> BTW:
> it seems for BSP only early_identify_cpu is called, and identify_cpu
> is only use in smp_callin for AP. Do i miss sth.

identify_cpu calls early_identify_cpu as first thing.

-Andi

