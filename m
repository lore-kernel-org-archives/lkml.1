Return-Path: <linux-kernel-owner+w=401wt.eu-S1764066AbYEEWpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764066AbYEEWpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763553AbYEEWlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:41:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:51587 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763543AbYEEWlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:41:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=lKunV2auVc06t28f9N37jBJS4Sju74VBeLCBUtTpvN2EAzd1ByMMbhnRlmlGRgJOyxUyaOXypszTtIhI+nV3xbWwQHzps5NMtc0HaNTNKOmUt0MvLkGYB8lZpUys5VE+Xdjqh64xhjsVP5WnCvrQlku9vbqE8lq8005cTHIt4ME=
Date: Tue, 6 May 2008 00:41:48 +0200 (CEST)
To: linux-kernel@vger.kernel.org
cc: mingo@elte.hu, gcosta@redhat.com, jesper.juhl@gmail.com
Subject: [PATCH] Use correct format when printing long unsigned int in
 arch/x86/kernel/setup.c
Message-ID: <alpine.LNX.1.00.0805060039100.27779@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>


Use correct format when printing long unsigned int in arch/x86/kernel/setup.c

This patch gets rid of this compiler warning:
  arch/x86/kernel/setup.c: In function 'setup_per_cpu_areas':
  arch/x86/kernel/setup.c:99: warning: format '%zd' expects type 'signed size_t', but argument 2 has type 'long unsigned int'


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index cc6f5eb..c0c68c1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -95,7 +95,7 @@ void __init setup_per_cpu_areas(void)
 
 	/* Copy section for each CPU (we discard the original) */
 	size = PERCPU_ENOUGH_ROOM;
-	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
+	printk(KERN_INFO "PERCPU: Allocating %lu bytes of per cpu data\n",
 			  size);
 
 	for_each_possible_cpu(i) {


