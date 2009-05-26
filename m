Return-Path: <linux-kernel-owner+w=401wt.eu-S1755765AbZEZPT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbZEZPT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 11:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbZEZPTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 11:19:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:34390 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbZEZPTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 11:19:48 -0400
Subject: [PATCH -tip][SCSI] scsi: scsi_transport_iscsi.c initialize the
 variable before it get used
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 May 2009 20:49:21 +0530
Message-Id: <1243351161.31783.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am watching this problem from long time in -tip.

Subject: [PATCH] scsi: scsi_transport_iscsi.c initialize the variable before it get used

In some cases, err will be used uninitialized.

Also fixed compilation warning :

 CC      drivers/scsi/scsi_transport_iscsi.o
drivers/scsi/scsi_transport_iscsi.c: In function ‘iscsi_add_session’:
drivers/scsi/scsi_transport_iscsi.c:678: warning: ‘err’ may be used uninitialized in this function

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0947954..e78cde2 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -675,7 +675,7 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 	struct iscsi_cls_host *ihost;
 	unsigned long flags;
 	unsigned int id = target_id;
-	int err;
+	int err = 0;
 
 	ihost = shost->shost_data;
 	session->sid = atomic_add_return(1, &iscsi_session_nr);
-- 
1.6.0.6



