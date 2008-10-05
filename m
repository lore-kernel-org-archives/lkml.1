Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbYJEQli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbYJEQli (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbYJEQhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:37:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35303 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756851AbYJEQhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:37:53 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 13/19] serial_8250: pci_enable_device fail is not fully handled
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:37:53 +0100
Message-ID: <20081005163749.3799.23306.stgit@localhost.localdomain>
In-Reply-To: <20081005163302.3799.61899.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<rmk> talking about leaks - I noticed that the 'check return of
pci_enable_dev()' in the 8250 pci resume function finally made it in
pite my objections against it (causing stuff in higher levels to leak).
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

