Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbYJ2GEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbYJ2GEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 02:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYJ2GEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 02:04:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47469 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbYJ2GEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 02:04:06 -0400
Date: Wed, 29 Oct 2008 17:03:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com,
       "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: fix uninitialized variable in iscsi
Message-Id: <20081029170359.70682e02.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resend to get through vger's filters, sorry]

drivers/scsi/scsi_transport_iscsi.c: In function 'iscsi_add_session':
drivers/scsi/scsi_transport_iscsi.c:704: warning: 'err' may be used uninitialized in this function

Indeed the error path can be taken without err being set.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/scsi/scsi_transport_iscsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

I don't know if ENOMEM is the proper error code to return.

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 4a803eb..99855db 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -719,6 +719,7 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 						 "Too many iscsi targets. Max "
 						 "number of targets is %d.\n",
 						 ISCSI_MAX_TARGET - 1);
+			err = -ENOMEM;
 			goto release_host;
 		}
 	}
-- 
1.5.6.5

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
