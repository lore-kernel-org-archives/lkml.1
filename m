Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbYFZStr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbYFZStr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbYFZStf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:49:35 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:57093 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbYFZStd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:49:33 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jun 2008 14:49:33 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=Cg5Ia570oqkw9s3S0u2iRnjl3SJhSkMPwVoDU0z36FyiAFhEc9eKsGWR1H7J4i5H4
	+CiD1QAm/u0SoVYuz0YbQDRXwB7wkPx3KyY1Og/FE4WokOXBiQbZRK8m4hhY7GkHRcO
	AItMGSmsvjVIbeI1nvkd5c2R/XybFtqiJegAEI0=
Message-ID: <4863E414.4090303@seznam.cz>
Date: Thu, 26 Jun 2008 20:46:44 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: monstr@seznam.cz, linux-kernel@vger.kernel.org, arnd@arndb.de,
       linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com
Subject: Re: [PATCH 02/60] microblaze_v4: Makefiles for Microblaze cpu
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <1214483429-32360-2-git-send-email-monstr@seznam.cz> <1214483429-32360-3-git-send-email-monstr@seznam.cz> <20080626143623.GC30954@cs181140183.pp.htv.fi>
In-Reply-To: <20080626143623.GC30954@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Smtpd: 1.1.1@13338
X-Seznam-User: monstr@seznam.cz
X-QM-Mark: email-qm5<124724268>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk napsal(a):
> On Thu, Jun 26, 2008 at 02:29:31PM +0200, monstr@seznam.cz wrote:
>> ...
>> --- /dev/null
>> +++ b/arch/microblaze/Makefile
>> ...
>> +# Work out HW multipler support.  This is icky.
>> +# 1. Spartan2 has no HW multiplers.
>> +# 2. MicroBlaze v3.x always uses them, except in Spartan 2
>> +# 3. All other FPGa/CPU ver combos, we can trust the CONFIG_ settings
>> +ifeq (,$(findstring spartan2,$(CONFIG_XILINX_MICROBLAZE0_FAMILY)))
>> +  ifeq ($(CPU_MAJOR),3)
>> +    CPUFLAGS-1 += -mno-xl-soft-mul
>> +  else
>> +    # USE_HW_MUL can be 0, 1, or 2, defining a heirarchy of HW Mul support.
>> +    CPUFLAGS-$(subst 1,,$(CONFIG_XILINX_MICROBLAZE0_USE_HW_MUL)) += -mxl-multiply-high
>> +    CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_HW_MUL) += -mno-xl-soft-mul
>> +  endif
>> +endif
>> +CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_DIV) += -mno-xl-soft-div
>> +CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_BARREL) += -mxl-barrel-shift
>> +CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_PCMP) += -mxl-pattern-compare
>> +
>> +CPUFLAGS-1 += $(call cc-option,-mcpu=v$(CPU_VER))
>> +
>> +# The various CONFIG_XILINX cpu features options are integers 0/1/2...
>> +# rather than bools y/n
>> +CFLAGS += $(CPUFLAGS-1)
>> +CFLAGS += $(CPUFLAGS-2)
>> ...
> 
> Why are the options not bools?
> 
> cu
> Adrian

because CONFIG_XILINX_... are 0, 1 or 2 not only y, n.

M
