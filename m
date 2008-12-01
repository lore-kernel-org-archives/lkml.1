Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbYLAWOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbYLAWOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 17:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYLAWOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 17:14:40 -0500
Received: from rtr.ca ([76.10.145.34]:54325 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbYLAWOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 17:14:39 -0500
Message-ID: <49346212.3050102@rtr.ca>
Date: Mon, 01 Dec 2008 17:15:46 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <david-b@pacbell.net>,
       lkml <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
       linux-acpi@vger.kernel.org
Subject: Re: PATCH: /proc/acpi/alarm: handle day-of-month wraparound on readback
References: <200806222042.13929.david-b@pacbell.net> <4934176F.6080900@rtr.ca> <alpine.LFD.2.00.0812011311490.3197@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812011311490.3197@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> I don't have a /proc/acpi/alarm due to this:
> 
> #if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE) || 
> !defined(CONFIG_X86)
> /* use /sys/class/rtc/rtcX/wakealarm instead; it's not ACPI-specific */
> #else
> #define HAVE_ACPI_LEGACY_ALARM
> #endif
..

Yeah.. bit of a nuisance that.
I regularly apply this patch to my own kernels:

--- old/drivers/acpi/sleep/proc.c	2008-01-06 16:39:45.000000000 -0500
+++ linux/drivers/acpi/sleep/proc.c	2008-01-06 17:35:35.000000000 -0500
@@ -78,11 +78,11 @@
 }
 #endif				/* CONFIG_ACPI_PROCFS */
 
-#if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE) || !defined(CONFIG_X86)
+//#if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE) || !defined(CONFIG_X86)
 /* use /sys/class/rtc/rtcX/wakealarm instead; it's not ACPI-specific */
-#else
+//#else
 #define	HAVE_ACPI_LEGACY_ALARM
-#endif
+//#endif
 
 #ifdef	HAVE_ACPI_LEGACY_ALARM
 
