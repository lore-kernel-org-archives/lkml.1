Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbXFNI0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbXFNI0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 04:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXFNI0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 04:26:33 -0400
Received: from il.qumranet.com ([82.166.9.18]:59575 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbXFNI0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 04:26:32 -0400
Message-ID: <4670FBB5.70707@qumranet.com>
Date: Thu, 14 Jun 2007 11:26:29 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
References: <20070604202248.GA18668@dreamland.darkstar.lan> <46647B3E.2090205@qumranet.com> <20070604212207.GA22365@dreamland.darkstar.lan> <46651069.5040003@qumranet.com> <68676e00706071216i4bd051c5hb1c114f3c13ab97f@mail.gmail.com> <466BED18.5040708@qumranet.com> <68676e00706101354n5fe7e1a9y12cb690cae2924e3@mail.gmail.com> <466CFD6D.2080201@qumranet.com> <20070612175246.GA5864@dreamland.darkstar.lan> <466FB1ED.3090905@qumranet.com> <20070613204948.GA14710@dreamland.darkstar.lan>
In-Reply-To: <20070613204948.GA14710@dreamland.darkstar.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Tettamanti wrote:
> With GOOD_APIC apic_read_around is a nop, while apic_write_around is a
> normal write. With !GOOD_APIC apic_write_around writes to the APIC reg
> using xchg. With !GOOD_APIC and this patch:
>
> --- include/asm-i386/apic.h~	2007-04-26 05:08:32.000000000 +0200
> +++ include/asm-i386/apic.h	2007-06-13 22:35:00.000000000 +0200
> @@ -56,7 +56,8 @@
>  static __inline fastcall void native_apic_write_atomic(unsigned long reg,
>  						       unsigned long v)
>  {
> -	xchg((volatile unsigned long *)(APIC_BASE+reg), v);
> +//	xchg((volatile unsigned long *)(APIC_BASE+reg), v);
> +	*((volatile unsigned long *)(APIC_BASE+reg)) = v;
>  }
>  
>  static __inline fastcall unsigned long native_apic_read(unsigned long reg)
>
> The kernel boots fine. 
>   

Looking at the xchg emulation code, it seems fine, but clearly it 
isn't.  Can you add logging to the kernel apic driver and to the qemu 
device emulation (qemu/hw/apic.c, apic_mem_readl()/apic_mem_writel()) 
and compare the results?

-- 
error compiling committee.c: too many arguments to function

