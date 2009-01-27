Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbZA0FiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbZA0FiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 00:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZA0FiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 00:38:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49199 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZA0FiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 00:38:07 -0500
Date: Tue, 27 Jan 2009 00:38:03 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip] x86: ftrace - simplify wait_for_nmi
In-Reply-To: <alpine.DEB.1.10.0901261041430.9334@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0901270037310.6995@gandalf.stny.rr.com>
References: <20090126152802.GA12465@localhost> <alpine.DEB.1.10.0901261041430.9334@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Cyrill Gorcunov (1):
      x86: ftrace - simplify wait_for_nmi

----
 arch/x86/kernel/ftrace.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)
---------------------------
commit e4733771167c00aa8bf8791307ca47f1c0420f55
Author: Cyrill Gorcunov <gorcunov@gmail.com>
Date:   Mon Jan 26 18:28:02 2009 +0300

    x86: ftrace - simplify wait_for_nmi
    
    Get rid of 'waited' stack variable.
    
    Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 1b43086..4d33224 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -133,15 +133,14 @@ void ftrace_nmi_exit(void)
 
 static void wait_for_nmi(void)
 {
-	int waited = 0;
+	if (!atomic_read(&in_nmi))
+		return;
 
-	while (atomic_read(&in_nmi)) {
-		waited = 1;
+	do {
 		cpu_relax();
-	}
+	} while(atomic_read(&in_nmi));
 
-	if (waited)
-		nmi_wait_count++;
+	nmi_wait_count++;
 }
 
 static int


