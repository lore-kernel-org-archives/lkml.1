Return-Path: <linux-kernel-owner+w=401wt.eu-S1751185AbZCHHYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185AbZCHHYh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 03:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbZCHHY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 03:24:28 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:36602 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZCHHY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 03:24:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=fvpg9qM9KcwWyG7NJRlEDODA9LkGF9WAVnDvowjYF7F3RfkLGnRUMmjjnmPBe861bA
         EjpcPNXz2qPA1vkGTs5ydmuSPCpQu1XNFuMq0t+ntDdOoNsICtZ5R/bPj0bGAMJ+ljox
         M0eJuDbjeCh1ybmpARz2gzsTHAAAMMdsgGmww=
Date: Sun, 8 Mar 2009 15:24:43 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [trivial Patch] uml: improve error messages
Message-ID: <20090308072443.GB30016@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These error messages are from check_sysemu(), not check_ptrace().

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>

---
diff --git a/arch/um/os-Linux/start_up.c b/arch/um/os-Linux/start_up.c
index 183db26..02ee9ad 100644
--- a/arch/um/os-Linux/start_up.c
+++ b/arch/um/os-Linux/start_up.c
@@ -244,7 +244,7 @@ static void __init check_sysemu(void)
 
 	if ((ptrace(PTRACE_OLDSETOPTIONS, pid, 0,
 		   (void *) PTRACE_O_TRACESYSGOOD) < 0))
-		fatal_perror("check_ptrace: PTRACE_OLDSETOPTIONS failed");
+		fatal_perror("check_sysemu: PTRACE_OLDSETOPTIONS failed");
 
 	while (1) {
 		count++;
@@ -252,12 +252,12 @@ static void __init check_sysemu(void)
 			goto fail;
 		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
 		if (n < 0)
-			fatal_perror("check_ptrace : wait failed");
+			fatal_perror("check_sysemu: wait failed");
 
 		if (WIFSTOPPED(status) &&
 		    (WSTOPSIG(status) == (SIGTRAP|0x80))) {
 			if (!count) {
-				non_fatal("check_ptrace : SYSEMU_SINGLESTEP "
+				non_fatal("check_sysemu: SYSEMU_SINGLESTEP "
 					  "doesn't singlestep");
 				goto fail;
 			}
@@ -271,7 +271,7 @@ static void __init check_sysemu(void)
 		else if (WIFSTOPPED(status) && (WSTOPSIG(status) == SIGTRAP))
 			count++;
 		else {
-			non_fatal("check_ptrace : expected SIGTRAP or "
+			non_fatal("check_sysemu: expected SIGTRAP or "
 				  "(SIGTRAP | 0x80), got status = %d\n",
 				  status);
 			goto fail;

 
