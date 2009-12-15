Return-Path: <linux-kernel-owner+w=401wt.eu-S1759718AbZLOKVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718AbZLOKVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759710AbZLOKVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:21:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759707AbZLOKVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 05:21:08 -0500
Date: Tue, 15 Dec 2009 11:20:17 +0100
From: Veaceslav Falico <vfalico@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Miloslav Trmac <mitr@redhat.com>, James Morris <jmorris@namei.org>,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       David Howells <dhowells@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v3 4/4 -mmotm] copy_signal() cleanup: clean tty_audit_fork()
Message-ID: <20091215102017.GE9134@darkmag.usersys.redhat.com>
References: <20091201221036.GA10052@darkmag.usersys.redhat.com> <20091202135759.GA791@redhat.com> <20091204142814.GH10052@darkmag.usersys.redhat.com> <20091207123615.fc841a83.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207123615.fc841a83.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unneeded initialization in tty_audit_fork().
It is called only via copy_signal() and is useless after
the kmem_cache_zalloc() was used.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
---
diff --git a/drivers/char/tty_audit.c b/drivers/char/tty_audit.c
index ac16fbe..283a15b 100644
--- a/drivers/char/tty_audit.c
+++ b/drivers/char/tty_audit.c
@@ -148,7 +148,6 @@ void tty_audit_fork(struct signal_struct *sig)
 	spin_lock_irq(&current->sighand->siglock);
 	sig->audit_tty = current->signal->audit_tty;
 	spin_unlock_irq(&current->sighand->siglock);
-	sig->tty_audit_buf = NULL;
 }
 
 /**
