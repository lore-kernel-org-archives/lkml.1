Return-Path: <linux-kernel-owner+w=401wt.eu-S1760177AbYBYA03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177AbYBYA03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbYBYAZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:25:34 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:9206 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbYBYAZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:25:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=o7Z6erg8RF0RZ0Zj4NL5QYytqEeyCy4nbfi+yA6zyLGU0oE3VLfeA7qZNBqPVJBDZenE/XE+wGPQ2WQ25odROaqgFwx6FAs06pNfVyvtdA3CFGfwNhYre8cxIGCbPLDyO4SPtlejFebKNmv4qTh5mudOE63kstndk2ynO6NZ40Y=
Subject: [PATCH 3/6] agp: fix shadowed variable warning in amd-k7-agp.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <5ce117613299590dd08d11d24d3a33d9077fe2b0.1203898924.git.harvey.harrison@gmail.com>
References: <5ce117613299590dd08d11d24d3a33d9077fe2b0.1203898924.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 16:25:36 -0800
Message-Id: <1203899136.1767.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduced between 2.6.25-rc2 and -rc3
drivers/char/agp/amd-k7-agp.c:439:6: warning: symbol 'cap_ptr' shadows an earlier one
drivers/char/agp/amd-k7-agp.c:414:5: originally declared here

cap_ptr is never used again in this function, don't bother redeclaring.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/char/agp/amd-k7-agp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
index d286699..96bdb92 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -436,8 +436,9 @@ static int __devinit agp_amdk7_probe(struct pci_dev *pdev,
 	   system controller may experience noise due to strong drive strengths
 	 */
 	if (agp_bridge->dev->device == PCI_DEVICE_ID_AMD_FE_GATE_7006) {
-		u8 cap_ptr=0;
 		struct pci_dev *gfxcard=NULL;
+
+		cap_ptr = 0;
 		while (!cap_ptr) {
 			gfxcard = pci_get_class(PCI_CLASS_DISPLAY_VGA<<8, gfxcard);
 			if (!gfxcard) {
-- 
1.5.4.2.200.g99e75


