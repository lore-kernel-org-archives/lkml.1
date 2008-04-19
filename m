Return-Path: <linux-kernel-owner+w=401wt.eu-S1759149AbYDSPGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbYDSPGm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 11:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758087AbYDSPGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 11:06:33 -0400
Received: from hs-out-0708.google.com ([64.233.178.241]:65212 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884AbYDSPGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 11:06:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=bizFaYuXu0ezHGE1+f5/0WgqbAd4sikoXEwpCZXh85P6XICx9ata9hHiXeuI5361YhkG6fFn3htoL0cdP3e+Wf9kZb25LqYa0DoWCD7vwrb4YKu5rakNsjtDAOEm363JnxnOUb4+jjYF5UPuW1jic66OqFpK8JwDehnPf1qHQyI=
References: <20080419145510.150338641@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 19 Apr 2008 23:55:11 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 01/10] x86: use BUILD_BUG_ON() for the size of struct intel_mp_floating
Content-Disposition: inline; filename=x86-use-build-bug-on.patch
Message-ID: <480a0a75.1498600a.314a.ffffd201@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use BUILD_BUG_ON() instead of compile-time error technique with
extern non-exsistent function.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/mpparse.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: 2.6-git/arch/x86/kernel/mpparse.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/mpparse.c
+++ 2.6-git/arch/x86/kernel/mpparse.c
@@ -686,13 +686,11 @@ void __init get_smp_config(void)
 static int __init smp_scan_config(unsigned long base, unsigned long length,
 				  unsigned reserve)
 {
-	extern void __bad_mpf_size(void);
 	unsigned int *bp = phys_to_virt(base);
 	struct intel_mp_floating *mpf;
 
 	Dprintk("Scan SMP from %p for %ld bytes.\n", bp, length);
-	if (sizeof(*mpf) != 16)
-		__bad_mpf_size();
+	BUILD_BUG_ON(sizeof(*mpf) != 16);
 
 	while (length > 0) {
 		mpf = (struct intel_mp_floating *)bp;

-- 
