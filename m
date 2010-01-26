Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678Ab0AZXxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab0AZXxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473Ab0AZXnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:50 -0500
Received: from kroah.org ([198.145.64.141]:35366 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616Ab0AZXns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:48 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:28 2010
Message-Id: <20100126233928.239244487@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ron Mercer <ron.mercer@qlogic.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [56/98] qlge: Dont fail open when port is not initialized.
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ron Mercer <ron.mercer@qlogic.com>

commit 80928860941023bb37e9c61927395d0eb753bc3b upstream.

Signed-off-by: Ron Mercer <ron.mercer@qlogic.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/qlge/qlge_main.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/qlge/qlge_main.c
+++ b/drivers/net/qlge/qlge_main.c
@@ -3310,10 +3310,8 @@ static int ql_adapter_initialize(struct 
 
 	/* Initialize the port and set the max framesize. */
 	status = qdev->nic_ops->port_initialize(qdev);
-       if (status) {
-              QPRINTK(qdev, IFUP, ERR, "Failed to start port.\n");
-              return status;
-       }
+	if (status)
+		QPRINTK(qdev, IFUP, ERR, "Failed to start port.\n");
 
 	/* Set up the MAC address and frame routing filter. */
 	status = ql_cam_route_initialize(qdev);


