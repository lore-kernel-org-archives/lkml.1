Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbYAWBnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbYAWBnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 20:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYAWBm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 20:42:57 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44755 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbYAWBm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 20:42:56 -0500
Date: Tue, 22 Jan 2008 17:49:21 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86: left over fix for leak of early_ioremp in dmi_scan
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <200801221749.22153.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: left over fix for leak of early_ioremp in dmi_scan

Signed-off-by: Yinghai Lu <yinghai@sun.com>

Index: linux-2.6/drivers/firmware/dmi_scan.c
===================================================================
--- linux-2.6.orig/drivers/firmware/dmi_scan.c
+++ linux-2.6/drivers/firmware/dmi_scan.c
@@ -353,6 +353,7 @@ void __init dmi_scan_machine(void)
 				return;
 			}
 		}
+		dmi_iounmap(p, 0x10000);
 	}
  out:	printk(KERN_INFO "DMI not present or invalid.\n");
 }
