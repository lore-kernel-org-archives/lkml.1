Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbXEOXpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbXEOXpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 19:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757694AbXEOXpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 19:45:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756051AbXEOXpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 19:45:07 -0400
Date: Tue, 15 May 2007 16:42:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org, clameter@sgi.com
Subject: Re: [PATCH 1/2] Define percpu smp cacheline align interface
Message-Id: <20070515164251.f23f8b2e.akpm@linux-foundation.org>
In-Reply-To: <20070507225841.GA13872@linux-os.sc.intel.com>
References: <33E1C72C74DBE747B7B59C1740F7443701A2F0AB@orsmsx417.amr.corp.intel.com>
	<20070505001218.GA27093@linux-os.sc.intel.com>
	<20070507225841.GA13872@linux-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007 15:58:41 -0700
Fenghua Yu <fenghua.yu@intel.com> wrote:

> On Fri, May 04, 2007 at 05:12:18PM -0700, Fenghua Yu wrote:
> > 
> > Define percpu smp cacheline align interface
> 
> This is updated patch. Per cpu cacheline aligned data section name and macro name are changed to have better code understanding.
> 
> The patches place all of smp cacheline aligned percpu data into .data.percpu.shared_cacheline_aligned. Other percpu data is still in data.percpu section. The patches can reduce cache line access in SMP and reduce alignment gap waste. The patches also define PERCPU macro for vmlinux.lds.S for concise code.
> 
> PATCH 1/2: Define percpu smp cacheline align interface
> PATCH 2/2: Call percpu smp cacheline algin interface

For some reason arm exploded.

/opt/crosstool/gcc-3.4.5-glibc-2.3.6/arm-unknown-linux-gnu/bin/arm-unknown-linux-gnu-ld:arch/arm/kernel/vmlinux.lds:327: parse error

  __con_initcall_start = .;
   *(.con_initcall.init)
  __con_initcall_end = .;
  __security_initcall_start = .;
   *(.security_initcall.init)
  __security_initcall_end = .;

  . = ALIGN(32);
  __initramfs_start = .;
   usr/built-in.o(.init.ramfs)
  __initramfs_end = .;

  . = ALIGN(4096); __per_cpu_start = .; .data.percpu : AT(ADDR(.data.percpu) - 0) { *(.data.percpu) *(.data.percpu.shared_cacheline_aligned) } __per_cpu_end = .;






 }

Seems I don't have the latest version any more so I'll drop it.
