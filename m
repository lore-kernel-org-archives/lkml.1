Return-Path: <linux-kernel-owner+w=401wt.eu-S1761714AbYJEQlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761714AbYJEQlB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761371AbYJEQho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:37:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35301 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761363AbYJEQhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:37:43 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 12/19] pxa27x_udc: leak fix
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:37:44 +0100
Message-ID: <20081005163735.3799.32505.stgit@localhost.localdomain>
In-Reply-To: <20081005163302.3799.61899.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a small leak

Closes #10660
---

 drivers/usb/gadget/pxa27x_udc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
index 7cbc78a..016c781 100644
--- a/drivers/usb/gadget/pxa27x_udc.c
+++ b/drivers/usb/gadget/pxa27x_udc.c
@@ -651,8 +651,10 @@ pxa_ep_alloc_request(struct usb_ep *_ep, gfp_t gfp_flags)
 	struct pxa27x_request *req;
 
 	req = kzalloc(sizeof *req, gfp_flags);
-	if (!req || !_ep)
+	if (!req || !_ep) {
+		kfree(req);
 		return NULL;
+	}
 
 	INIT_LIST_HEAD(&req->queue);
 	req->in_use = 0;

