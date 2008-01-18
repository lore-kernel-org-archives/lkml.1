Return-Path: <linux-kernel-owner+w=401wt.eu-S1764321AbYARU2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764321AbYARU2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760432AbYARU2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:28:12 -0500
Received: from ozlabs.org ([203.10.76.45]:38303 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760362AbYARU2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:28:11 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Makes lguest's irq handler typesafe
Date: Sat, 19 Jan 2008 07:27:36 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jgarzik@pobox.com>,
       Ash Willis <ashwillis@programmer.net>, linux-pcmcia@lists.infradead.org,
       virtualization@lists.linux-foundation.org, Tejun Heo <htejun@gmail.com>
References: <200801190722.26154.rusty@rustcorp.com.au> <200801190725.24271.rusty@rustcorp.com.au>
In-Reply-To: <200801190725.24271.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801190727.36567.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a trivial example.
---
 drivers/lguest/lguest_device.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -r 00ab7672f658 drivers/lguest/lguest_device.c
--- a/drivers/lguest/lguest_device.c	Thu Jan 17 16:54:00 2008 +1100
+++ b/drivers/lguest/lguest_device.c	Thu Jan 17 16:59:46 2008 +1100
@@ -179,9 +179,8 @@ static void lg_notify(struct virtqueue *
 	hcall(LHCALL_NOTIFY, lvq->config.pfn << PAGE_SHIFT, 0, 0);
 }
 
-static irqreturn_t lguest_interrupt(int irq, void *_vq)
+static irqreturn_t lguest_interrupt(int irq, struct virtqueue *vq)
 {
-	struct virtqueue *vq = _vq;
 	struct lguest_device_desc *desc = to_lgdev(vq->vdev)->desc;
 
 	if (unlikely(desc->config_change)) {
