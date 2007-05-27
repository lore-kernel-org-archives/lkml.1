Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbXE0LJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbXE0LJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 07:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbXE0LJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 07:09:20 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33214 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbXE0LJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 07:09:20 -0400
Date: Sun, 27 May 2007 07:09:18 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian Hoegsberg <krh@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] firewire: fix return code
Message-ID: <20070527110918.GA11367@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix this warning on x86-64

drivers/firewire/fw-cdev.c:798: warning: initialization from incompatible pointer type

by making the return code of ioctl_send_request() the same as all the
other ioctl_xxx() return codes.

Signed-off-by: Jeff Garzik <jeff@garzik.org>

diff --git a/drivers/firewire/fw-cdev.c b/drivers/firewire/fw-cdev.c
index 0fa5bd5..3ab3585 100644
--- a/drivers/firewire/fw-cdev.c
+++ b/drivers/firewire/fw-cdev.c
@@ -365,7 +365,7 @@ complete_transaction(struct fw_card *card, int rcode,
 		    response->response.data, response->response.length);
 }
 
-static ssize_t ioctl_send_request(struct client *client, void *buffer)
+static int ioctl_send_request(struct client *client, void *buffer)
 {
 	struct fw_device *device = client->device;
 	struct fw_cdev_send_request *request = buffer;
