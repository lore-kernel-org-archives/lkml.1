Return-Path: <linux-kernel-owner+w=401wt.eu-S1763550AbYBSXAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763550AbYBSXAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760488AbYBSW7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:59:41 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38533 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759821AbYBSW7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:59:40 -0500
Date: Wed, 20 Feb 2008 00:59:03 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mattia Dongili <malattia@linux.it>, Len Brown <len.brown@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sony-laptop.c: fix off-by-one
Message-ID: <20080219225903.GS31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an off-by-one spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- linux-2.6/drivers/misc/sony-laptop.c.old	2008-02-20 00:26:21.000000000 +0200
+++ linux-2.6/drivers/misc/sony-laptop.c	2008-02-20 00:26:38.000000000 +0200
@@ -314,9 +314,9 @@ static void sony_laptop_report_input_eve
 		kp.dev = jog_dev;
 		break;
 
 	default:
-		if (event > ARRAY_SIZE(sony_laptop_input_index)) {
+		if (event >= ARRAY_SIZE(sony_laptop_input_index)) {
 			dprintk("sony_laptop_report_input_event, event not known: %d\n", event);
 			break;
 		}
 		if (sony_laptop_input_index[event] != -1) {

