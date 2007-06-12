Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbXFLTOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbXFLTOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 15:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbXFLTN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 15:13:56 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:35347 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbXFLTNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 15:13:55 -0400
X-IronPort-AV: i="4.16,412,1175497200"; 
   d="scan'208"; a="493044761:sNHT46682804"
To: linux-kernel@vger.kernel.org,
       "Natalie.Protasevich@unisys.com" <Natalie.Protasevich@unisys.com>,
       Vivek Goyal <vgoyal@in.ibm.com>
Cc: akpm@linux-foundation.org
Subject: CONFIG_X86_ES7000=y, CONFIG_X86_GENERICARCH=n, CONFIG_ACPI=y build broken
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 12 Jun 2007 12:13:50 -0700
Message-ID: <adad5017zpt.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Jun 2007 19:13:51.0174 (UTC) FILETIME=[CF9A4E60:01C7AD25]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(sending to Vivek since he seems to be one of the last people to touch
this code)

For some strange reason I found myself compiling a kernel with
CONFIG_X86_ES7000 and CONFIG_ACPI set and CONFIG_X86_GENERICARCH not
set.  It died with

    arch/i386/kernel/built-in.o: In function `acpi_parse_madt':
    boot.c:(.init.text+0x68b7): undefined reference to `acpi_madt_oem_check'
    arch/i386/kernel/built-in.o: In function `get_smp_config':
    (.init.text+0x9f98): undefined reference to `mps_oem_check'
    arch/i386/kernel/built-in.o: In function `connect_bsp_APIC':
    (.init.text+0xa340): undefined reference to `enable_apic_mode'
    arch/i386/kernel/built-in.o: In function `connect_bsp_APIC':
    (.init.text+0xa370): undefined reference to `enable_apic_mode'

this seems to be because eg acpi_madt_oem_check() and mps_oem_check()
are defined in arch/i386/mach-generic/es7000.c, but arch/i386/Makefile
only goes into mach-generic if CONFIG_X86_GENERICARCH is set.
I didn't track down why enable_apic_mode is broken yet.

No patch because I don't understand how this subarch stuff is supposed
to build :(

 - R.
