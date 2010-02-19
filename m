Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab0BSROo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:14:44 -0500
Received: from kroah.org ([198.145.64.141]:57449 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567Ab0BSRA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:27 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:38 2010
Message-Id: <20100219163237.935561919@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: [27/93] ioat: fix infinite timeout checking in ioat2_quiesce
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 7e55a70c5b9a57c12f49c44b0847c9343d4f54e4 upstream.

Fix typo in ioat2_quiesce. check 'tmo' is zero, not 'end'.  Also applies
to 2.6.32.3

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/dma/ioat/dma_v2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -249,7 +249,7 @@ int ioat2_quiesce(struct ioat_chan_commo
 	if (is_ioat_active(status) || is_ioat_idle(status))
 		ioat_suspend(chan);
 	while (is_ioat_active(status) || is_ioat_idle(status)) {
-		if (end && time_after(jiffies, end)) {
+		if (tmo && time_after(jiffies, end)) {
 			err = -ETIMEDOUT;
 			break;
 		}


