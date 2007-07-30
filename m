Return-Path: <linux-kernel-owner+w=401wt.eu-S935207AbXG3XCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935207AbXG3XCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 19:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757132AbXG3XCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 19:02:07 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:35413 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755960AbXG3XCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 19:02:04 -0400
Subject: regression on HP zx1 platform from ACPI autoload modules patches
From: Doug Chapman <doug.chapman@hp.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-ia64@vger.kernel.org, trenn@suse.de
Content-Type: text/plain
Date: Mon, 30 Jul 2007 18:57:18 -0400
Message-Id: <1185836238.31298.36.camel@deimos.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am seeing a regression on the HP ia64 zx1 platforms when using
a .config with CONFIG_IA64_HP_ZX1=y.  Oddly it works OK with
CONFIG_IA64_GENERIC=y.


During bootup it panics with:

Kernel panic - not syncing: Unable to find SBA IOMMU: Try a generic or DIG kernel

I can provide the full console output if that is helpful.  Also, please let
me know if there is any other data I can provide that would be helpful.

Using git bisect I have narrowed it down to these 2 commits.  These commits
cannot be built separately as they appear to have code that depends on each
other.


commit 29b71a1ca74491fab9fed09e9d835d840d042690
Author: Thomas Renninger <trenn@suse.de>
Date:   Mon Jul 23 14:43:51 2007 +0200

    ACPI: autoload modules - Create ACPI alias interface
    
    Modify modpost (file2alias.c) to add acpi*:XYZ0001: alias in modules.alias
    like:
    grep acpi /lib/modules/2.6.22-rc4-default/modules.alias
    alias acpi*:SNY5001:* sony_laptop
    alias acpi*:SNY6001:* sony_laptop
    for e.g. the sony_laptop module.
    This module matches against all ACPI devices with a HID or CID of SNY5001
    or SNY6001
    
    Export an uevent and modalias sysfs file containing the string:
    [MODALIAS=]acpi:PNP0C0C:
    additional CIDs are concatenated at the end.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: Len Brown <len.brown@intel.com>


Author: Thomas Renninger <trenn@suse.de>
Date:   Mon Jul 23 14:43:32 2007 +0200

    ACPI: autoload modules - ACPICA modifications
    
    Define standardized HIDs - Rename current acpi_device_id to acpica_device_id
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>



- Doug


