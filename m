Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934306Ab0BQNsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:48:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934083Ab0BQNpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:45:38 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/20] KVM: do not store wqh in irqfd
Date: Wed, 17 Feb 2010 15:45:19 +0200
Message-Id: <1266414330-27444-10-git-send-email-avi@redhat.com>
In-Reply-To: <1266414330-27444-1-git-send-email-avi@redhat.com>
References: <1266414330-27444-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

wqh is unused, so we do not need to store it in irqfd anymore

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/eventfd.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 486c604..7016319 100644
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
1.6.5.3

