Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbYE0IA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbYE0IA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 04:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbYE0IAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 04:00:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59918 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754055AbYE0IAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 04:00:11 -0400
Message-ID: <483BBF36.80500@cn.fujitsu.com>
Date: Tue, 27 May 2008 15:58:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: James.Bottomley@HansenPartnership.com
CC: michaelc@cs.wisc.edu, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi/libiscsi.c: return -errno rather than errno
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iscsi_prep_scsi_cmd_pdu() returns EIO in a failing path,
but returns -errno in other paths.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 drivers/scsi/libiscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index b43bf1d..d380f46 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -307,7 +307,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 	hdr->hlength = hdrlength & 0xFF;
 
 	if (conn->session->tt->init_cmd_task(conn->ctask))
-		return EIO;
+		return -EIO;
 
 	conn->scsicmd_pdus_cnt++;
 	debug_scsi("iscsi prep [%s cid %d sc %p cdb 0x%x itt 0x%x "
-- 1.5.4.rc3
