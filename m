Return-Path: <linux-kernel-owner+w=401wt.eu-S1762266AbYJMJmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266AbYJMJmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759389AbYJMJgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:36:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48615 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759360AbYJMJgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:36:15 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 27/80] serial_8250: pci_enable_device fail is not fully handled
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:36:11 +0100
Message-ID: <20081013093606.21645.88606.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

<rmk> talking about leaks - I noticed that the 'check return of
pci_enable_dev()' in the 8250 pci resume function finally made it in
pite my objections against it (causing stuff in higher levels to leak).

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/serial/8250_pci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index c2f2393..c014ffb 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -2041,9 +2041,9 @@ static int pciserial_resume_one(struct pci_dev *dev)
 		 * The device may have been disabled.  Re-enable it.
 		 */
 		err = pci_enable_device(dev);
+		/* FIXME: We cannot simply error out here */
 		if (err)
-			return err;
-
+			printk(KERN_ERR "pciserial: Unable to re-enable ports, trying to continue.\n");
 		pciserial_resume_ports(priv);
 	}
 	return 0;

