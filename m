Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbZJNImy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbZJNImy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 04:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbZJNImy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 04:42:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbZJNImw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 04:42:52 -0400
Message-ID: <4AD58EEE.4070405@redhat.com>
Date: Wed, 14 Oct 2009 10:42:22 +0200
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, kaneshige.kenji@jp.fujitsu.com,
       matthew@wil.cx, ddutile@redhat.com
Subject: GT/s vs Gbps for PCIe bus speed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm really confused about GT/s¹ vs Gbps². The PCIe 2.0 Base Spec (rev 0.9)
on page 34, section 1.2 speaks of "Signaling rate - [...] For the first
generation of PCI Express technology, there is only one signaling rate
defined, which provides an effective 2.5 Gigabits/second/Lane/direction
of raw bandwidth." but later in the document it purely speaks of 2.5
GT/s.

If I understand this correctly it means the following:
PCIe has a raw bandwidth of 2.5 Gbps (or 5.0 Gbps, whatever) but because
of the "8b/10b" encoding the effective bit rate is only
2.5 Gbps * (8/10). So it's called 2.5 GT/s to explicitly say this is raw
bandwidth.

IMHO this is rather confusing, as most people don't know what GT/s means.

So I'd suggest the following change:

diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 0325d98..75ef3d7 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -86,8 +86,8 @@ static char *pci_bus_speed_strings[] = {
 	"66 MHz PCIX 533",	/* 0x11 */
 	"100 MHz PCIX 533",	/* 0x12 */
 	"133 MHz PCIX 533",	/* 0x13 */
-	"2.5 GT/s PCI-E",	/* 0x14 */
-	"5.0 GT/s PCI-E",	/* 0x15 */
+	"2.5 Gbps PCI-E",	/* 0x14 */
+	"5.0 Gbps PCI-E",	/* 0x15 */
 };

 #ifdef CONFIG_HOTPLUG_PCI_CPCI


¹ Gigatransfers/second
² Gigabits/second

  Stefan
--
Stefan Assmann         | Red Hat GmbH
Software Engineer      | Otto-Hahn-Strasse 20, 85609 Dornach
                       | HR: Amtsgericht Muenchen HRB 153243
                       | GF: Brendan Lane, Charlie Peters,
sassmann at redhat.com |     Michael Cunningham, Charles Cachera
