Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbZLDO3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbZLDO3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 09:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZLDO3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 09:29:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbZLDO3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 09:29:53 -0500
Date: Fri, 4 Dec 2009 15:29:01 +0100
From: Veaceslav Falico <vfalico@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Al Viro <viro@zeniv.linux.org.uk>, Miloslav Trmac <mitr@redhat.com>,
       James Morris <jmorris@namei.org>, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       David Howells <dhowells@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 2/4] copy_signal cleanup: clean acct_init_pacct() and
	taskstats_tgid_init()
Message-ID: <20091204142901.GI10052@darkmag.usersys.redhat.com>
References: <20091201221036.GA10052@darkmag.usersys.redhat.com> <20091202135759.GA791@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202135759.GA791@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unneeded initializations in acct_init_pacct() and taskstats_tgid_init().
These are accessed only via copy_signal() and are useless after using
kmem_cache_zalloc() in copy_signal().

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
---

diff --git a/include/linux/taskstats_kern.h b/include/linux/taskstats_kern.h
index 3398f45..d66167a 100644
--- a/include/linux/taskstats_kern.h
+++ b/include/linux/taskstats_kern.h
@@ -16,7 +16,6 @@ extern struct mutex taskstats_exit_mutex;
 
 static inline void taskstats_tgid_init(struct signal_struct *sig)
 {
-	sig->stats = NULL;
 }
 
 static inline void taskstats_tgid_free(struct signal_struct *sig)
diff --git a/kernel/acct.c b/kernel/acct.c
index 9a4715a..8909c26 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -592,8 +592,6 @@ out:
  */
 void acct_init_pacct(struct pacct_struct *pacct)
 {
-	memset(pacct, 0, sizeof(struct pacct_struct));
-	pacct->ac_utime = pacct->ac_stime = cputime_zero;
 }
 
 /**
