Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZBFDJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZBFDJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 22:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZBFDJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 22:09:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58438 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbZBFDJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 22:09:04 -0500
Message-ID: <498BA9CA.7060700@cn.fujitsu.com>
Date: Fri, 06 Feb 2009 11:08:58 +0800
From: Wei Yongjun <yjwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: drivers/staging/usbip/stub_rx.c: kmem_cache_alloc/memset -> kmem_cache_zalloc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit

Used kmem_cache_zalloc instead of kmem_cache_alloc/memset.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 drivers/staging/usbip/stub_rx.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
index 2eb6137..1c71062 100644
--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -334,7 +334,7 @@ static struct stub_priv *stub_priv_alloc(struct stub_device *sdev,
 
 	spin_lock_irqsave(&sdev->priv_lock, flags);
 
-	priv = kmem_cache_alloc(stub_priv_cache, GFP_ATOMIC);
+	priv = kmem_cache_zalloc(stub_priv_cache, GFP_ATOMIC);
 	if (!priv) {
 		dev_err(&sdev->interface->dev, "alloc stub_priv\n");
 		spin_unlock_irqrestore(&sdev->priv_lock, flags);
@@ -342,8 +342,6 @@ static struct stub_priv *stub_priv_alloc(struct stub_device *sdev,
 		return NULL;
 	}
 
-	memset(priv, 0, sizeof(struct stub_priv));
-
 	priv->seqnum = pdu->base.seqnum;
 	priv->sdev = sdev;
 
-- 
1.5.3.8



