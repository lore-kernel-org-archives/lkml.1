Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbZGPKyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbZGPKyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754939AbZGPKya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:54:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:44301 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719AbZGPKy3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:54:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,410,1243839600"; 
   d="scan'208";a="165663658"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Date: Thu, 16 Jul 2009 03:54:26 -0700
Subject: [PATCH v2 0/10] Moorestown enabling x86 patches
Thread-Topic: [PATCH v2 0/10] Moorestown enabling x86 patches
Thread-Index: AcoGA8lg9ZmxiVdbSue/pkSK8a00mA==
Message-ID: <43F901BD926A4E43B106BF17856F0755643EBDF2@orsmsx508.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset enables Moorestown platform in booting, system timers, and
interrupt controller support.

Moorestown is Intel's Mobile Internet Device (MID) platform for 2009. It
features Lincroft (north complex with CPU, memory controller, graphics unit) and Langwell (IO hub, system controller unit, etc.). While maintaining compatibility in the x86 core, it does not have many standard x86 PC features. Features related to this patchset are:
Features			x86pc			moorestown
---------------------------------------------------------------------------
Interrupt controller	i8259/PIC		IOAPIC only w/o legacy route
System timers		i8254 HPET		APB timers, up to 8
FW				BIOS			simple boot FW, no runtime
I/O ports			yes			Lincroft only
---------------------------------------------------------------------------

Highlights of what I have changed since the previous submission:

[PATCH 1/9] x86/boot: add setup_secondary_clock to x86 quirk
	none

[PATCH 2/9] x86: introduce a set of platform feature flags
	Use __set_bit, 
	Use void for platform_feature_init_default(void)
	Assign default platform flags and x86 quirk based on sub arch ids

[PATCH 3/9] x86/moorestown: add moorestown platform flags
	Combined in previous patch

[PATCH 4/9] x86/boot: adding hw subarch ID for Moorestown
	Use enum

[PATCH 5/9] x86: make use of platform flags in setup code
	Added quirk for reserve_ebda_region()
	Moved down platform feature check to probe_rom
	Added x86 PCI irq change, was in Jesse's MRST PCI patch

[PATCH 6/9] x86: add moorestown specific setup code
	Removed mrst_early_detect()
	Add PCI SHIM feature to default MRST flags

[PATCH 7/9] x86/apbt: Moorestown APB system timer driver
	Split into three patches, timer driver, tsc, choose timer
	Misc clean up

[PATCH 8/9] x86/apic: match destination id with destination mode
	Dropped

[PATCH 9/9] x86/apic: support moorestown interrupt subsystem
	Split into two patches, decouple i8259 and ioapic, 


Jacob Pan
Linux Software Engineer
Intel Open Source Technology Center

