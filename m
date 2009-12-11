Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbZLKKXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbZLKKXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756365AbZLKKX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:23:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58925 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756310AbZLKKX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:23:28 -0500
Date: Fri, 11 Dec 2009 11:23:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jamie Iles <jamie.iles@picochip.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] perf tools: allow building for ARM
Message-ID: <20091211102316.GB16882@elte.hu>
References: <1260523260-15694-1-git-send-email-jamie.iles@picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260523260-15694-1-git-send-email-jamie.iles@picochip.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jamie Iles <jamie.iles@picochip.com> wrote:

> +#ifdef __arm__
> +#include "../../arch/arm/include/asm/unistd.h"
> +#define rmb()		asm volatile("":::"memory")
> +#define cpu_relax()	asm volatile("":::"memory")
> +#endif

cpu_relax() looks fine, but rmb() seems not to match the one that can be 
found in arch/arm/:

arch/arm/include/asm/system.h:#define rmb()		dmb()
arch/arm/include/asm/system.h:#define rmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
arch/arm/include/asm/system.h:#define smp_rmb()	rmb()

arch/arm/include/asm/system.h:#define dmb() __asm__ __volatile__ ("dmb" : : : "memory")
arch/arm/include/asm/system.h:#define dmb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 5" \
arch/arm/include/asm/system.h:#define dmb() __asm__ __volatile__ ("" : : : "memory")
arch/arm/include/asm/system.h:#define dmb() __asm__ __volatile__ ("" : : : "memory")

	Ingo
