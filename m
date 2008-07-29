Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbYG2J3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbYG2J3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 05:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYG2J30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 05:29:26 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:4733 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbYG2J3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 05:29:25 -0400
Date: Tue, 29 Jul 2008 11:28:47 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Is topology_core_siblings for use by drivers?
Message-ID: <20080729092847.GA5324@osiris.boeblingen.de.ibm.com>
References: <20080729071422.GD28989@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729071422.GD28989@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 01:14:22AM -0600, Matthew Wilcox wrote:
> 
> allmodconfig currently dies with:
> 
> ERROR: "cpu_core_map" [drivers/net/sfc/sfc.ko] undefined!
> 
> $ grep -r cpu_core_map include/asm-ia64/
> include/asm-ia64/smp.h:extern cpumask_t cpu_core_map[NR_CPUS];
> include/asm-ia64/topology.h:#define topology_core_siblings(cpu) (cpu_core_map[cpu])
> 
> OK ... it's not exported to modules.  Do other architectures have this
> problem?
> 
> $ grep topology_core_siblings include/asm-*/topology.h
> include/asm-ia64/topology.h:#define topology_core_siblings(cpu) (cpu_core_map[cpu])
> include/asm-powerpc/topology.h:#define topology_core_siblings(cpu) (per_cpu(cpu_core_map, cpu))
> include/asm-s390/topology.h:#define topology_core_siblings(cpu) (cpu_core_map[cpu])
> include/asm-x86/topology.h:#define topology_core_siblings(cpu) (per_cpu(cpu_core_map, cpu))
> 
> s390, I guess.  But they don't have PCI device drivers.

Yes, luckily it doesn't get compiled on s390. Btw. the for_each_online_cpu
loop where this gets used doesn't seem to be save wrt cpu hotplug.
