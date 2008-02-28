Return-Path: <linux-kernel-owner+w=401wt.eu-S932134AbYB1TN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbYB1TN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760745AbYB1TL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:11:28 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:33939 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760393AbYB1TLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:11:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=g08eFoMSEvMy4RXcc6PGrJizPF93+LQ9XEz8+d3r6svPmWJypl9+InqUBbo3rbD0buDJm7QCjTWsFtHrQKdpO+w7kDLPVX4Drh/ASI/mlqNJtL5/oM+oQQrvCR3IjkkLpl76ebIdgKsU4Bw/QTq16Yt+BbvPasQBW+0Z9LawrdE=
Subject: [PATCH 6/8] sound: pcxhr_core.c fix shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 11:11:14 -0800
Message-Id: <1204225874.20280.85.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inner loop redeclares err with u32 rather than int, stupid fix here
is to change the inner err to err2.
sound/pci/pcxhr/pcxhr_core.c:1008:8: warning: symbol 'err' shadows an earlier one
sound/pci/pcxhr/pcxhr_core.c:983:6: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/pcxhr/pcxhr_core.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/sound/pci/pcxhr/pcxhr_core.c b/sound/pci/pcxhr/pcxhr_core.c
index c4e415d..5287a80 100644
--- a/sound/pci/pcxhr/pcxhr_core.c
+++ b/sound/pci/pcxhr/pcxhr_core.c
@@ -1005,29 +1005,29 @@ void pcxhr_msg_tasklet(unsigned long arg)
 			int nb_stream = (prmh->stat[i] >> (2*FIELD_SIZE)) & MASK_FIRST_FIELD;
 			int pipe = prmh->stat[i] & MASK_FIRST_FIELD;
 			int is_capture = prmh->stat[i] & 0x400000;
-			u32 err;
+			u32 err2;
 
 			if (prmh->stat[i] & 0x800000) {	/* if BIT_END */
 				snd_printdd("TASKLET : End%sPipe %d\n",
 					    is_capture ? "Record" : "Play", pipe);
 			}
 			i++;
-			err = prmh->stat[i] ? prmh->stat[i] : prmh->stat[i+1];
-			if (err)
-				pcxhr_handle_async_err(mgr, err, PCXHR_ERR_PIPE,
+			err2 = prmh->stat[i] ? prmh->stat[i] : prmh->stat[i+1];
+			if (err2)
+				pcxhr_handle_async_err(mgr, err2, PCXHR_ERR_PIPE,
 						       pipe, is_capture);
 			i += 2;
 			for (j = 0; j < nb_stream; j++) {
-				err = prmh->stat[i] ? prmh->stat[i] : prmh->stat[i+1];
-				if (err)
-					pcxhr_handle_async_err(mgr, err, PCXHR_ERR_STREAM,
+				err2 = prmh->stat[i] ? prmh->stat[i] : prmh->stat[i+1];
+				if (err2)
+					pcxhr_handle_async_err(mgr, err2, PCXHR_ERR_STREAM,
 							       pipe, is_capture);
 				i += 2;
 			}
 			for (j = 0; j < nb_audio; j++) {
-				err = prmh->stat[i] ? prmh->stat[i] : prmh->stat[i+1];
-				if (err)
-					pcxhr_handle_async_err(mgr, err, PCXHR_ERR_AUDIO,
+				err2 = prmh->stat[i] ? prmh->stat[i] : prmh->stat[i+1];
+				if (err2)
+					pcxhr_handle_async_err(mgr, err2, PCXHR_ERR_AUDIO,
 							       pipe, is_capture);
 				i += 2;
 			}
-- 
1.5.4.3.342.g99e8


