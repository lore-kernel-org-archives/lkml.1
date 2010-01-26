Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468Ab0AZXzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab0AZXzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693Ab0AZXzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:55:49 -0500
Received: from kroah.org ([198.145.64.141]:35361 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648Ab0AZXnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:47 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:28 2010
Message-Id: <20100126233928.109137872@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ron Mercer <ron.mercer@qlogic.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [55/98] qlge: Set PCIE max read request size.
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ron Mercer <ron.mercer@qlogic.com>

commit bc9167f39ff8cd428e8577eb72751a653008edb2 upstream.

Signed-off-by: Ron Mercer <ron.mercer@qlogic.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/qlge/qlge_main.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/qlge/qlge_main.c
+++ b/drivers/net/qlge/qlge_main.c
@@ -3881,6 +3881,13 @@ static int __devinit ql_init_device(stru
 	qdev->pdev = pdev;
 	pci_set_drvdata(pdev, ndev);
 
+	/* Set PCIe read request size */
+	err = pcie_set_readrq(pdev, 4096);
+	if (err) {
+		dev_err(&pdev->dev, "Set readrq failed.\n");
+		goto err_out;
+	}
+
 	err = pci_request_regions(pdev, DRV_NAME);
 	if (err) {
 		dev_err(&pdev->dev, "PCI region request failed.\n");


