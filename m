Return-Path: <linux-kernel-owner+w=401wt.eu-S1759842AbXG2Ctk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842AbXG2Ctk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 22:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756116AbXG2Cta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 22:49:30 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:16469 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759588AbXG2CtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 22:49:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent:from:sender;
        b=hCEhN/gRvBxpMFb2Gi9rBtnE7w4Gx0/bq2XYUL2xGTNXPwCFsMRg0zWARWxc3wN4VEuG66K5afBIDOkhgASqP0j6mphbld5ig0OMgOdYepYVoRvD/zPBQ7QraBsi937i04lQ953sWYvbJnSMwYGUL/0cu59ZdEJT9flfmFiygDM=
Date: Sun, 29 Jul 2007 10:49:18 +0800
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] arch/i386/kernel/apm.c: apm_init() warning fix
Message-ID: <20070729024918.GA19311@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
From: Eugene Teo <eugeneteo@kernel.sg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

arch/i386/kernel/apm.c: In function 'apm_init':
arch/i386/kernel/apm.c:2240: warning: format '%lx' expects type 'long
	unsigned int', but argument 3 has type 'u32'

apm_info.bios.offset is of type 'u32'.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 arch/i386/kernel/apm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/i386/kernel/apm.c b/arch/i386/kernel/apm.c
index 47001d5..f02a8ac 100644
--- a/arch/i386/kernel/apm.c
+++ b/arch/i386/kernel/apm.c
@@ -2235,7 +2235,7 @@ static int __init apm_init(void)
 		apm_info.bios.cseg_16_len = 0; /* 64k */
 
 	if (debug) {
-		printk(KERN_INFO "apm: entry %x:%lx cseg16 %x dseg %x",
+		printk(KERN_INFO "apm: entry %x:%x cseg16 %x dseg %x",
 			apm_info.bios.cseg, apm_info.bios.offset,
 			apm_info.bios.cseg_16, apm_info.bios.dseg);
 		if (apm_info.bios.version > 0x100)

