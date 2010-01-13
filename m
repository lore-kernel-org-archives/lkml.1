Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207Ab0AMRPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0AMRPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 12:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200Ab0AMRPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 12:15:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137Ab0AMRPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 12:15:36 -0500
Date: Wed, 13 Jan 2010 19:12:39 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>,
       "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] kvm: do not store wqh in irqfd
Message-ID: <20100113171239.GC19798@redhat.com>
References: <cover.1263402727.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1263402727.git.mst@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wqh is unused, so we do not need to store it in irqfd anymore

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 virt/kvm/eventfd.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index a9d3fc6..ee17ab4 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -47,7 +47,6 @@ struct _irqfd {
 	int                       gsi;
 	struct list_head          list;
 	poll_table                pt;
-	wait_queue_head_t        *wqh;
 	wait_queue_t              wait;
 	struct work_struct        inject;
 	struct work_struct        shutdown;
@@ -159,8 +158,6 @@ irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
 			poll_table *pt)
 {
 	struct _irqfd *irqfd = container_of(pt, struct _irqfd, pt);
-
-	irqfd->wqh = wqh;
 	add_wait_queue(wqh, &irqfd->wait);
 }
 
-- 
1.6.6.144.g5c3af
