Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbYAGWsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbYAGWsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 17:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbYAGWsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 17:48:03 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:1489 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbYAGWsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 17:48:01 -0500
Date: Mon, 7 Jan 2008 23:47:57 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       akpm@osdl.org, jbarnes@virtuousgeek.org, rajesh.shah@intel.com,
       greg@kroah.com
Subject: MCFG ACPI patch in git-x86 causes boot regression
Message-ID: <20080107224757.GA2336@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 07 Jan 2008 22:41:50.0357 (UTC) FILETIME=[7E1C4450:01C8517E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch

commit c5182babd1d0706f1294af7b8dbf64e378b066bb
Author: Robert Hancock <hancockr@shaw.ca>
Date:   Sat Jan 5 13:26:32 2008 +0100

    x86: validate against ACPI motherboard resources
    
...

recently added to git-x86 causes one of my Intel test systems to not boot 
unless I specify pci=conf1.

...
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base 4026531840 segment 0 buses 0 - 127
PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG at f0000000 - f7ffffff
ACPI: PCI Root Bridge [PCI0] (0000:00)
<hang> 

The system is a SDV, but I believe production level.
DSDT is available at http://firstfloor.org/~andi/dsdt.dsl

On previous kernels the MCFG was rejected because it wasn't e820 reserved:

ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1

Also I'm a little surprised to find my Signed-off-by on that patch.

-Andi


