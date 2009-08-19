Return-Path: <linux-kernel-owner+w=401wt.eu-S1751627AbZHSJjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbZHSJjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZHSJjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:39:08 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:37535 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbZHSJjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=h76Mdoxkfo1Izxr6UJ+RrE3RXF57NderE+M676mHPMomyrXB35Zq+Seak+L2UKV+hv
         lJBGTvw3HZRIF9om9g3x4a2xipNzA4utMWluWsNTdtnbdhj6/NSp9X30zhG2Y8jdrQKP
         m7ByZa8kqKQ0m6KtXzLFe7D/dBjfhA/H3x2NQ=
Message-ID: <4A8BC837.30206@tuffmail.co.uk>
Date: Wed, 19 Aug 2009 10:39:03 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Corentin Chary <corentin.chary@gmail.com>
CC: Trevor <trevor.chart@gmail.com>, linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] eeepc-laptop: allow rfkill hotplug to work on the 900A
 model
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 900A provides hotplug notifications on a different ACPI object to
other models.

Reported-by: Trevor <trevor.chart@gmail.com>
Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 drivers/platform/x86/eeepc-laptop.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 36d613b..7528b4f 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -977,6 +977,7 @@ static void eeepc_backlight_exit(void)
 
 static void eeepc_rfkill_exit(void)
 {
+	eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P5");
 	eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P6");
 	eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P7");
 	if (ehotk->wlan_rfkill) {
@@ -1083,6 +1084,7 @@ static int eeepc_rfkill_init(struct device *dev)
 	if (result == -EBUSY)
 		result = 0;
 
+	eeepc_register_rfkill_notifier("\\_SB.PCI0.P0P5");
 	eeepc_register_rfkill_notifier("\\_SB.PCI0.P0P6");
 	eeepc_register_rfkill_notifier("\\_SB.PCI0.P0P7");
 	/*
-- 
1.6.3.2



