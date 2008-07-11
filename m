Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYGKFaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYGKFaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 01:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbYGKF34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 01:29:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:31383 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbYGKF3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 01:29:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,342,1212390000"; 
   d="scan'208";a="307774580"
Subject: [linux-next] [PATCH V2 0/4] ACPI: save/restore ACPI NVS memory
	during hiberntion
From: Zhang Rui <rui.zhang@intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 11 Jul 2008 13:29:05 +0800
Message-Id: <1215754145.1617.57.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿Hi,

This is the second version of patches which save/restore ACPI NVS memory
during hibernation.

According to the ACPI spec, ACPI NVS memory region is required to
be saved/restored by OS during hibernation.

Section 15.3.2 ACPI Spec 3.0b,
"OSPM will call the _PTS control method some time before entering
a sleeping state, to allow the platform’s AML code to update
this memory image before entering the sleeping state.
After the system awakes from an S4 state, OSPM will restore this
memory area and call the _WAK control method to enable the BIOS
to reclaim its memory image."

This patch set add the mechanism to save/restore ACPI NVS memory
during hibernation.

Patch 01: call platform_begin before swsusp_shrink_memory.
        So that we can allocate enough pages for ACPI NVS memory
        before shrink the memory.

Patch 02: introduce the mechanism to save/restore ACPI NVS memory.
        
Patch 03: mark the ACPI NVS memory region during startup.

Patch 04: introduce kernel parameter acpi_sleep=s4_nvs_nosave
	  which prevents OS from saving/restoring ACPI NVS memory.

As patch 01 changes the generic code, I don't know if there are
any side effects introduced by this patch, and I'm not able to
test on other platforms.
But with Rafael's suggestion, patch 01 can be optionally dropped
because we can use the the I/O and spare pages reserved, which is
5MB at present and the NVS memory is usually tens of pages during
my test.

Any comments are welcome. :)

thanks,
rui

