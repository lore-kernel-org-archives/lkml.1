Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbYCGHfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbYCGHfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 02:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbYCGHfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 02:35:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:12972 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621AbYCGHff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 02:35:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,460,1199692800"; 
   d="scan'208";a="530198912"
Subject: Re: AE_ERROR, ACPI thermal trip point state changed
From: "Zhang, Rui" <rui.zhang@intel.com>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47D0E694.5050102@freemail.hu>
References: <47B328AA.1000800@freemail.hu> <47B3F147.7000704@freemail.hu>
	 <47CF96E2.9020302@freemail.hu>
	 <1204757373.10256.179.camel@acpi-hp-zz.sh.intel.com>
	 <823A93EED437D048963A3697DB0E35DE0129BB78@pdsmsx414.ccr.corp.intel.com>
	 <47D0E694.5050102@freemail.hu>
Content-Type: multipart/mixed; boundary="=-d42G9MwupxV/g0yEUSdx"
Date: Fri, 07 Mar 2008 15:24:46 +0800
Message-Id: <1204874686.10256.185.camel@acpi-hp-zz.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-d42G9MwupxV/g0yEUSdx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On Fri, 2008-03-07 at 14:54 +0800, Németh Márton wrote:
> Hi,
> 
> I downloaded pmtools from
> http://www.kernel.org/pub/linux/kernel/people/lenb/acpi/utils/pmtools-20071116.tar.bz2 and
> compiled: it created exactly the same result what my currently
> installed acpidump Debian
> package version 20071116-1. I think it is useless to send the same log
> again.
> 
> After I boot the "Please send acpidump to linux-acpi@vger.kernel.org"
> message is already
> there. So when I first get the prompt I checked for this message in
> dmesg and executed
> the given command. Here is my result:
> 
> # cat /proc/acpi/thermal_zone/*/*
> 0 - Active; 1 - Passive
> <polling disabled>
> state:                   ok
> temperature:             42 C
> critical (S5):           155 C
> passive:                 84 C: tc1=2 tc2=5 tsp=0 devices=CPU0
> active[0]:               70 C: devices=
> # ls /proc/acpi/thermal_zone/*/*
> /proc/acpi/thermal_zone/THRM/cooling_mode
> /proc/acpi/thermal_zone/THRM/polling_frequency
> /proc/acpi/thermal_zone/THRM/state
> /proc/acpi/thermal_zone/THRM/temperature
> /proc/acpi/thermal_zone/THRM/trip_points
> 
> Maybe this is related to
> http://bugzilla.kernel.org/show_bug.cgi?id=8544 ?
> 
Hi, Németh,

Please ignore the debug patch I sent and try this one.

thanks,
rui

thermal fixup for broken BIOS

Signed-off-by: Zhang Rui<rui.zhang@intel.com>
---
 drivers/acpi/thermal.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/acpi/thermal.c
===================================================================
--- linux-2.6.orig/drivers/acpi/thermal.c
+++ linux-2.6/drivers/acpi/thermal.c
@@ -326,7 +326,9 @@ static int acpi_thermal_set_cooling_mode
 #define ACPI_TRIPS_ACTIVE	0x08
 #define ACPI_TRIPS_DEVICES	0x10
 
-#define ACPI_TRIPS_REFRESH_THRESHOLDS	(ACPI_TRIPS_PASSIVE | ACPI_TRIPS_ACTIVE)
+#define ACPI_TRIPS_REFRESH_THRESHOLDS	(ACPI_TRIPS_PASSIVE |	\
+					 ACPI_TRIPS_ACTIVE |	\
+					 ACPI_TRIPS_DEVICES)
 #define ACPI_TRIPS_REFRESH_DEVICES	ACPI_TRIPS_DEVICES
 
 #define ACPI_TRIPS_INIT      (ACPI_TRIPS_CRITICAL | ACPI_TRIPS_HOT |	\


--=-d42G9MwupxV/g0yEUSdx
Content-Disposition: attachment; filename=thermal-fix
Content-Type: text/plain; name=thermal-fix; charset=UTF-8
Content-Transfer-Encoding: 7bit

thermal fixup for broken BIOS

Signed-off-by: Zhang Rui<rui.zhang@intel.com>
---
 drivers/acpi/thermal.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/acpi/thermal.c
===================================================================
--- linux-2.6.orig/drivers/acpi/thermal.c
+++ linux-2.6/drivers/acpi/thermal.c
@@ -326,7 +326,9 @@ static int acpi_thermal_set_cooling_mode
 #define ACPI_TRIPS_ACTIVE	0x08
 #define ACPI_TRIPS_DEVICES	0x10
 
-#define ACPI_TRIPS_REFRESH_THRESHOLDS	(ACPI_TRIPS_PASSIVE | ACPI_TRIPS_ACTIVE)
+#define ACPI_TRIPS_REFRESH_THRESHOLDS	(ACPI_TRIPS_PASSIVE |	\
+					 ACPI_TRIPS_ACTIVE |	\
+					 ACPI_TRIPS_DEVICES)
 #define ACPI_TRIPS_REFRESH_DEVICES	ACPI_TRIPS_DEVICES
 
 #define ACPI_TRIPS_INIT      (ACPI_TRIPS_CRITICAL | ACPI_TRIPS_HOT |	\

--=-d42G9MwupxV/g0yEUSdx--

