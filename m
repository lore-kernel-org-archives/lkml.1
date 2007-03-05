Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbXCESpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbXCESpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 13:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbXCESpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 13:45:50 -0500
Received: from pat.uio.no ([129.240.10.15]:38895 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbXCESpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 13:45:49 -0500
Message-ID: <45EC654F.7030209@cheetah.uio.no>
Date: Mon, 05 Mar 2007 19:45:35 +0100
From: Jon Wikne <wikne@cheetah.uio.no>
Organization: Department of Physics, University of Oslo
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8b) Gecko/20050824
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: wikne@cheetah.uio.no
Subject: piix.c - previously available patch not implemented
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=12.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5,UPPERCASE_25_50=0)
X-UiO-Scanned: D19D62679F63AF3D4C7CD739C46E509BFDA272FA
X-UiO-SPAM-Test: remote_host: 129.240.10.15 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 124 total 30671 max/h 435 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

Last year, around 2.6.16.*, there was a patch around that helped
me get the PIIX driver to run with the Intel 82801FBM (ICH6M) chip
on my Toshiba Tecra A3 laptop.

Now, compiling the 2.6.21_rc2 kernel on this machine, to my
astonishment I find that this patch has still not reached the
mainstream kernel.

I do not know whether there might be a good reason for this,
but this patch is essential for me, and most likely others as
well. I include the patch that works for me below, ported and
relative to piix.c version 0.46 taken from the 2.6.21_rc2.


Cheers,
-- Jon Wikne
University of Oslo


diff -u ./linux-2.6.21-rc2/drivers/ide/pci/piix.c% ./linux-2.6.21-rc2/drivers/ide/pci/piix.c
--- ./linux-2.6.21-rc2/drivers/ide/pci/piix.c%  2007-02-28 05:59:12.000000000 +0100
+++ ./linux-2.6.21-rc2/drivers/ide/pci/piix.c   2007-03-05 17:38:13.000000000 +0100
@@ -132,6 +132,7 @@
                 case PCI_DEVICE_ID_INTEL_82801DB_11:
                 case PCI_DEVICE_ID_INTEL_82801EB_11:
                 case PCI_DEVICE_ID_INTEL_ESB_2:
+               case PCI_DEVICE_ID_INTEL_ICH6_5:
                 case PCI_DEVICE_ID_INTEL_ICH6_19:
                 case PCI_DEVICE_ID_INTEL_ICH7_21:
                 case PCI_DEVICE_ID_INTEL_ESB2_18:
@@ -421,6 +422,7 @@
                 case PCI_DEVICE_ID_INTEL_82801EB_11:
                 case PCI_DEVICE_ID_INTEL_82801E_11:
                 case PCI_DEVICE_ID_INTEL_ESB_2:
+               case PCI_DEVICE_ID_INTEL_ICH6_5:
                 case PCI_DEVICE_ID_INTEL_ICH6_19:
                 case PCI_DEVICE_ID_INTEL_ICH7_21:
                 case PCI_DEVICE_ID_INTEL_ESB2_18:
@@ -598,6 +600,7 @@
         /* 22 */ DECLARE_PIIX_DEV("ICH4"),
         /* 23 */ DECLARE_PIIX_DEV("ESB2"),
         /* 24 */ DECLARE_PIIX_DEV("ICH8M"),
+       /* 25 */ DECLARE_PIIX_DEV("ICH6M"),
  };

  /**
@@ -675,6 +678,7 @@
         { PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801DB_1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 22},
         { PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB2_18, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 23},
         { PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_6, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 24},
+       { PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_5, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 25},
         { 0, },
  };
  MODULE_DEVICE_TABLE(pci, piix_pci_tbl);
diff -u ./linux-2.6.21-rc2/include/linux/pci_ids.h% ./linux-2.6.21-rc2/include/linux/pci_ids.h
--- ./linux-2.6.21-rc2/include/linux/pci_ids.h% 2007-02-28 05:59:12.000000000 +0100
+++ ./linux-2.6.21-rc2/include/linux/pci_ids.h  2007-03-05 17:41:54.000000000 +0100
@@ -2235,6 +2235,7 @@
  #define PCI_DEVICE_ID_INTEL_ICH6_0     0x2640
  #define PCI_DEVICE_ID_INTEL_ICH6_1     0x2641
  #define PCI_DEVICE_ID_INTEL_ICH6_2     0x2642
+#define PCI_DEVICE_ID_INTEL_ICH6_5      0x2653
  #define PCI_DEVICE_ID_INTEL_ICH6_16    0x266a
  #define PCI_DEVICE_ID_INTEL_ICH6_17    0x266d
  #define PCI_DEVICE_ID_INTEL_ICH6_18    0x266e

