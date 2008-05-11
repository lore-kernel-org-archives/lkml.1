Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbYEKWYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbYEKWYk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 18:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756969AbYEKWYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 18:24:30 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:63908 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYEKWYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 18:24:30 -0400
From: =?utf-8?q?Bj=C3=B6rn_Krombholz?= <fox.box@gmail.com>
To: linux-pci@vger.kernel.org
Subject: [PATCH] PCI: enable nv_msi_ht_cap_quirk for ALi bridges (2.6.24 regression)
Date: Mon, 12 May 2008 00:24:27 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805120024.27230.fox.box@gmail.com>
X-OriginalArrivalTime: 11 May 2008 22:17:28.0743 (UTC) FILETIME=[CC8E6B70:01C8B3B4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This applies the NVidia MSI enabled flag for HT capable devices quirk
to ALi bridges as well.

As described in more detail in
http://bugzilla.kernel.org/show_bug.cgi?id=10667 this is required for
my board which is using an nForce 3 250Gb chipset with an ALi M1695
northbridge.

It fixes a regression introduced in 2.6.24 that made the internal NIC
of the board unusable (MSI initialisation of the NIC but disabled MSI
on the northbridge devices.

Signed-off-by: Björn Krombholz <fox.box@gmail.com>
---

The patch is trivial but Andrew asked me to send it to the list(s). As
this is my first report of this kind, please give me a hint on any
formal mistakes.

--- drivers/pci/quirks.c.orig   2008-05-11 17:16:31.000000000 +0200
+++ drivers/pci/quirks.c        2008-05-11 04:17:38.371510170 +0200
@@ -1815,6 +1815,7 @@ static void __devinit nv_msi_ht_cap_quir
        }
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, nv_msi_ht_cap_quirk);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, PCI_ANY_ID, nv_msi_ht_cap_quirk);

 static void __devinit quirk_msi_intx_disable_bug(struct pci_dev *dev)
 {
