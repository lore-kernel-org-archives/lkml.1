Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbZLAWPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbZLAWPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 17:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZLAWPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 17:15:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506AbZLAWO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 17:14:59 -0500
Date: Tue, 1 Dec 2009 23:13:46 +0100
From: Veaceslav Falico <vfalico@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Miloslav Trmac <mitr@redhat.com>, James Morris <jmorris@namei.org>,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 4/4] copy_signal cleanup: clean tty_audit_fork()
Message-ID: <20091201221346.GD10052@darkmag.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unneeded initialization in tty_audit_fork().

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
