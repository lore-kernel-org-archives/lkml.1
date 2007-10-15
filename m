Return-Path: <linux-kernel-owner+w=401wt.eu-S1764414AbXJOGlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764414AbXJOGlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 02:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbXJOGlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 02:41:09 -0400
Received: from smtp110.biz.mail.re2.yahoo.com ([206.190.53.9]:21988 "HELO
	smtp110.biz.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753377AbXJOGlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 02:41:07 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Oct 2007 02:41:07 EDT
X-YMail-OSG: dTC1YPQVM1n3RBDOgoMree79vmxw.TZVLvOOUGwEq5cx6J_S
From: HighPoint Linux Team <linux@highpoint-tech.com>
Organization: HighPoint Technologies, Inc.
To: "Andrew Morton" <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] hptiop: avoid buffer overflow when returning sense data
Date: Mon, 15 Oct 2007 14:42:52 +0800
User-Agent: KMail/1.5.3
Cc: James.Bottomley@SteelEye.com
References: <200605101704.27491.linux@highpoint-tech.com> <200605161438.09717.linux@highpoint-tech.com> <200708291510.53793.linux@highpoint-tech.com>
In-Reply-To: <200708291510.53793.linux@highpoint-tech.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710151442.52230.linux@highpoint-tech.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


avoid buffer overflow when returning sense data.

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
---

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 8b384fa..d32a4a9 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -375,8 +375,9 @@ static void hptiop_host_request_callback
 		scp->result = SAM_STAT_CHECK_CONDITION;
 		memset(&scp->sense_buffer,
 				0, sizeof(scp->sense_buffer));
-		memcpy(&scp->sense_buffer,
-			&req->sg_list, le32_to_cpu(req->dataxfer_length));
+		memcpy(&scp->sense_buffer, &req->sg_list,
+				min(sizeof(scp->sense_buffer),
+					le32_to_cpu(req->dataxfer_length)));
 		break;
 
 	default:

