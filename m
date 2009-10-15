Return-Path: <linux-kernel-owner+w=401wt.eu-S1762995AbZJOUCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762995AbZJOUCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 16:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760894AbZJOUCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 16:02:15 -0400
Received: from smtp103.biz.mail.mud.yahoo.com ([68.142.200.238]:24578 "HELO
	smtp103.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759355AbZJOUCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 16:02:14 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: Otym2SkVM1lF7Nawu1sgAvt1prNu3uEF1tEaLeHqZCv5dpKKloFGtSvCs3i.QFDVAAzzYcMXQG51G5YTYGXt5DNQ_59aDOuba6ps.nAiDQbWEgba4UYFSdkJo.VOi2OK9DrxkDwv1LPRlmV_WGENfLiV.kgSq.o6qpQOpnmh6fEEzoXzMmJC8MKaYFZUCU9mcPB_ZxdlO6YeRQHfmoykrE6pNdQHURC75siFwCq.VrLQYzjki9zLtTbbmYFg8sprliKdZI12Ns1BtGNFLmmldxjgWo614bU4E33XYA2DoMtfI_Njxa1avRQ13ka8wNZ.bP07g3W4pnB3iFKEeU.DRR2brTi1B9uj4Zan5EPqTugMVyGePBKiB0JeL_H7szLuh3hYbcSuKd0XBTaH1IEM
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: uclinux-dev@uclinux.org
Subject: [PATCH] Coldfire GPIO corrections
Date: Thu, 15 Oct 2009 12:54:41 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       Greg Ungerer <gerg@snapgear.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_B431KZsrqVNC2i7"
Message-Id: <200910151254.41599.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_B431KZsrqVNC2i7
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Pin 0 of the EPORT is not connected on the 523x, 5271, 5275 and 528x and the 
TIMER on the 523x has 8 pins, not 4.
-- 
Steven King -- sfking at fdwdc dot com

Signed-off-by: Steven King <sfking@fdwdc.com>

diff --git a/arch/m68knommu/platform/523x/gpio.c b/arch/m68knommu/platform/523x/gpio.c
index f02840d..a8842dc 100644
--- a/arch/m68knommu/platform/523x/gpio.c
+++ b/arch/m68knommu/platform/523x/gpio.c
@@ -30,7 +30,8 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
 			.direction_output	= mcf_gpio_direction_output,
 			.get			= mcf_gpio_get_value,
 			.set			= mcf_gpio_set_value,
-			.ngpio			= 8,
+			.base			= 1,
+			.ngpio			= 7,
 		},
 		.pddr				= MCFEPORT_EPDDR,
 		.podr				= MCFEPORT_EPDR,
@@ -244,7 +245,7 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
 			.get			= mcf_gpio_get_value,
 			.set			= mcf_gpio_set_value_fast,
 			.base			= 96,
-			.ngpio			= 4,
+			.ngpio			= 8,
 		},
 		.pddr				= MCFGPIO_PDDR_TIMER,
 		.podr				= MCFGPIO_PODR_TIMER,
diff --git a/arch/m68knommu/platform/527x/gpio.c b/arch/m68knommu/platform/527x/gpio.c
index 1028142..0b56e19 100644
--- a/arch/m68knommu/platform/527x/gpio.c
+++ b/arch/m68knommu/platform/527x/gpio.c
@@ -31,7 +31,8 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
 			.direction_output	= mcf_gpio_direction_output,
 			.get			= mcf_gpio_get_value,
 			.set			= mcf_gpio_set_value,
-			.ngpio			= 8,
+			.base			= 1,
+			.ngpio			= 7,
 		},
 		.pddr				= MCFEPORT_EPDDR,
 		.podr				= MCFEPORT_EPDR,
@@ -263,7 +264,8 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
 			.direction_output	= mcf_gpio_direction_output,
 			.get			= mcf_gpio_get_value,
 			.set			= mcf_gpio_set_value,
-			.ngpio			= 8,
+			.base			= 1,
+			.ngpio			= 7,
 		},
 		.pddr				= MCFEPORT_EPDDR,
 		.podr				= MCFEPORT_EPDR,
diff --git a/arch/m68knommu/platform/528x/gpio.c b/arch/m68knommu/platform/528x/gpio.c
index ec59395..eedaf0a 100644
--- a/arch/m68knommu/platform/528x/gpio.c
+++ b/arch/m68knommu/platform/528x/gpio.c
@@ -31,7 +31,7 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
 			.get			= mcf_gpio_get_value,
 			.set			= mcf_gpio_set_value,
 			.base			= 1,
-			.ngpio			= 8,
+			.ngpio			= 7,
 		},
 		.pddr				= MCFEPORT_EPDDR,
 		.podr				= MCFEPORT_EPDR,

--Boundary-00=_B431KZsrqVNC2i7
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="foo"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="foo"

Signed-off-by: Steven King <sfking@fdwdc.com>

diff --git a/arch/m68knommu/platform/523x/gpio.c b/arch/m68knommu/platform/523x/gpio.c
index f02840d..a8842dc 100644
--- a/arch/m68knommu/platform/523x/gpio.c
+++ b/arch/m68knommu/platform/523x/gpio.c
@@ -30,7 +30,8 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
 			.direction_output	= mcf_gpio_direction_output,
 			.get			= mcf_gpio_get_value,
 			.set			= mcf_gpio_set_value,
-			.ngpio			= 8,
+			.base			= 1,
+			.ngpio			= 7,
 		},
 		.pddr				= MCFEPORT_EPDDR,
 		.podr				= MCFEPORT_EPDR,
@@ -244,7 +245,7 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
 			.get			= mcf_gpio_get_value,
 			.set			= mcf_gpio_set_value_fast,
 			.base			= 96,
-			.ngpio			= 4,
+			.ngpio			= 8,
 		},
 		.pddr				= MCFGPIO_PDDR_TIMER,
 		.podr				= MCFGPIO_PODR_TIMER,
diff --git a/arch/m68knommu/platform/527x/gpio.c b/arch/m68knommu/platform/527x/gpio.c
index 1028142..0b56e19 100644
--- a/arch/m68knommu/platform/527x/gpio.c
+++ b/arch/m68knommu/platform/527x/gpio.c
@@ -31,7 +31,8 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
 			.direction_output	= mcf_gpio_direction_output,
 			.get			= mcf_gpio_get_value,
 			.set			= mcf_gpio_set_value,
-			.ngpio			= 8,
+			.base			= 1,
+			.ngpio			= 7,
 		},
 		.pddr				= MCFEPORT_EPDDR,
 		.podr				= MCFEPORT_EPDR,
@@ -263,7 +264,8 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
 			.direction_output	= mcf_gpio_direction_output,
 			.get			= mcf_gpio_get_value,
 			.set			= mcf_gpio_set_value,
-			.ngpio			= 8,
+			.base			= 1,
+			.ngpio			= 7,
 		},
 		.pddr				= MCFEPORT_EPDDR,
 		.podr				= MCFEPORT_EPDR,
diff --git a/arch/m68knommu/platform/528x/gpio.c b/arch/m68knommu/platform/528x/gpio.c
index ec59395..eedaf0a 100644
--- a/arch/m68knommu/platform/528x/gpio.c
+++ b/arch/m68knommu/platform/528x/gpio.c
@@ -31,7 +31,7 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
 			.get			= mcf_gpio_get_value,
 			.set			= mcf_gpio_set_value,
 			.base			= 1,
-			.ngpio			= 8,
+			.ngpio			= 7,
 		},
 		.pddr				= MCFEPORT_EPDDR,
 		.podr				= MCFEPORT_EPDR,

--Boundary-00=_B431KZsrqVNC2i7--
