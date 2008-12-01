Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbYLASTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbYLASTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 13:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYLASSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 13:18:55 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:64740 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbYLASSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 13:18:54 -0500
Date: Mon, 01 Dec 2008 13:18:50 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: PATCH: /proc/acpi/alarm: handle day-of-month wraparound on readback
In-reply-to: <4934176F.6080900@rtr.ca>
X-X-Sender: lenb@localhost.localdomain
To: Mark Lord <lkml@rtr.ca>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <david-b@pacbell.net>,
       lkml <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
       linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.2.00.0812011311490.3197@localhost.localdomain>
Organization: Intel Open Source Technology Center
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200806222042.13929.david-b@pacbell.net> <4934176F.6080900@rtr.ca>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Dec 2008, Mark Lord wrote:

> Fix month wrap issue with readback from /proc/acpi/alarm
> This bug has been around *forever*.
> 
> $ echo '2008-12-01 10:36:20' > /proc/acpi/alarm
> $ cat /proc/acpi/alarm
> 2008-11-01 10:36:20
> 
> Note how the readback above shows the month incorrectly.
> But with this patch applied, it shows the correct month (12).
> 
> Patch applies/works on kernels 2.6.25.* through 2.6.27.*,
> and probably on earlier kernels as well.

We've had some BCD_TO_BIN() changes here in 2.6.28 already,
does 2.6.28-rc still have this bug?

I'd check myself, but I don't have a /proc/acpi/alarm due to this:

#if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE) || 
!defined(CONFIG_X86)
/* use /sys/class/rtc/rtcX/wakealarm instead; it's not ACPI-specific */
#else
#define HAVE_ACPI_LEGACY_ALARM
#endif


thanks,
-Len

