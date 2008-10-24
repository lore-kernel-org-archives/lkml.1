Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbYJXSSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbYJXSSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbYJXSSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:18:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34638 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbYJXSSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:18:42 -0400
Message-ID: <4902116B.50509@redhat.com>
Date: Fri, 24 Oct 2008 14:18:19 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Kumar Gala <galak@kernel.crashing.org>,
       LinuxPPC-dev list <linuxppc-dev@ozlabs.org>, tglx@linutronix.de,
       linux-kernel Kernel <linux-kernel@vger.kernel.org>, maxk@qualcomm.com
Subject: Re: default IRQ affinity change in v2.6.27 (breaking several SMP
 PPC	based systems)
References: <4E3CD4D5-FC1B-40BF-A776-C612B95806B8@kernel.crashing.org>	<4901E6FB.4070200@redhat.com>	<36A821E7-7F37-42AF-9A05-7205FCBF89EE@kernel.crashing.org>	<4901F31E.9040007@redhat.com> <5967704E-0117-46B8-8505-6A002502C38C@kernel.crashing.org> <4902086E.6030900@freescale.com>
In-Reply-To: <4902086E.6030900@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood wrote:
> Kumar Gala wrote:
>> So why not just have x86 startup code set irq_default_affinity = 
>> CPU_MASK_ALL than?
> 
> That doesn't really solve the problem, as a user could still manually 
> set an invalid affinity.  The MPIC driver should reduce the affinity 
> itself to what the hardware can handle.

Does the MPIC code actually allow that to happen?  I can't quite tell, but I 
noticed this:

[csnook@bernoulli sysdev]$ fgrep '#ifdef CONFIG_' mpic.c | sort -u
#ifdef CONFIG_IRQ_ALL_CPUS
#ifdef CONFIG_MPIC_BROKEN_REGREAD
#ifdef CONFIG_MPIC_U3_HT_IRQS
#ifdef CONFIG_MPIC_WEIRD
#ifdef CONFIG_PCI_MSI
#ifdef CONFIG_PM
#ifdef CONFIG_PPC32     /* XXX for now */
#ifdef CONFIG_PPC_DCR
#ifdef CONFIG_SMP

Do any of those config options (or combinations thereof) imply an MPIC that 
can't handle an IRQ masked to multiple CPUs?  If so, this can be fixed rather 
easily at build time, without having to muck around with arch-specific 
initialization code.

-- Chris
