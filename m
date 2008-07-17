Return-Path: <linux-kernel-owner+w=401wt.eu-S932066AbYGQRcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbYGQRcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757190AbYGQRbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:31:53 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:61188 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbYGQRbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:31:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=sTfnUmfeGcLO824fEIk88elUHmcpwtftGhlTgOqv0P7FJHxSv8nLKCpNwRiH+G3aBC
         ZHh4AzS1dPJgSWxwc5imK7EMSw9gTuCRb/e9kI++z6MNzOVezUCUMcYlcutNFPs3SHzR
         vc2l8Qxahrxjkzkf1aToXNOnG29S2jPiB79W8=
Date: Thu, 17 Jul 2008 19:31:49 +0200
From: Loic Grenie <loic.grenie@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Typecast problems in SKFP driver
Message-ID: <20080717173149.GA5040@cognac.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

    I've just compiled the 2.6.26-git5 kernel and the SKFP driver
    compilation produces complaints about typecasts. These complaints
    disappear with the following patch.

      Thanks,

          Loïc Grenié

--Qxx1br4bt0+wmkIi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="skfp.diff"

diff --git a/drivers/net/skfp/ess.c b/drivers/net/skfp/ess.c
index 889f987..d3a8afc 100644
--- a/drivers/net/skfp/ess.c
+++ b/drivers/net/skfp/ess.c
@@ -510,7 +510,7 @@ static void ess_send_response(struct s_smc *smc, struct smt_header *sm,
 	chg->path.para.p_type = SMT_P320B ;
 	chg->path.para.p_len = sizeof(struct smt_p_320b) - PARA_LEN ;
 	chg->path.mib_index = SBAPATHINDEX ;
-	chg->path.path_pad = (u_short)NULL ;
+	chg->path.path_pad = (u_short)(long)NULL ;
 	chg->path.path_index = PRIMARY_RING ;
 
 	/* set P320F */
@@ -606,7 +606,7 @@ static void ess_send_alc_req(struct s_smc *smc)
 	req->path.para.p_type = SMT_P320B ;
 	req->path.para.p_len = sizeof(struct smt_p_320b) - PARA_LEN ;
 	req->path.mib_index = SBAPATHINDEX ;
-	req->path.path_pad = (u_short)NULL ;
+	req->path.path_pad = (u_short)(long)NULL ;
 	req->path.path_index = PRIMARY_RING ;
 
 	/* set P0017 */
@@ -636,7 +636,7 @@ static void ess_send_alc_req(struct s_smc *smc)
 	/* set P19 */
 	req->a_addr.para.p_type = SMT_P0019 ;
 	req->a_addr.para.p_len = sizeof(struct smt_p_0019) - PARA_LEN ;
-	req->a_addr.sba_pad = (u_short)NULL ;
+	req->a_addr.sba_pad = (u_short)(long)NULL ;
 	req->a_addr.alloc_addr = null_addr ;
 
 	/* set P1A */
diff --git a/drivers/net/skfp/pmf.c b/drivers/net/skfp/pmf.c
index ea85de9..5798be4 100644
--- a/drivers/net/skfp/pmf.c
+++ b/drivers/net/skfp/pmf.c
@@ -44,17 +44,17 @@ static SMbuf *smt_build_pmf_response(struct s_smc *smc, struct smt_header *req,
 				     int set, int local);
 static int port_to_mib(struct s_smc *smc, int p);
 
-#define MOFFSS(e)	((int)&(((struct fddi_mib *)0)->e))
-#define MOFFSA(e)	((int) (((struct fddi_mib *)0)->e))
+#define MOFFSS(e)	((long)&(((struct fddi_mib *)0)->e))
+#define MOFFSA(e)	((long) (((struct fddi_mib *)0)->e))
 
-#define MOFFMS(e)	((int)&(((struct fddi_mib_m *)0)->e))
-#define MOFFMA(e)	((int) (((struct fddi_mib_m *)0)->e))
+#define MOFFMS(e)	((long)&(((struct fddi_mib_m *)0)->e))
+#define MOFFMA(e)	((long) (((struct fddi_mib_m *)0)->e))
 
-#define MOFFAS(e)	((int)&(((struct fddi_mib_a *)0)->e))
-#define MOFFAA(e)	((int) (((struct fddi_mib_a *)0)->e))
+#define MOFFAS(e)	((long)&(((struct fddi_mib_a *)0)->e))
+#define MOFFAA(e)	((long) (((struct fddi_mib_a *)0)->e))
 
-#define MOFFPS(e)	((int)&(((struct fddi_mib_p *)0)->e))
-#define MOFFPA(e)	((int) (((struct fddi_mib_p *)0)->e))
+#define MOFFPS(e)	((long)&(((struct fddi_mib_p *)0)->e))
+#define MOFFPA(e)	((long) (((struct fddi_mib_p *)0)->e))
 
 
 #define AC_G	0x01		/* Get */

--Qxx1br4bt0+wmkIi--
