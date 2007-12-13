Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbXLMJFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbXLMJFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 04:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbXLMJF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 04:05:26 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:30672
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673AbXLMJFY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 04:05:24 -0500
Message-Id: <47610414.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 13 Dec 2007 09:06:12 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <dbrownell@users.sourceforge.net>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] ohci: avoid an unused variable warning
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_PM, but without CONFIG_PM_SLEEP, the intention of the
conditional in ohci_pci_start() doesn't work since device_may_wakeup()
references pdev only with the latter config option.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 drivers/usb/host/ohci-pci.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc5/drivers/usb/host/ohci-pci.c	2007-12-12 11:29:07.000000000 +0100
+++ 2.6.24-rc5-ohci-pm-sleep/drivers/usb/host/ohci-pci.c	2007-12-04 16:09:33.000000000 +0100
@@ -217,7 +217,7 @@ static int __devinit ohci_pci_start (str
 	struct ohci_hcd	*ohci = hcd_to_ohci (hcd);
 	int		ret;
 
-#ifdef CONFIG_PM /* avoid warnings about unused pdev */
+#ifdef CONFIG_PM_SLEEP /* avoid warnings about unused pdev */
 	if (hcd->self.controller) {
 		struct pci_dev *pdev = to_pci_dev(hcd->self.controller);
 



