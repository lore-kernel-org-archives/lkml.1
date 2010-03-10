Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab0CJBFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 20:05:18 -0500
Received: from sr-smtp.usish.com ([210.5.144.203]:38910 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab0CJBFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 20:05:14 -0500
From: "jack wang" <jack_wang@usish.com>
To: "'Julia Lawall'" <julia@diku.dk>, <lindar_liu@usish.com>,
       "'James E.J. Bottomley'" <James.Bottomley@suse.de>,
       <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <kernel-janitors@vger.kernel.org>
References: <Pine.LNX.4.64.1003092214110.4974@ask.diku.dk>
Subject: RE: [PATCH 3/5] drivers/scsi: drop redundant memset
Date: Wed, 10 Mar 2010 09:05:07 +0800
Message-ID: <B8AD7A70524143C289C05DFE9857EC84@usish.com.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Acq/zYvpX1SBVS/mR+GlwicaNRn+CAAH/Ckg
In-Reply-To: <Pine.LNX.4.64.1003092214110.4974@ask.diku.dk>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Julia Lawall <julia@diku.dk>

The region set by the call to memset is immediately overwritten by the
subsequent call to memcpy.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e1,e2,e3,e4;
@@

- memset(e1,e2,e3);
  memcpy(e1,e4,e3);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/pm8001/pm8001_hwi.c |    1 -
 1 file changed, 1 deletion(-)

diff -u -p a/drivers/scsi/pm8001/pm8001_hwi.c
b/drivers/scsi/pm8001/pm8001_hwi.c
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4389,7 +4389,6 @@ pm8001_chip_fw_flash_update_req(struct p
 				return -ENOMEM;
 		}
 	}
-	memset(buffer, 0, fw_control->len);
 	memcpy(buffer, fw_control->buffer, fw_control->len);
 	flash_update_info.sgl.addr = cpu_to_le64(phys_addr);
 	flash_update_info.sgl.im_len.len = cpu_to_le32(fw_control->len);



[Jack] Thanks Julia.
Acked-by: Jack Wang <jack_wang@usish.com>

