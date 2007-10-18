Return-Path: <linux-kernel-owner+w=401wt.eu-S1764716AbXJRRm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764716AbXJRRm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764807AbXJRRln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:41:43 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:1451 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764609AbXJRRll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:41:41 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Subject: Fix guest time accounting going faster than user time accounting
Date: Thu, 18 Oct 2007 19:41:31 +0200
User-Agent: KMail/1.9.7
Cc: Laurent Vivier <Laurent.Vivier@bull.net>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181941.31181.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seems I overlooked this type while reviewing Laurents patch.
cputime_add already adds, dont do it twice.

Avi. This should go to Linus before 2.6.24.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

---
 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23/fs/proc/array.c
===================================================================
--- linux-2.6.23.orig/fs/proc/array.c
+++ linux-2.6.23/fs/proc/array.c
@@ -446,7 +446,7 @@ static int do_task_stat(struct task_stru
 			maj_flt += sig->maj_flt;
 			utime = cputime_add(utime, sig->utime);
 			stime = cputime_add(stime, sig->stime);
-			gtime += cputime_add(gtime, sig->gtime);
+			gtime = cputime_add(gtime, sig->gtime);
 		}
 
 		sid = signal_session(sig);
