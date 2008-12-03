Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbYLCSQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbYLCSQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYLCSQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:16:22 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:62788 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227AbYLCSQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:16:22 -0500
X-Greylist: delayed 1228 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Dec 2008 13:16:21 EST
Date: Wed, 03 Dec 2008 17:52:01 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Bernd.Spaeth@gmx.net
Message-ID: <500D6D79D4%linux@youmustbejoking.demon.co.uk>
Mail-Followup-To: linux-kernel@vger.kernel.org, Bernd.Spaeth@gmx.net, 
 linux@youmustbejoking.demon.co.uk
User-Agent: Gemini/2.29m (Qt/3.3.8b) (Linux-x86_64)
X-SDate: Wed, 5573 Sep 1993 17:52:01 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
Subject: [2.6.28-rc7 PATCH] Make Bluetooth rfkill work on EeePC
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on pentagram.youmustbejoking.demon.co.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"echo 1 >/sys/class/rfkill/rfkill1/state" was failing with "no such device"
on my 901. This fixes it.

Signed-Off-By: Darren Salt <linux@youmustbejoking.demon.co.uk>

This needs Bernd Spaeth's sign-off too (and promptly!) since I took this from
the patch which he posted to debian-eeepc-devel. URL:
http://lists.alioth.debian.org/pipermail/debian-eeepc-devel/2008-October/001299.html

--- ./drivers/misc/eeepc-laptop.c.orig	2008-12-03 17:17:01.000000000 +0000
+++ ./drivers/misc/eeepc-laptop.c	2008-12-03 17:28:36.000000000 +0000
@@ -90,7 +90,7 @@
 };
 
 static const char *cm_getv[] = {
-	"WLDG", NULL, NULL, NULL,
+	"WLDG", "BTHG", NULL, NULL,
 	"CAMG", NULL, NULL, NULL,
 	NULL, "PBLG", NULL, NULL,
 	"CFVG", NULL, NULL, NULL,
@@ -99,7 +99,7 @@
 };
 
 static const char *cm_setv[] = {
-	"WLDS", NULL, NULL, NULL,
+	"WLDS", "BTHS", NULL, NULL,
 	"CAMS", NULL, NULL, NULL,
 	"SDSP", "PBLS", "HDPS", NULL,
 	"CFVS", NULL, NULL, NULL,

-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Lobby friends, family, business, government.    WE'RE KILLING THE PLANET.

To have died once is enough.
