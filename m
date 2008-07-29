Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbYG2GA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbYG2GA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 02:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYG2GAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 02:00:15 -0400
Received: from mail.renesas.com ([202.234.163.13]:63460 "EHLO
	mail03.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753902AbYG2GAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 02:00:14 -0400
X-AuditID: ac140386-0000000b00001aa8-46-488eac9625ce
Date: Tue, 29 Jul 2008 14:37:25 +0900
From: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Subject: [PATCH] sh: Fix compile error of Solution Engine
To: linux-sh@vger.kernel.org
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>
Message-id: <488EAC95.4060507@renesas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-2022-JP
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I compiled Solution Engine, this become compile error
because plaform device of sh_eth device becomes enable.
When sh7710/sh7712 which could use sh_eth was chosen,
revised it so that platform device of sh_eth device became enable.

Signed-off-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
---
 arch/sh/boards/se/770x/setup.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/sh/boards/se/770x/setup.c b/arch/sh/boards/se/770x/setup.c
index cf4a5ba..6c64d77 100644
--- a/arch/sh/boards/se/770x/setup.c
+++ b/arch/sh/boards/se/770x/setup.c
@@ -113,6 +113,8 @@ static struct platform_device heartbeat_device = {
 	.resource	= heartbeat_resources,
 };

+#if defined(CONFIG_CPU_SUBTYPE_SH7710) ||\
+	defined(CONFIG_CPU_SUBTYPE_SH7712)
 /* SH771X Ethernet driver */
 static struct resource sh_eth0_resources[] = {
 	[0] = {
@@ -159,12 +161,16 @@ static struct platform_device sh_eth1_device = {
 	.num_resources = ARRAY_SIZE(sh_eth1_resources),
 	.resource = sh_eth1_resources,
 };
+#endif

 static struct platform_device *se_devices[] __initdata = {
 	&heartbeat_device,
 	&cf_ide_device,
+#if defined(CONFIG_CPU_SUBTYPE_SH7710) ||\
+	defined(CONFIG_CPU_SUBTYPE_SH7712)
 	&sh_eth0_device,
 	&sh_eth1_device,
+#endif
 };

 static int __init se_devices_setup(void)
-- 1.5.6.2
