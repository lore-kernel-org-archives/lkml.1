Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbYBLXIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbYBLXIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:08:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757887AbYBLXHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:07:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:4852 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678AbYBLXHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:07:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=MnZTxkZex+i9e3hCQurmLLhM+0MCrGjZmGFLZBDLyYKPr2EZccEv0F42J09z606iiVjExpZfATb+MzcqrPdY1IWQUHMeH/Vmz0bU34WHSY6s3KfisvUJoDTli0yukZxiND5NNBOBKTk1MncVx+Xfn4MysJHXsDyCj6o06kM6rpg=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: [PATCH] infiniband: be*_add_cpu conversion
Date: Wed, 13 Feb 2008 00:06:08 +0100
Message-Id: <1202857582-15450-4-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
big_endian_variable = cpu_to_beX(beX_to_cpu(big_endian_variable) +
					expression_in_cpu_byteorder);
with:
	beX_add_cpu(&big_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
---
 drivers/infiniband/hw/mthca/mthca_cq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_cq.c b/drivers/infiniband/hw/mthca/mthca_cq.c
index 6bd9f13..1e1e336 100644
--- a/drivers/infiniband/hw/mthca/mthca_cq.c
+++ b/drivers/infiniband/hw/mthca/mthca_cq.c
@@ -473,7 +473,7 @@ static void handle_error_cqe(struct mthca_dev *dev, struct mthca_cq *cq,
 	if (!(new_wqe & cpu_to_be32(0x3f)) || (!cqe->db_cnt && dbd))
 		return;
 
-	cqe->db_cnt   = cpu_to_be16(be16_to_cpu(cqe->db_cnt) - dbd);
+	be16_add_cpu(&cqe->db_cnt, -dbd);
 	cqe->wqe      = new_wqe;
 	cqe->syndrome = SYNDROME_WR_FLUSH_ERR;
 
-- 
1.5.3.7

