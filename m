Return-Path: <linux-kernel-owner+w=401wt.eu-S1764558AbXJRPAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764558AbXJRPAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757184AbXJRPAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:00:35 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:44401 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbXJRPAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:00:34 -0400
Message-ID: <47177510.6040405@tiscali.nl>
Date: Thu, 18 Oct 2007 17:00:32 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] fix not-and/or errors
References: <47161243.6060007@tiscali.nl>
In-Reply-To: <47161243.6060007@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

previously applied changes removed and changed as suggested.

    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/misc/asus-laptop.c b/drivers/misc/asus-laptop.c
index 7dce318..752ae26 100644
--- a/drivers/misc/asus-laptop.c
+++ b/drivers/misc/asus-laptop.c
@@ -322,7 +322,7 @@ static void write_status(acpi_handle handle, int out, int mask)
 
 	switch (mask) {
 	case MLED_ON:
-		out = !out & 0x1;
+		out = !out;
 		break;
 	case GLED_ON:
 		out = (out & 0x1) + 1;
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 73c44cb..289165e 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2882,7 +2882,8 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			    !(STp->use_pf & PF_TESTED)) {
 				/* Try the other possible state of Page Format if not
 				   already tried */
-				STp->use_pf = !STp->use_pf | PF_TESTED;
+				STp->use_pf ^= PF_TESTED | USE_PF; /* remove USE_PF, set *
+								    * PF_TESTED */
 				st_release_request(SRpnt);
 				SRpnt = NULL;
 				return st_int_ioctl(STp, cmd_in, arg);

