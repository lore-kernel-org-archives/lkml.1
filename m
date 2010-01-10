Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997Ab0AJOfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0AJOfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 09:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756Ab0AJOfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 09:35:17 -0500
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:49331 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab0AJOfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 09:35:11 -0500
X-Authuid: nmarci
Message-ID: <4B49E597.9070307@freemail.hu>
Date: Sun, 10 Jan 2010 15:35:03 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: [PATCH 7/9] USB host: make Open Firmware device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02a.mail.t-online.hu 32721; Body=5 Fuz1=5
	Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The match_table field of the struct of_device_id is constant in <linux/of_platform.h>
so it is worth to make the initialization data also constant.

The semantic match that finds this kind of pattern is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
disable decl_init,const_decl_init;
identifier I1, I2, x;
@@
	struct I1 {
	  ...
	  const struct I2 *x;
	  ...
	};
@s@
identifier r.I1, y;
identifier r.x, E;
@@
	struct I1 y = {
	  .x = E,
	};
@c@
identifier r.I2;
identifier s.E;
@@
	const struct I2 E[] = ... ;
@depends on !c@
identifier r.I2;
identifier s.E;
@@
+	const
	struct I2 E[] = ...;
// </smpl>

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Julia Lawall <julia@diku.dk>
Cc: cocci@diku.dk
---
diff -u -p a/drivers/usb/host/ehci-ppc-of.c b/drivers/usb/host/ehci-ppc-of.c
--- a/drivers/usb/host/ehci-ppc-of.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/usb/host/ehci-ppc-of.c 2010-01-08 17:24:21.000000000 +0100
@@ -264,7 +264,7 @@ static int ehci_hcd_ppc_of_shutdown(stru
 }


-static struct of_device_id ehci_hcd_ppc_of_match[] = {
+static const struct of_device_id ehci_hcd_ppc_of_match[] = {
 	{
 		.compatible = "usb-ehci",
 	},
diff -u -p a/drivers/usb/host/fhci-hcd.c b/drivers/usb/host/fhci-hcd.c
--- a/drivers/usb/host/fhci-hcd.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/usb/host/fhci-hcd.c 2010-01-08 17:25:53.000000000 +0100
@@ -804,7 +804,7 @@ static int __devexit of_fhci_remove(stru
 	return fhci_remove(&ofdev->dev);
 }

-static struct of_device_id of_fhci_match[] = {
+static const struct of_device_id of_fhci_match[] = {
 	{ .compatible = "fsl,mpc8323-qe-usb", },
 	{},
 };
diff -u -p a/drivers/usb/host/ohci-ppc-of.c b/drivers/usb/host/ohci-ppc-of.c
--- a/drivers/usb/host/ohci-ppc-of.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/usb/host/ohci-ppc-of.c 2010-01-08 17:28:21.000000000 +0100
@@ -212,7 +212,7 @@ static int ohci_hcd_ppc_of_shutdown(stru
 }


-static struct of_device_id ohci_hcd_ppc_of_match[] = {
+static const struct of_device_id ohci_hcd_ppc_of_match[] = {
 #ifdef CONFIG_USB_OHCI_HCD_PPC_OF_BE
 	{
 		.name = "usb",
diff -u -p a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
--- a/drivers/usb/host/ehci-xilinx-of.c 2010-01-07 19:08:47.000000000 +0100
+++ b/drivers/usb/host/ehci-xilinx-of.c 2010-01-08 17:28:35.000000000 +0100
@@ -281,7 +281,7 @@ static int ehci_hcd_xilinx_of_shutdown(s
 }


-static struct of_device_id ehci_hcd_xilinx_of_match[] = {
+static const struct of_device_id ehci_hcd_xilinx_of_match[] = {
 		{.compatible = "xlnx,xps-usb-host-1.00.a",},
 	{},
 };
diff -u -p a/drivers/usb/host/isp1760-if.c b/drivers/usb/host/isp1760-if.c
--- a/drivers/usb/host/isp1760-if.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/usb/host/isp1760-if.c 2010-01-08 17:29:21.000000000 +0100
@@ -109,7 +109,7 @@ static int of_isp1760_remove(struct of_d
 	return 0;
 }

-static struct of_device_id of_isp1760_match[] = {
+static const struct of_device_id of_isp1760_match[] = {
 	{
 		.compatible = "nxp,usb-isp1760",
 	},
