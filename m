Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbYIIG7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbYIIG7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 02:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbYIIG7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 02:59:44 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:12025 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbYIIG7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 02:59:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=tpsYOX/EBYMcseQMZY+/+aDMxczRPVWVpHZykI7Ypsjffub9YnXa5mM9nDDXtZUn1a
         CHWX78jkyA4J2YJHAFujoftuUa4Tf/XNzVjJEApxpqn5DRuDnqbdAPIb3uxyl61I+czE
         4YCvDA9gQ6s3UOn98H15QkUkROoQd9uzQEvkY=
Date: Tue, 9 Sep 2008 11:01:31 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, andrea@cpushare.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] seccomp: drop now bogus dependency on PROC_FS
Message-ID: <20080909070131.GB5743@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seccomp is prctl(2)-driven now.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/x86/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1191,7 +1191,6 @@ config IRQBALANCE
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
-	depends on PROC_FS
 	help
 	  This kernel feature is useful for number crunching applications
 	  that may need to compute untrusted bytecode during their
@@ -1199,7 +1198,7 @@ config SECCOMP
 	  the process as file descriptors supporting the read/write
 	  syscalls, it's possible to isolate those applications in
 	  their own address space using seccomp. Once seccomp is
-	  enabled via /proc/<pid>/seccomp, it cannot be disabled
+	  enabled via prctl(PR_SET_SECCOMP), it cannot be disabled
 	  and the task is only allowed to execute a few safe syscalls
 	  defined by each seccomp mode.
 
