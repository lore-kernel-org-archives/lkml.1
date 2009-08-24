Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZHXRzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZHXRzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 13:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbZHXRzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 13:55:55 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:33817 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbZHXRzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 13:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=pcr1NPM0qr688ihigwzhUaXVbaF4GrzIPfwiRU4Y8YiQA5/4LNigyHSdEqfWxmQFyd
         Eec81OWvFOALibPE6kpw05tH5AgUeGsEj2aW0PrQ0tZxrL/PETn73ctKCXWI2Poj74XC
         2+PIO9yTvfZ5pdTLH4vsrmDp3yosJGfXbgJ48=
Message-Id: <20090824175551.146070377@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 24 Aug 2009 21:53:37 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc -tip 2/4] x86,e820: __e820_add_region -- guard against array overflowed
References: <20090824175335.186713800@openvz.org>
Content-Disposition: inline; filename=x86-e820-array
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better to be paranoid against unpredicted nr_map modifications.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/e820.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/e820.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/e820.c
+++ linux-2.6.git/arch/x86/kernel/e820.c
@@ -115,7 +115,7 @@ static void __init __e820_add_region(str
 {
 	int x = e820x->nr_map;
 
-	if (x == ARRAY_SIZE(e820x->map)) {
+	if (x >= ARRAY_SIZE(e820x->map)) {
 		printk(KERN_ERR "Ooops! Too many entries in the memory map!\n");
 		return;
 	}

