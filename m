Return-Path: <linux-kernel-owner+w=401wt.eu-S2992571AbXCBQU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992571AbXCBQU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992578AbXCBQU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:20:57 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:1916 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992571AbXCBQU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:20:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=Wj04PRTZVBlzz4pD7Bww/WbjZ5/l6ovteV7jjqDBav3lVsDn8iF1q8LgR/rdmkeTRlZ8zo4ml1fzTx07pbKu7t1SFh2dFPAiMK3/fu4ZS8dlu/11edTxBjEeJh3NfOU7RnunUR/EAui1M8dyHTtd/rA36FNeEgRY9TydpCXI30s=
Message-ID: <45E84E81.5080002@googlemail.com>
Date: Fri, 02 Mar 2007 17:19:13 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Dave Jones <davej@codemonkey.org.uk>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] longhaul pci_find_device -> pci_get_device conversion (was:
 Re: 2.6.21-rc2-mm1)
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Andrew Morton napisał(a):
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> 

  CC [M]  arch/i386/kernel/cpu/cpufreq/longhaul.o
arch/i386/kernel/cpu/cpufreq/longhaul.c: In function 'enable_arbiter_disable':
arch/i386/kernel/cpu/cpufreq/longhaul.c:598: warning: 'pci_find_device' is deprecated (declared at include/linux/pci.h:485)
arch/i386/kernel/cpu/cpufreq/longhaul.c:602: warning: 'pci_find_device' is deprecated (declared at include/linux/pci.h:485)
arch/i386/kernel/cpu/cpufreq/longhaul.c:605: warning: 'pci_find_device' is deprecated (declared at include/linux/pci.h:485)
arch/i386/kernel/cpu/cpufreq/longhaul.c: In function 'longhaul_setup_vt8235':
arch/i386/kernel/cpu/cpufreq/longhaul.c:632: warning: 'pci_find_device' is deprecated (declared at include/linux/pci.h:485)

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-mm/arch/i386/kernel/cpu/cpufreq/longhaul.c	2007-03-02 15:15:51.000000000 +0100
+++ linux-work/arch/i386/kernel/cpu/cpufreq/longhaul.c	2007-03-02 17:12:46.000000000 +0100
@@ -595,14 +595,14 @@ static int enable_arbiter_disable(void)

 	/* Find PLE133 host bridge */
 	reg = 0x78;
-	dev = pci_find_device(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8601_0, NULL);
+	dev = pci_get_device(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8601_0, NULL);
 	/* Find CLE266 host bridge */
 	if (dev == NULL) {
 		reg = 0x76;
-		dev = pci_find_device(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_862X_0, NULL);
+		dev = pci_get_device(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_862X_0, NULL);
 		/* Find CN400 V-Link host bridge */
 		if (dev == NULL)
-			dev = pci_find_device(PCI_VENDOR_ID_VIA, 0x7259, NULL);
+			dev = pci_get_device(PCI_VENDOR_ID_VIA, 0x7259, NULL);

 	}
 	if (dev != NULL) {
@@ -629,7 +629,7 @@ static int longhaul_setup_vt8235(void)
 	u8 pci_cmd;

 	/* Find VT8235 southbridge */
-	dev = pci_find_device(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8235, NULL);
+	dev = pci_get_device(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8235, NULL);
 	if (dev != NULL) {
 		/* Set transition time to max */
 		pci_read_config_byte(dev, 0xec, &pci_cmd);

