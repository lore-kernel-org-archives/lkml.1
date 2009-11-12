Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZKLSLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZKLSLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbZKLSLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:11:14 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:45291 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbZKLSLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:11:13 -0500
Date: Thu, 12 Nov 2009 10:09:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-next@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, lenb@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: linux-next: Tree for November 12
 (acpi_processor_get_bios_limit)
Message-Id: <20091112100956.fc72080e.randy.dunlap@oracle.com>
In-Reply-To: <20091112094012.2ef401ad.randy.dunlap@oracle.com>
References: <20091112195101.63263490.sfr@canb.auug.org.au>
	<20091112094012.2ef401ad.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4AFC4FA3.00EB:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009 09:40:12 -0800 Randy Dunlap wrote:

> On Thu, 12 Nov 2009 19:51:01 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20091111:
> > 
> > The cpufreq tree gained a conflict against the acpi tree.
> 
> when CONFIG_CPU_FREQ=n:
> 
> arch/x86/kernel/acpi/processor.o: In function `acpi_processor_get_bios_limit':
> (.text+0x0): multiple definition of `acpi_processor_get_bios_limit'
> arch/x86/kernel/acpi/cstate.o:(.text+0x0): first defined here
> 
> 
> The function definition in include/apci/procssor.h needs to be "static inline"
> at line 323.

---
however, even with that fixed, when

CONFIG_CPU_FREQ=y
CONFIG_ACPI=n
CONFIG_SFI=y
CONFIG_APM=y

there is this build error:

arch/x86/kernel/cpu/cpufreq/powernow-k7.c:720: error: 'acpi_processor_get_bios_limit' undeclared here (not in a function)

---
~Randy
