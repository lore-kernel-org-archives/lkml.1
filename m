Return-Path: <linux-kernel-owner+w=401wt.eu-S965954AbXIBMYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965954AbXIBMYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 08:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbXIBMX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 08:23:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53602 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbXIBMX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 08:23:58 -0400
Date: Sun, 2 Sep 2007 18:07:06 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -mm][resend] softlockup-improve-debug-output.patch fix
In-Reply-To: <alpine.LFD.0.999.0709020439290.20781@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0709021803060.24993@enigma.security.iitk.ac.in>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
 <alpine.LFD.0.999.0709020439290.20781@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 2 Sep 2007, Satyam Sharma wrote:
> 
> --- kernel/softlockup.c~fix	2007-09-02 04:23:49.000000000 +0530
> +++ kernel/softlockup.c	2007-09-02 04:34:45.000000000 +0530
  ^^^^^^^^^^

Ick, I botched a trivial patch, it doesn't even apply. Updated one below
(with indentation fix as added bonus :-)


[PATCH -mm] softlockup-improve-debug-output.patch fix (v2)

kernel/softlockup.c: In function 'softlockup_tick':
kernel/softlockup.c:125: warning: 'regs' is used uninitialized in this function

is a genuine bug (will cause an oops in all probability,
or cause wrong info to be printed, if we're lucky). So let's fix the
softlockup-improve-debug-output.patch to actually work as intended.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 kernel/softlockup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.23-rc4-mm1/kernel/softlockup.c~fix	2007-09-02 17:58:23.000000000 +0530
+++ linux-2.6.23-rc4-mm1/kernel/softlockup.c	2007-09-02 17:58:48.000000000 +0530
@@ -80,7 +80,7 @@ void softlockup_tick(void)
 	int this_cpu = smp_processor_id();
 	unsigned long touch_timestamp = per_cpu(touch_timestamp, this_cpu);
 	unsigned long print_timestamp;
-	struct pt_regs *regs;
+	struct pt_regs *regs = get_irq_regs();
 	unsigned long now;
 
 	if (touch_timestamp == 0) {
@@ -121,7 +121,7 @@ void softlockup_tick(void)
 	spin_lock(&print_lock);
 	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
 			this_cpu, now - touch_timestamp,
-				current->comm, task_pid_nr(current));
+			current->comm, task_pid_nr(current));
 	if (regs)
 		show_regs(regs);
 	else
