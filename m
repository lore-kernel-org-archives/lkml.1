Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbYIYCGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbYIYCGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYIYCFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:05:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:61605 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbYIYCFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:05:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WpbIBZYlMzhR65e9SUZ6x/SpNigsFpxVNdiqx4UQOKCz6em3srOBTLKSftH7BKKX5k
         u+3+ILs/h8uDeLRhFFmneWwlqp1lF7QPCGyJmUMULkkLh9ZqauU00LOMfFscix3Ovp7E
         k61ZtXc1pPl+RcYq25V5j5FD1Cpd+8ZO1TnUg=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 3/7] pci: using %pF in quirks.c
Date: Wed, 24 Sep 2008 19:04:33 -0700
Message-Id: <1222308277-10984-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1222308277-10984-1-git-send-email-yhlu.kernel@gmail.com>
References: <1222308277-10984-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 drivers/pci/quirks.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 1f26712..addf2db 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1689,8 +1689,7 @@ static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f, struct pci_f
 		if ((f->vendor == dev->vendor || f->vendor == (u16) PCI_ANY_ID) &&
  		    (f->device == dev->device || f->device == (u16) PCI_ANY_ID)) {
 #ifdef DEBUG
-			dev_dbg(&dev->dev, "calling ");
-			print_fn_descriptor_symbol("%s\n", f->hook);
+			dev_dbg(&dev->dev, "calling %pF\n", f->hook);
 #endif
 			f->hook(dev);
 		}
-- 
1.5.6

