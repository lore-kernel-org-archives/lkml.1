Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbZFTIHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbZFTIHE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 04:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbZFTIGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 04:06:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:47845 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbZFTIGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 04:06:41 -0400
Subject: [SCSI RESEND] scsi_transport_iscsi.c return -EOVERFLOW for Too
 many iscsi targets
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Mike Christie <michaelc@cs.wisc.edu>
In-Reply-To: <1243401279.3118.2.camel@localhost.localdomain>
References: <1243401279.3118.2.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Jun 2009 13:29:21 +0530
Message-Id: <1245484761.3102.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


setting err as -EOVERFLOW for Too many iscsi targets.

Also fixes compiler warning for gcc 4.3.3 and gcc 4.4 :

  CC      drivers/scsi/scsi_transport_iscsi.o
drivers/scsi/scsi_transport_iscsi.c: In function ‘iscsi_add_session’:
drivers/scsi/scsi_transport_iscsi.c:678: warning: ‘err’ may be used uninitialized in this function

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/scsi/scsi_transport_iscsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0947954..fdcda7f 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -693,6 +693,7 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 						 "Too many iscsi targets. Max "
 						 "number of targets is %d.\n",
 						 ISCSI_MAX_TARGET - 1);
+			err = -EOVERFLOW;
 			goto release_host;
 		}
 	}
-- 
1.6.0.6



