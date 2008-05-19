Return-Path: <linux-kernel-owner+w=401wt.eu-S1765349AbYESWkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765349AbYESWkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764957AbYESWkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:40:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757646AbYESWkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:40:03 -0400
Date: Mon, 19 May 2008 18:39:32 -0400
From: Dave Jones <davej@redhat.com>
To: airlied@redhat.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [AGP] Add a missing via-agp module alias.
Message-ID: <20080519223932.GA3225@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, airlied@redhat.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whilst trying to discern what could possibly be in the no-source-provided
version of via-agp that VIA are distributing on linux.via.com.tw, I noticed
in the modinfo output that they supported an extra alias.

Further digging revealed it was for PCI ID 0x0364, which we added in
commit 32ddef98f232585f20bc8bdb891029a6a5f633d0 last year, but we didn't
add the corresponding entry in the pci_device_id table, so it doesn't
get auto-loaded on that hardware.

[hopefully this is the only difference between kernel.org, and their
 binary-only variant. Without the source, it's hard to tell. Sigh. ]

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/char/agp/via-agp.c b/drivers/char/agp/via-agp.c
index 0ecc54d..f0d4c0a 100644
--- a/drivers/char/agp/via-agp.c
+++ b/drivers/char/agp/via-agp.c
@@ -548,6 +548,7 @@ static const struct pci_device_id agp_via_pci_table[] = {
 	ID(PCI_DEVICE_ID_VIA_VT3324),
 	ID(PCI_DEVICE_ID_VIA_VT3336),
 	ID(PCI_DEVICE_ID_VIA_P4M890),
+	ID(PCI_DEVICE_ID_VIA_VT3364),
 	{ }
 };
 
-- 
http://www.codemonkey.org.uk
