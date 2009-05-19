Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbZESPBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbZESPBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 11:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbZESPBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 11:01:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:39109 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbZESPBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 11:01:46 -0400
Subject: Re: [PATCH 3/10 -tip] x86: Add cpufeatures for Advanced Power
 Management
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
In-Reply-To: <alpine.LFD.2.00.0905171415150.3516@localhost.localdomain>
References: <1242142530.2547.11.camel@ht.satnam>
	 <1242142623.2547.13.camel@ht.satnam>  <1242142692.2547.15.camel@ht.satnam>
	 <1242142753.2547.16.camel@ht.satnam> <1242155190.2492.73.camel@ht.satnam>
	 <alpine.LFD.2.00.0905122219420.3561@localhost.localdomain>
	 <1242395277.3082.24.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0905171415150.3516@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 19 May 2009 20:31:12 +0530
Message-Id: <1242745272.3169.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

On Sun, 2009-05-17 at 14:17 +0200, Thomas Gleixner wrote:
> On Fri, 15 May 2009, Jaswinder Singh Rajput wrote:
> > > Do you really believe that open-coding x86_capability[9] in .../common.c
> > > is better than the open-coding in ../powernow-k8.c ?
> > > 
> > 
> > BTW, then how you can set x86_capability[9] in one shot ? do you want me
> > to set each bit with set_cpu_cap() ?
> 
> Using "9" as an array index is the point. This needs to be a constant
> near the other constants which describe the bits and a big fat comment.
> 

You mean these should also use constant and big fat comment :

arch/x86/include/asm/elf.h:#define ELF_HWCAP            (boot_cpu_data.x86_capability[0])
arch/x86/kernel/cpu/centaur.c:          c->x86_capability[5] = cpuid_edx(0xC0000001);
arch/x86/kernel/cpu/common.c:           c->x86_capability[0] = capability;
arch/x86/kernel/cpu/common.c:           c->x86_capability[4] = excap;
arch/x86/kernel/cpu/common.c:                   c->x86_capability[1] = cpuid_edx(0x80000001);
arch/x86/kernel/cpu/common.c:                   c->x86_capability[6] = cpuid_ecx(0x80000001);
arch/x86/kernel/cpu/transmeta.c:                        c->x86_capability[2] = cpuid_edx(0x80860001);
arch/x86/kernel/cpu/transmeta.c:        c->x86_capability[0] = cpuid_edx(0x00000001);
arch/x86/kernel/mpparse.c:      processor.featureflag = boot_cpu_data.x86_capability[0];
arch/x86/lguest/boot.c: new_cpu_data.x86_capability[0] = cpuid_edx(1);
arch/x86/xen/enlighten.c:       new_cpu_data.x86_capability[0] = cpuid_edx(1);

So should I also make constant for all x86_capability.

Peter, Ingo:
Do you think we need to arrange x86_capability in some order, currently
we are using x86_capability numbering in random order.

Thanks,
--
JSR

