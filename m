Return-Path: <linux-kernel-owner+w=401wt.eu-S1161312AbXCBH15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161312AbXCBH15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 02:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161313AbXCBH15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 02:27:57 -0500
Received: from koto.vergenet.net ([210.128.90.7]:58006 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161312AbXCBH14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 02:27:56 -0500
Date: Fri, 2 Mar 2007 16:23:48 +0900
From: Horms <horms@verge.net.au>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, judith@linux-foundation.org,
       fastboot@lists.osdl.org, ebiederm@xmission.com, ak@suse.de
Subject: Re: [Fastboot] [PATCH RFC 0/5] hard_smp_processor_id overhaul
Message-ID: <20070302072348.GC21694@verge.net.au>
References: <1172733373.1498.264.camel@sebastian.intellilink.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1172733373.1498.264.camel@sebastian.intellilink.co.jp>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 04:16:13PM +0900, Fernando Luis Vázquez Cao wrote:
> With the advent of kdump, the assumption that the boot CPU when running
> an UP kernel is always the CPU with a hardware ID of 0 (usually referred
> to as BSP on some architectures) does not hold true anymore. The reason
> being that the dump capture kernel boots on the crashed CPU (the CPU
> that invoked crash_kexec).
> 
> As a consequence, the hardcoding of hard_smp_processor_id() to 0 on UP
> systems (see "linux/smp.h") is not correct.
> 
> This patch-set does the following:
> 
> 1- Remove hardcoding of hard_smp_processor_id on UP systems.
> 
> 2- Ask the hardware when possible to obtain the hardware processor id on
> i386, x86_64, and ia64, independently of whether CONFIG_SMP is set or
> not.
> 
> 3- Move definition of hard_smp_processor_id for the UP case to asm/smp.h
> on alpha, m32r, powerpc, s390, sparc, sparc64, and um architectures. I
> guess that hardware features could be used to implement
> hard_smp_processor_id even in the UP case, but since I am not an expert
> in this architectures I just move the definition.
> 
> The patches have been tested on i386, x86_64, and ia64.

Hi Fernando,

These patches seem find to me. Tested on ia64 (Tiger2)

Acked: Simon Horman <horms@verge.net.au>
