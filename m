Return-Path: <linux-kernel-owner+w=401wt.eu-S933559AbXCEVAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559AbXCEVAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933300AbXCEU6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:58:49 -0500
Received: from mbox.ssc.unict.it ([151.97.230.9]:46880 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933230AbXCEU6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:58:12 -0500
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH 07/11] uml: remove dead code about os_usr1_signal() and os_usr1_process()
Date: Mon, 05 Mar 2007 21:49:05 +0100
To: Andrew Morton <akpm@osdl.org>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Message-Id: <20070305204905.9072.7715.stgit@americanbeauty.home.lan>
In-Reply-To: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
References: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
Content-Type: text/plain; charset=utf-8; format=fixed
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by alpha.home.local id l25L2PZJ008310

From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

os_usr1_signal() is totally unused, os_usr1_process() is used only by TT mode.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
---

 arch/um/include/os.h       |    3 ++-
 arch/um/os-Linux/process.c |    3 +++
 arch/um/os-Linux/signal.c  |    5 -----
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/um/include/os.h b/arch/um/include/os.h
index 8629bd1..5c74da4 100644
--- a/arch/um/include/os.h
+++ b/arch/um/include/os.h
@@ -192,7 +192,9 @@ extern int os_process_parent(int pid);
 extern void os_stop_process(int pid);
 extern void os_kill_process(int pid, int reap_child);
 extern void os_kill_ptraced_process(int pid, int reap_child);
+#ifdef UML_CONFIG_MODE_TT
 extern void os_usr1_process(int pid);
+#endif
 extern long os_ptrace_ldt(long pid, long addr, long data);
 
 extern int os_getpid(void);
@@ -261,7 +263,6 @@ extern void block_signals(void);
 extern void unblock_signals(void);
 extern int get_signals(void);
 extern int set_signals(int enable);
-extern void os_usr1_signal(int on);
 
 /* trap.c */
 extern void os_fill_handlinfo(struct kern_handlers h);
diff --git a/arch/um/os-Linux/process.c b/arch/um/os-Linux/process.c
index c692a19..76bdd67 100644
--- a/arch/um/os-Linux/process.c
+++ b/arch/um/os-Linux/process.c
@@ -21,6 +21,7 @@
 #include "longjmp.h"
 #include "skas_ptrace.h"
 #include "kern_constants.h"
+#include "uml-config.h"
 
 #define ARBITRARY_ADDR -1
 #define FAILURE_PID    -1
@@ -131,10 +132,12 @@ void os_kill_ptraced_process(int pid, int reap_child)
 		CATCH_EINTR(waitpid(pid, NULL, 0));
 }
 
+#ifdef UML_CONFIG_MODE_TT
 void os_usr1_process(int pid)
 {
 	kill(pid, SIGUSR1);
 }
+#endif
 
 /* Don't use the glibc version, which caches the result in TLS. It misses some
  * syscalls, and also breaks with clone(), which does not unshare the TLS.
diff --git a/arch/um/os-Linux/signal.c b/arch/um/os-Linux/signal.c
index b897e85..2667686 100644
--- a/arch/um/os-Linux/signal.c
+++ b/arch/um/os-Linux/signal.c
@@ -243,8 +243,3 @@ int set_signals(int enable)
 
 	return ret;
 }
-
-void os_usr1_signal(int on)
-{
-	change_sig(SIGUSR1, on);
-}


