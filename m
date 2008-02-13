Return-Path: <linux-kernel-owner+w=401wt.eu-S1763503AbYBMVrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763503AbYBMVrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764263AbYBMVbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:31:17 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47547 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759621AbYBMVbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:31:12 -0500
Date: Wed, 13 Feb 2008 23:30:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: paulus@samba.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [2.6 patch] powerpc: free_property() mustn't be __init
Message-ID: <20080213213055.GP3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch:

<--  snip  -->

...
WARNING: vmlinux.o(.text+0x55648): Section mismatch in reference from the function .free_node() to the function .init.text:.free_property()
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

---

This patch has been sent on:
- 30 Jan 2008

99e9b48d8f5aba059916540fc69815db2b60b08d 
diff --git a/arch/powerpc/platforms/iseries/vio.c b/arch/powerpc/platforms/iseries/vio.c
index be06cfd..657b72f 100644
--- a/arch/powerpc/platforms/iseries/vio.c
+++ b/arch/powerpc/platforms/iseries/vio.c
@@ -75,7 +75,7 @@ static struct property *new_property(const char *name, int length,
 	return np;
 }
 
-static void __init free_property(struct property *np)
+static void free_property(struct property *np)
 {
 	kfree(np);
 }

