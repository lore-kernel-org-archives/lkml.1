Return-Path: <linux-kernel-owner+w=401wt.eu-S1765264AbZLQR73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765264AbZLQR73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765245AbZLQR71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:59:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:45359 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765227AbZLQR70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:59:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208,223";a="224096195"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Date: Thu, 17 Dec 2009 09:59:23 -0800
Subject: [PATCH 2/2] x86/apic: check global clockevent in lapic timer setup
Thread-Topic: [PATCH 2/2] x86/apic: check global clockevent in lapic timer
 setup
Thread-Index: Acp/QqpM24DLOvh/TPaBLRpxt1Pgog==
Message-ID: <43F901BD926A4E43B106BF17856F07559A257B5C@orsmsx508.amr.corp.intel.com>
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

>From 5b3b795b42796e326d34713d4785c161b52e04db Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Thu, 17 Dec 2009 08:07:57 -0800
Subject: [PATCH 2/2] x86/apic: check global clockevent in lapic timer setup

Global clockevent is needed to calibrate local apic timer.
This patch makes sure we have a valid global clockevent prior
to lapic timer setup.
Non-pc x86 mid platform with per cpu platform timer may not
have a global clockevent device.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/kernel/apic/apic.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index aa57c07..7e7aee1 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -724,6 +724,13 @@ static int __init calibrate_APIC_clock(void)
  */
 void __init setup_boot_APIC_clock(void)
 {
+	/* global clockevent is needed for calibration */
+	if (!global_clock_event) {
+		apic_printk(APIC_DEBUG,
+				"no global clockevent for calibration\n");
+		return;
+	}
+
 	/*
 	 * The local apic timer can be disabled via the kernel
 	 * commandline or from the CPU detection code. Register the lapic
-- 
1.6.5.3

