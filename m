Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab0BENwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 08:52:55 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:60383 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587Ab0BENww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 08:52:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Re5e+ofyeD/kShZb3VDiF8+DqzCrZm2z1XiCJ87DzKCQeCgCDt/q+KWqGt/Lnge8y6
         GJNI+MU3Hcx5LjIZZtjuGrXos1pKcavRF+00/r9oXl44DKjgytFZjvJEQwKLBKE6uhHf
         EZUH0HG9UejeMBKBRMAJi/OHct1zNrRSgYmiM=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, Jing Huang <huangj@brocade.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Roel Kluin <roel.kluin@gmail.com>, linux-scsi@vger.kernel.org
Subject: [PATCH 2/4] [SCSI] bfa: correct onstack wait_queue_head declaration
Date: Fri,  5 Feb 2010 21:52:38 +0800
Message-Id: <b47c0527f1471857fec4662da1bfd0bb9e6071a7.1265375697.git.yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <b1dccd762d3d04ab75d79d1d9b097d593a89f32a.1265375697.git.yong.zhang0@gmail.com>
References: <1265377920-5898-1-git-send-email-yong.zhang0@gmail.com>
 <b1dccd762d3d04ab75d79d1d9b097d593a89f32a.1265375697.git.yong.zhang0@gmail.com>
In-Reply-To: <b1dccd762d3d04ab75d79d1d9b097d593a89f32a.1265375697.git.yong.zhang0@gmail.com>
References: <b1dccd762d3d04ab75d79d1d9b097d593a89f32a.1265375697.git.yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DECLARE_WAIT_QUEUE_HEAD_ONSTACK to make lockdep happy

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Jing Huang <huangj@brocade.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/bfa/bfad_im.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index f788c2a..3299c7e 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -282,7 +282,7 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
 	struct bfa_tskim_s *tskim;
 	struct bfad_itnim_s   *itnim;
 	struct bfa_itnim_s *bfa_itnim;
-	DECLARE_WAIT_QUEUE_HEAD(wq);
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
 	int             rc = SUCCESS;
 	unsigned long   flags;
 	enum bfi_tskim_status task_status;
@@ -344,7 +344,7 @@ bfad_im_reset_bus_handler(struct scsi_cmnd *cmnd)
 	struct bfad_itnim_s   *itnim;
 	unsigned long   flags;
 	u32        i, rc, err_cnt = 0;
-	DECLARE_WAIT_QUEUE_HEAD(wq);
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
 	enum bfi_tskim_status task_status;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-- 
1.6.3.3

