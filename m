Return-Path: <linux-kernel-owner+w=401wt.eu-S1760702AbXFGHqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702AbXFGHqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbXFGHqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:46:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:34726 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbXFGHq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:46:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,393,1175497200"; 
   d="scan'208";a="254207364"
Subject: Re: Documentation - How to debug ACPI Problems
From: Zhang Rui <rui.zhang@intel.com>
To: trenn@suse.de
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger" <linux-acpi@vger.kernel.org>
In-Reply-To: <1181140008.28514.259.camel@queen.suse.de>
References: <1181140008.28514.259.camel@queen.suse.de>
Content-Type: text/plain
Date: Sat, 03 Jan 2004 06:32:46 +0800
Message-Id: <1073082766.5397.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 16:26 +0200, Thomas Renninger wrote:
> 
> 3. Problem Analysis and Solving
> -------------------------------
> 
> 3.1. I see Warnings or Errors when disassembling or compiling my DSDT
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> 
> Some might be sever ACPICA or BIOS bugs, some might just be incompatibilities
> with the Microsoft compiler. We want to fix both, therefore a bug should be
> filed at bugzilla.kernel.org
> In general you should watch your system, if you don't miss any functionality
> there is no reason to panic (e.g. modify the DSDT and override your original
> one, you really should not do that if you do not see any big advantage and even
> then, better try to get a real fix or at least a kernel workaround like a
> boot or module parameter).
> 
> You should be able to debug this with userspace tools (See:
> "1.2. Useful Userspace Tools for Table Playing")
> 
> 
> 3.2) Hardware accessed by ACPI is not working correctly - Using ACPI_DEBUG
3.2. typo

> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> 
> If you expect the bug in a module in drivers/acpi/*.c code you might have luck
> and be able to find or narrow down the culprit by simple printks.
> 
> On more complicated bugs you should make use of the ACPI_DEBUG=y facility.
> This allows you to fine grain enable specific output in the ACPI interpreter.
> 
> 
>    3.2.1 Using ACPI_DEBUG Boot Parameters acpi.debug_level and acpi.debug_layer
> 
>          Note: In kernel versions before 2.6.22 the boot parameters are:
> 	       acpi_dbg_level and acpi_dbg_layer
> 
>          ACPI can produce tons of debug output if these debug masks are
>          switched to full on.
> 	 include/acpi/acoutput.h shows which flags can be enabled for level and
>          layer (cat /proc/acpi/debug_{level,layer} also shows you the flags,
> 	 but that interface will move to sysfs, not sure whether there still
> 	 will be such a help).
They work in the same way as they do in procfs.
i.e. cat /sys/module/acpi/parameters/debug_{level,layer}
shows you the flags as well.
In fact, I think they can replace the proc I/F right now.

> 
>          Therefore, switch on debug flags carefully. You also might want to
> 	 increase the kernel ring buffer by passing:
> 	 log_buf_len=XY in bytes and later use dmesg -s XY to get more than
> 	 16k kernel log output.
> 	 Instead of serial console logging you might want to use the netconsole
> 	 interface (Documentation/networking/netconsole.txt) to write away
>          syslog messages over network or firescope (patches already exist in
>          2.6.22-rcX-mm?) to send syslog messages over firewire.
> 	 The latter might be the only way to debug early hangs on laptops
> 	 without serial console anyway.
> 
>    3.2.2 Using ACPI_DEBUG Boot Parameters via /sysfs and /proc
> 
> 	 The same as 3.2.1., you can also pass the parameters at runtime e.g.
> 	 via:
> 	 echo 0x1F >/proc/acpi/debug_level    # before 2.6.22 or
>          echo ?!?  >/sys/?/!/?                # Rui?
echo 0x1F >/sys/module/acpi/parameters/debug_level

And we still support the ACPI debug proc I/F at the current stage.


Thanks,
Rui
