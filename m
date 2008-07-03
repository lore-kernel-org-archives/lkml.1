Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbYGCHF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbYGCHF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbYGCG52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:19146 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbYGCCZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 22:25:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,741,1204531200"; 
   d="scan'208";a="584545858"
Subject: [RFC PATCH 0/4] save and restore ACPI NVS memory during hibernation
From: Zhang Rui <rui.zhang@intel.com>
To: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 03 Jul 2008 10:24:28 +0800
Message-Id: <1215051868.5628.32.camel@rzhang-dt.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

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
	
Patch 03/04: mark the ACPI NVS memory region on both
	x86_64 and x86_32 platform.

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

