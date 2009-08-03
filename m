Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZHCJLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZHCJLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 05:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbZHCJLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 05:11:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:7412 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492AbZHCJLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 05:11:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,313,1246863600"; 
   d="scan'208";a="538103721"
Subject: [PATCH 0/3] Generic sysfs support for ACPI ALS and other ALS
	devices
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>,
       "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 03 Aug 2009 17:10:57 +0800
Message-Id: <1249290657.2670.250.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all,

This is the patch set I made to introduce ACPI ALS device driver
and a generic sysfs I/F for all the ALS devices, like ACPI ALS,
platform ALS, etc.

Patch 01 introduces the ACPI ALS device driver.

Patch 02 introduces ALS sysfs class.
	Two sysfs I/F are created for each ALS device.
  /sys/class/als/alsX/illuminance:
	the amount of light incident upon a specified surface area.
  /sys/class/als/alsX/mappings:
	ambient light illuminance to display luminance mappings
	that can be used by an OS to calibrate its ambient light policy
	this is what I got on a test box:
	cat /sys/class/als/als0/mappings
	﻿Illuminance	Adjustment
	          0	       70
	         10	       73
	         80	       85
	        300	      100
	       1000	      150
﻿	 - noting that ﻿display luminance adjustment values are specified
	using relative percentages in order simplify the means by which
	these adjustments are applied in lieu of changes to the user’s
	display brightness preference.

Patch 03 introduces the generic sysfs I/F for ACPI ALS devices.

Patch 02/03 are RFC patches because I'm not sure if these sysfs I/F are
generic enough for other ALS devices, and if there is any attribute that
I missed.
For example, ACPI ALS has some optional properties like ambient light
temperature and ambient light color chromaticity, but I'm not sure if
they should be exported to user spaces via ALS sysfs class.

Any comments are welcome.

thanks,
rui

