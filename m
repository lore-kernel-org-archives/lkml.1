Return-Path: <linux-kernel-owner+w=401wt.eu-S1759279AbYB1EWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279AbYB1EWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 23:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756485AbYB1EWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 23:22:00 -0500
Received: from mail.gmx.net ([213.165.64.20]:36991 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752849AbYB1EV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 23:21:59 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19KYNBjyCNKRIXqgVH3K84OMiD619YOxLhDLuVNrL
	Ix9jfZddDr1ryk
Subject: Re: [Regression in 2.6.25-rcX] CD/DVD writer no longer works
From: Mike Galbraith <efault@gmx.de>
To: zkopex mtrof <zkopex@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <916729.18642.qm@web45209.mail.sp1.yahoo.com>
References: <916729.18642.qm@web45209.mail.sp1.yahoo.com>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 05:21:56 +0100
Message-Id: <1204172516.10161.14.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-27 at 19:26 -0800, zkopex mtrof wrote:

> [patch snipped]
> 
> Thank you very much! The patch you supplied fixes the regression!

You're welcome.  In the meantime, I found a better way.

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ba21d97..7a6f784 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -871,7 +871,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			scsi_end_bidi_request(cmd);
 			return;
 		}
-		req->data_len = scsi_get_resid(cmd);
+		req->data_len = req->raw_data_len = scsi_get_resid(cmd);
 	}
 
 	BUG_ON(blk_bidi_rq(req)); /* bidi not support for !blk_pc_request yet */


> To be honest, I was expecting a few replies from the appropriate
> kernel developers. It looks like I have missed something in
> my regression report.

I think some of those are traveling.

	-Mike

