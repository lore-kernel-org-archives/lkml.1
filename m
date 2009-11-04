Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbZKDNfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbZKDNfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbZKDNfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:35:41 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:17593 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbZKDNfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:35:40 -0500
X-SpamScore: -12
X-BigFish: VPS-12(z21eWzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KSL72Z-04-CG9-02
X-M-MSG: 
Date: Wed, 4 Nov 2009 14:35:37 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: x86 <x86@kernel.org>, Doug Thompson <norsk5@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AMD64 EDAC fixes for 2.6.32-rc7
Message-ID: <20091104133536.GB16373@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 04 Nov 2009 13:35:22.0701 (UTC) FILETIME=[A8AC3FD0:01CA5D53]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following two oneliners.

The first one is a regression which I introduced in .31 merge window
(and I'm crawling ashamed back in my corner) and the second one is
rather theoretical in the sense that it hasn't happened on a real
workload but was caught by code staring instead (yeah, people do stare
at edac code :)).

Thanks.

The following changes since commit 51bb296b09a83ee1aae025778db38f9d2cc7bb1a:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Borislav Petkov (1):
      amd64_edac: fix CECCs reporting

Li Hong (1):
      amd64_edac: fix a wrong goto clause in amd64_edac.c

 drivers/edac/amd64_edac.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)


-------
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index d4560d9..a38831c 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2254,7 +2254,7 @@ static inline void __amd64_decode_bus_error(struct mem_ctl_info *mci,
 {
 	u32 ec  = ERROR_CODE(info->nbsl);
 	u32 xec = EXT_ERROR_CODE(info->nbsl);
-	int ecc_type = info->nbsh & (0x3 << 13);
+	int ecc_type = (info->nbsh >> 13) & 0x3;
 
 	/* Bail early out if this was an 'observed' error */
 	if (PP(ec) == K8_NBSL_PP_OBS)
@@ -3163,7 +3163,7 @@ static int __init amd64_edac_init(void)
 	opstate_init();
 
 	if (cache_k8_northbridges() < 0)
-		goto err_exit;
+		return err;
 
 	err = pci_register_driver(&amd64_pci_driver);
 	if (err)
@@ -3189,8 +3189,6 @@ static int __init amd64_edac_init(void)
 
 err_2nd_stage:
 	debugf0("2nd stage failed\n");
-
-err_exit:
 	pci_unregister_driver(&amd64_pci_driver);
 
 	return err;

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


