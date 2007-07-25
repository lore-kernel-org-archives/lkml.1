Return-Path: <linux-kernel-owner+w=401wt.eu-S934387AbXGYRX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934387AbXGYRX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765824AbXGYRXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:23:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:55382 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761124AbXGYRXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:23:45 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Cedric Le Goater <clg@fr.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc1-mm1
Date: Wed, 25 Jul 2007 13:23:04 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Shaohua Li <shaohua.li@intel.com>
References: <20070725040304.111550f4.akpm@linux-foundation.org> <46A7411C.80202@fr.ibm.com>
In-Reply-To: <46A7411C.80202@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707251323.04594.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2007 08:25, Cedric Le Goater wrote:
> Hello,
> 
> Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/
> 
> I'm having issue compiling on i386 and x86_64. 
> 
> make defconfig on i386  :
> 
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o(.text+0x9649): In function `acpi_pci_choose_state':
> : undefined reference to `acpi_pm_device_sleep_state'
> drivers/built-in.o(.text+0x3b2f5): In function `pnpacpi_suspend':
> : undefined reference to `acpi_pm_device_sleep_state'
> 
> probably this commit fd4aff1a28eecbd729b409bf7d3eff5948f20414 in the acpi tree.

Looks like mm's git-acpi.patch is missing a few things that are in the latest acpi tree.
Apparently I exposed this issue to Andrew before I exposed the fix, and he got the
former, but not the later -- my fault.

The root problem is that CONFIG_ACPI_SLEEP is not set in defconfig,
and it is not set because CONFIG_SMP=y, but CONFIG_HOTPLUG_CPU=n

So tweaking that will get i386 and x86_64 building.  However, it will not fix ia64.
For that, the changes in the latest acpi tree are necessary.

Andrew, you want to re-pull the acpi tree, or do you want me to send
you some patches on top of the current mm?

-Len
