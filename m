Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab0BWRBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 12:01:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541Ab0BWRBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 12:01:42 -0500
Date: Tue, 23 Feb 2010 18:57:51 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       markmc@redhat.com, gleb@redhat.com, herbert.xu@redhat.com,
       quintela@redhat.com, dlaor@redhat.com, avi@redhat.com
Subject: [PATCH 2/3] vhost: initialize log eventfd context pointer
Message-ID: <f383d82104a04b92fe2953a4d8a98425c1ff6cde.1266943453.git.mst@redhat.com>
References: <cover.1266943453.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1266943453.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vq log eventfd context pointer needs to be initialized, otherwise
operation may fail or oops if log is enabled but log eventfd not set by
userspace.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index c767279..d4f8fdf 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -121,6 +121,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	vq->kick = NULL;
 	vq->call_ctx = NULL;
 	vq->call = NULL;
+	vq->log_ctx = NULL;
 }
 
 long vhost_dev_init(struct vhost_dev *dev,
-- 
1.7.0.18.g0d53a5

