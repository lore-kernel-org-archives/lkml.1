Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbYG1FHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbYG1FHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 01:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYG1FHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 01:07:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38004 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbYG1FHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 01:07:08 -0400
Date: Mon, 28 Jul 2008 15:07:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: linux-next: build failure
Message-Id: <20080728150705.67408647.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James, Andrew,

(Previously reported by Dave Miller.)

Today's linux-next build (powerpc allyesconfig) failed like this:

drivers/scsi/qla2xxx/qla_attr.c: In function 'qla24xx_vport_delete':
drivers/scsi/qla2xxx/qla_attr.c:1184: error: implicit declaration of function 'msleep'

I applied the patch below.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

>From 879b13261ee593b8afcae80a33844f162e8e8a5c Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 28 Jul 2008 15:02:35 +1000
Subject: [PATCH] scsi: msleep is declared in delay.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/scsi/qla2xxx/qla_attr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 7a4409a..a319a20 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -8,6 +8,7 @@
 
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
+#include <linux/delay.h>
 
 static int qla24xx_vport_disable(struct fc_vport *, bool);
 
-- 
1.5.6.3

