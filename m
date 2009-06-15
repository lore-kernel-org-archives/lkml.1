Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbZFOMFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbZFOMFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756070AbZFOMFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:05:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:16695 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbZFOMFQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:05:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,222,1243839600"; 
   d="scan'208";a="524651899"
From: "Li, Jiebing" <jiebing.li@intel.com>
To: Pierre Ossman <pierre@ossman.eu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Johnson, Charles F" <charles.f.johnson@intel.com>,
       "Zhu, Daniel" <daniel.zhu@intel.com>,
       "Yuan, Hang" <hang.yuan@intel.com>,
       "Li, Jiebing" <jiebing.li@intel.com>
Date: Mon, 15 Jun 2009 20:05:14 +0800
Subject: [PATCH 0/1] MMC: SDIO driver for Intel Moorestown  platform
Thread-Topic: [PATCH 0/1] MMC: SDIO driver for Intel Moorestown  platform
Thread-Index: AcntsYpO0C8+GYHnQla9qsmgB1rRNA==
Message-ID: <95608CFE3D0C064B8468DB61F8403BE036C19F9C0D@PDSMSX501.ccr.corp.intel.com>
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


Hi Pierre and all,

Here's a SDIO driver code patch for Intel Moorestown platform. Per your response of my code submission last month, I modified the code and hope that you could spare time to review this patch, which is used for SDIO card power management. It's very important for MID products like Moorestown, as power saving is the key point for such embedded products.

Last time you asked me the use cases for the code. The following is my statement:

1. sdio_bus_suspend()/sdui_bus_resume() and mmc_sdio_suspend()/mmc_sdio_resume():
Currently SDIO bus driver doesn't have suspend/resume interface, We need this to suspend the functions one by one and then the whole card when the platform is put in S3/S4/S5 states.

2. sdio_external_suspend_device()/sdio_external_resume_device():
Also, similar to USB, we would like to be able to selectively suspend a particular function using sysfs interface for power management scheme (non-ACPI) if the function is not in use. 

3. sdio_reset_device():
It comes to solve a scenario where there is a hang in the Host Interface HW, (i.e. the driver cannot access the device).  In this case the function driver can detect that something is broken (using some sw watchdog for example), but it cannot reset its function (host interface is broken). 



Thanks and regards,
Jiebing Li