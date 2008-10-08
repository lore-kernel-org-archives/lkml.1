Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbYJHTn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbYJHTn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbYJHTkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:40:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:1894 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921AbYJHTky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:40:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TGYAt3zebSDj6ABqSE1SRvVFyL5vCYmkn19lGm6efsrAcDO8qurXG+E+iVMPhnHAOj
         8EptuWlDEAXkBt3po9EdHDn2+I3zr1FqTQTo3oRCpPx+nuvqkOkLyBpRL7jPsULDecl6
         3r4bRLyovEHlpIF2pnusu01ICSJ/uAxwfYfms=
From: "Richard A. Holden III" <aciddeath@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Richard A. Holden III" <aciddeath@gmail.com>, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 10/10] ixj: Remove dead code from ifdef IXJ_DYN_ALLOC.
Date: Wed,  8 Oct 2008 14:41:45 -0600
Message-Id: <d1f78877de0710d0a59e94f2a31798bc2d083892.1223497217.git.aciddeath@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <68f61bde4082cc6405cef40ab800f063c22fb6f6.1223497217.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
 <b1f8a69aa47d6aab5d5a951bc78c99c26dd67658.1223497216.git.aciddeath@gmail.com>
 <a04aa1aa0a991f7ea2b0bd9649e4197e30b14ac9.1223497216.git.aciddeath@gmail.com>
 <c0839cc2716ec89be7e165ad0d50b6bcf9be00db.1223497216.git.aciddeath@gmail.com>
 <659ee5c8af676929264fafd812d539c372f6ee9d.1223497216.git.aciddeath@gmail.com>
 <8b2fbd3480fa4d2e08da0d1ea5a6f9860e6d8bea.1223497216.git.aciddeath@gmail.com>
 <4f6d77649769072c98fa1e6bcafd963b6b050190.1223497216.git.aciddeath@gmail.com>
 <d9e83f28187798f57dc2174a19eda735af09a90f.1223497217.git.aciddeath@gmail.com>
 <c151f6b92c2b5a21d74ac20d7ef57b4960d6935c.1223497217.git.aciddeath@gmail.com>
 <68f61bde4082cc6405cef40ab800f063c22fb6f6.1223497217.git.aciddeath@gmail.com>
In-Reply-To: <cover.1223497216.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no way to set IXJ_DYN_ALLOC from kernel config, remove dead code.

Signed-off-by: Richard A. Holden III <aciddeath@gmail.com>
---
 drivers/telephony/ixj.c |   62 -----------------------------------------------
 drivers/telephony/ixj.h |    4 ---
 2 files changed, 0 insertions(+), 66 deletions(-)

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index e502f02..4218520 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -309,57 +309,6 @@ MODULE_DEVICE_TABLE(pci, ixj_pci_tbl);
 *
 ************************************************************************/
 
-#ifdef IXJ_DYN_ALLOC
-
-static IXJ *ixj[IXJMAX];
-#define	get_ixj(b)	ixj[(b)]
-
-/*
- *	Allocate a free IXJ device
- */
- 
-static IXJ *ixj_alloc()
-{
-	for(cnt=0; cnt<IXJMAX; cnt++)
-	{
-		if(ixj[cnt] == NULL || !ixj[cnt]->DSPbase)
-		{
-			j = kmalloc(sizeof(IXJ), GFP_KERNEL);
-			if (j == NULL)
-				return NULL;
-			ixj[cnt] = j;
-			return j;
-		}
-	}
-	return NULL;
-}
-
-static void ixj_fsk_free(IXJ *j)
-{
-	kfree(j->fskdata);
-	j->fskdata = NULL;
-}
-
-static void ixj_fsk_alloc(IXJ *j)
-{
-	if(!j->fskdata) {
-		j->fskdata = kmalloc(8000, GFP_KERNEL);
-		if (!j->fskdata) {
-			if(ixjdebug & 0x0200) {
-				printk("IXJ phone%d - allocate failed\n", j->board);
-			}
-			return;
-		} else {
-			j->fsksize = 8000;
-			if(ixjdebug & 0x0200) {
-				printk("IXJ phone%d - allocate succeded\n", j->board);
-			}
-		}
-	}
-}
-
-#else
-
 static IXJ ixj[IXJMAX];
 #define	get_ixj(b)	(&ixj[(b)])
 
@@ -384,8 +333,6 @@ static inline void ixj_fsk_alloc(IXJ *j)
 	j->fsksize = 8000;
 }
 
-#endif
-
 #ifdef PERFMON_STATS
 #define ixj_perfmon(x)	((x)++)
 #else
@@ -7079,9 +7026,6 @@ static int ixj_selfprobe(IXJ *j)
 	j->ex_sig.bits.dtmf_ready = j->ex_sig.bits.hookstate = j->ex_sig.bits.flash = j->ex_sig.bits.pstn_ring = 
 	j->ex_sig.bits.caller_id = j->ex_sig.bits.pstn_wink = j->ex_sig.bits.f0 = j->ex_sig.bits.f1 = j->ex_sig.bits.f2 = 
 	j->ex_sig.bits.f3 = j->ex_sig.bits.fc0 = j->ex_sig.bits.fc1 = j->ex_sig.bits.fc2 = j->ex_sig.bits.fc3 = 1;
-#ifdef IXJ_DYN_ALLOC
-	j->fskdata = NULL;
-#endif
 	j->fskdcnt = 0;
 	j->cidcw_wait = 0;
  
@@ -7405,12 +7349,6 @@ static void cleanup(void)
 			if (ixjdebug & 0x0002)
 				printk(KERN_INFO "IXJ: Releasing DSP address for /dev/phone%d\n", cnt);
 			release_region(j->DSPbase, 16);
-#ifdef IXJ_DYN_ALLOC
-			if (ixjdebug & 0x0002)
-				printk(KERN_INFO "IXJ: Freeing memory for /dev/phone%d\n", cnt);
-			kfree(j);
-			ixj[cnt] = NULL;
-#endif
 		}
 	}
 	if (ixjdebug & 0x0002)
diff --git a/drivers/telephony/ixj.h b/drivers/telephony/ixj.h
index 4c32a43..fe8c690 100644
--- a/drivers/telephony/ixj.h
+++ b/drivers/telephony/ixj.h
@@ -1307,11 +1307,7 @@ typedef struct {
 	unsigned long iscontrolready;
 	unsigned long iscontrolreadyfail;
 	unsigned long pstnstatecheck;
-#ifdef IXJ_DYN_ALLOC
-	short *fskdata;
-#else
 	short fskdata[8000];
-#endif
 	int fsksize;
 	int fskdcnt;
 } IXJ;
-- 
1.5.6.4

