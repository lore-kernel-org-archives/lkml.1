Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbYGOG3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbYGOG3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 02:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbYGOG3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 02:29:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:41205 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbYGOG3l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 02:29:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Z2p86/aKKlABAEBl/gJnz7h2sUUnrB+PBp9+2hQKQ4H0GrbZ/gW2RYnCqPjftRo+qI
         zARP7YfTiIcrPUvFtlLOKRKE+50lNLTX5ry0A8WLwfcgd/GGWMVmnybBrX6k5/nz48m6
         9qAl0qIV91CKbeWmNkzIx0H6cno0gHJOdGLTk=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: fix numaq_tsc_disable
Date: Mon, 14 Jul 2008 23:29:01 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807142329.02273.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix

arch/x86/kernel/numaq_32.c: In function ‘numaq_tsc_disable’:
arch/x86/kernel/numaq_32.c:99: warning: ‘return’ with a value, in function returning void

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/numaq_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/numaq_32.c
+++ linux-2.6/arch/x86/kernel/numaq_32.c
@@ -96,7 +96,7 @@ int __init get_memcfg_numaq(void)
 void __init numaq_tsc_disable(void)
 {
 	if (!found_numaq)
-		return -1;
+		return;
 
 	if (num_online_nodes() > 1) {
 		printk(KERN_DEBUG "NUMAQ: disabling TSC\n");
