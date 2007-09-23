Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbXIWURa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbXIWURa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 16:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbXIWURU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 16:17:20 -0400
Received: from mail0.scram.de ([78.47.204.202]:41495 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbXIWURT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 16:17:19 -0400
X-Spam-Score: -4.219
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <46F6C9C9.5060600@scram.de>
Date: Sun, 23 Sep 2007 22:17:13 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: linuxppc-embedded@ozlabs.org
CC: linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>
Subject: [PATCH1/4] [POWERPC] Fix copy'n'paste typo in commproc.c
Content-Type: multipart/mixed;
 boundary="------------020406050103040109000402"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020406050103040109000402
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


The powerpc version of commproc.c doesn't export cpm_dpram_addr twice
and cpm_dpram_phys not at all due to a typo. This patch fixes this
problem.

CC      arch/powerpc/sysdev/commproc.o
arch/powerpc/sysdev/commproc.c:398: error: redefinition of '__kcrctab_cpm_dpram_addr'
arch/powerpc/sysdev/commproc.c:392: error: previous definition of '__kcrctab_cpm_dpram_addr' was here
arch/powerpc/sysdev/commproc.c:398: error: redefinition of '__kstrtab_cpm_dpram_addr'
arch/powerpc/sysdev/commproc.c:392: error: previous definition of '__kstrtab_cpm_dpram_addr' was here
arch/powerpc/sysdev/commproc.c:398: error: redefinition of '__ksymtab_cpm_dpram_addr'
arch/powerpc/sysdev/commproc.c:392: error: previous definition of '__ksymtab_cpm_dpram_addr' was here
make[1]: *** [arch/powerpc/sysdev/commproc.o] Error 1
make: *** [arch/powerpc/sysdev] Error 2

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 arch/powerpc/sysdev/commproc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

--------------020406050103040109000402
Content-Type: text/x-patch;
 name="828fc894599eb4bb5a015277687adbb75bb94cc0.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="828fc894599eb4bb5a015277687adbb75bb94cc0.diff"

diff --git a/arch/powerpc/sysdev/commproc.c b/arch/powerpc/sysdev/commproc.c
index 4f67b89..dd5417a 100644
--- a/arch/powerpc/sysdev/commproc.c
+++ b/arch/powerpc/sysdev/commproc.c
@@ -395,4 +395,4 @@ uint cpm_dpram_phys(u8* addr)
 {
 	return (dpram_pbase + (uint)(addr - dpram_vbase));
 }
-EXPORT_SYMBOL(cpm_dpram_addr);
+EXPORT_SYMBOL(cpm_dpram_phys);


--------------020406050103040109000402--
