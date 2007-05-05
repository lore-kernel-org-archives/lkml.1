Return-Path: <linux-kernel-owner+w=401wt.eu-S933816AbXEEVcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816AbXEEVcw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 17:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933822AbXEEVcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 17:32:52 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:8678 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933816AbXEEVcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 17:32:51 -0400
Message-ID: <463CF7F8.7080007@interia.pl>
Date: Sat, 05 May 2007 23:32:40 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Wander Winkelhorst <w.winkelhorst@gmail.com>,
       David Johnson <dj@david-web.co.uk>, linux-kernel@vger.kernel.org,
       cpufreq@lists.linux.org.uk
Subject: Re: cpufreq longhaul locks up
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>  <200705042320.41278.dj@david-web.co.uk>  <Pine.LNX.4.61.0705050132410.18504@yvahk01.tjqt.qr>  <463C18C4.7030304@interia.pl> <5699f8f00705050144s5c00a455s8f7dba9258d83986@mail.gmail.com> <463CC380.3060603@interia.pl> <Pine.LNX.4.61.0705052028560.18504@yvahk01.tjqt.qr> <463CE1FB.4050305@interia.pl> <Pine.LNX.4.61.0705052237580.18504@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705052237580.18504@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-EMID: 92112acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is patch attached below making things better?
You should see in log that You are using VT8235 support now.

---
 arch/i386/kernel/cpu/cpufreq/longhaul.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/i386/kernel/cpu/cpufreq/longhaul.c b/arch/i386/kernel/cpu/cpufreq/longhaul.c
index 5548e5b..c3c9096 100644
--- a/arch/i386/kernel/cpu/cpufreq/longhaul.c
+++ b/arch/i386/kernel/cpu/cpufreq/longhaul.c
@@ -635,6 +635,8 @@ static int longhaul_setup_vt8235(void)
 
 	/* Find VT8235 southbridge */
 	dev = pci_find_device(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8235, NULL);
+	if (dev == NULL)
+		dev = pci_find_device(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8237, NULL);
 	if (dev != NULL) {
 		/* Set transition time to max */
 		pci_read_config_byte(dev, 0xec, &pci_cmd);
@@ -771,11 +773,11 @@ static int __init longhaul_cpu_init(struct cpufreq_policy *policy)
 		}
 	}
 	/* Check if northbridge is friendly */
-	if (enable_arbiter_disable()) {
+/*	if (enable_arbiter_disable()) {
 		longhaul_flags |= USE_NORTHBRIDGE;
 		goto print_support_type;
 	}
-	/* Use VT8235 southbridge if present */
+*/	/* Use VT8235 southbridge if present */
 	if (longhaul_version == TYPE_POWERSAVER && vt8235_present) {
 		longhaul_flags |= USE_VT8235;
 		goto print_support_type;
-- 



----------------------------------------------------------------------
Wicie, rozumicie....
Zobacz >>> http://link.interia.pl/f1a74

