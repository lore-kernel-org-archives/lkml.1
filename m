Return-Path: <linux-kernel-owner+w=401wt.eu-S1760827AbZLKK3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760827AbZLKK3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760757AbZLKK3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:29:38 -0500
Received: from mail2.picochip.com ([82.111.145.34]:40710 "EHLO
	thurne.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760655AbZLKK3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:29:35 -0500
Date: Fri, 11 Dec 2009 10:30:30 +0000
From: Jamie Iles <jamie.iles@picochip.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jamie Iles <jamie.iles@picochip.com>, linux-kernel@vger.kernel.org,
       Russell King <linux@arm.linux.org.uk>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] perf tools: allow building for ARM
Message-ID: <20091211103030.GC4164@wear.picochip.com>
References: <1260523260-15694-1-git-send-email-jamie.iles@picochip.com> <20091211102316.GB16882@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211102316.GB16882@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (thurne.picochip.com [172.17.0.105]); Fri, 11 Dec 2009 10:29:15 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 11:23:16AM +0100, Ingo Molnar wrote:
> cpu_relax() looks fine, but rmb() seems not to match the one that can be 
> found in arch/arm/:
> 
> arch/arm/include/asm/system.h:#define rmb()		dmb()
> arch/arm/include/asm/system.h:#define rmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
> arch/arm/include/asm/system.h:#define smp_rmb()	rmb()
> 
> arch/arm/include/asm/system.h:#define dmb() __asm__ __volatile__ ("dmb" : : : "memory")
> arch/arm/include/asm/system.h:#define dmb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 5" \
> arch/arm/include/asm/system.h:#define dmb() __asm__ __volatile__ ("" : : : "memory")
> arch/arm/include/asm/system.h:#define dmb() __asm__ __volatile__ ("" : : : "memory")
The implementation of the barriers depend on the CPU arch revision which is
defined in the kernel config. As the perf tools don't use the kernel config,
we don't know here what arch revision we're building for. Perhaps we need a
LINUX_ARM_ARCH parameter when building for ARM so we can pick the correct one.

Jamie
