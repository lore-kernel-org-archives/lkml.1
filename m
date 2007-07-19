Return-Path: <linux-kernel-owner+w=401wt.eu-S932549AbXGSVuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549AbXGSVuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757677AbXGSVtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:49:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43504 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756482AbXGSVtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:49:51 -0400
Date: Thu, 19 Jul 2007 14:48:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] Add kernel/notifier.c
Message-Id: <20070719144859.efccbcc3.akpm@linux-foundation.org>
In-Reply-To: <20070719164611.GB31240@localhost.sw.ru>
References: <20070719164611.GB31240@localhost.sw.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 20:46:11 +0400
Alexey Dobriyan <adobriyan@sw.ru> wrote:

> There is separate notifier header, but no separate notifier .c file.
> 
> Extract notifier code out of kernel/sys.c which will remain for
> misc syscalls I hope. Merge kernel/die_notifier.c into kernel/notifier.c.

If you were running checkpatch (I hope you are) then you'd find that we
copied over a whole pile of cruft.  We might as well fix that up while
we're moving the code around.

Also, your patch tried to add some trailing whitespace, but checkpatch
failed to notice that.

(The code motion and the cleanups should really be separate patches, and
indeed they are, but I'll end up joining them before it hits git)

diff -puN kernel/notifier.c~add-kernel-notifierc-fix kernel/notifier.c
--- a/kernel/notifier.c~add-kernel-notifierc-fix
+++ a/kernel/notifier.c
@@ -107,7 +107,6 @@ int atomic_notifier_chain_register(struc
 	spin_unlock_irqrestore(&nh->lock, flags);
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(atomic_notifier_chain_register);
 
 /**
@@ -131,7 +130,6 @@ int atomic_notifier_chain_unregister(str
 	synchronize_rcu();
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(atomic_notifier_chain_unregister);
 
 /**
@@ -165,7 +163,6 @@ int __kprobes __atomic_notifier_call_cha
 	rcu_read_unlock();
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(__atomic_notifier_call_chain);
 
 int __kprobes atomic_notifier_call_chain(struct atomic_notifier_head *nh,
@@ -173,8 +170,8 @@ int __kprobes atomic_notifier_call_chain
 {
 	return __atomic_notifier_call_chain(nh, val, v, -1, NULL);
 }
-
 EXPORT_SYMBOL_GPL(atomic_notifier_call_chain);
+
 /*
  *	Blocking notifier chain routines.  All access to the chain is
  *	synchronized by an rwsem.
@@ -209,7 +206,6 @@ int blocking_notifier_chain_register(str
 	up_write(&nh->rwsem);
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(blocking_notifier_chain_register);
 
 /**
@@ -240,7 +236,6 @@ int blocking_notifier_chain_unregister(s
 	up_write(&nh->rwsem);
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(blocking_notifier_chain_unregister);
 
 /**
@@ -311,7 +306,6 @@ int raw_notifier_chain_register(struct r
 {
 	return notifier_chain_register(&nh->head, n);
 }
-
 EXPORT_SYMBOL_GPL(raw_notifier_chain_register);
 
 /**
@@ -329,7 +323,6 @@ int raw_notifier_chain_unregister(struct
 {
 	return notifier_chain_unregister(&nh->head, n);
 }
-
 EXPORT_SYMBOL_GPL(raw_notifier_chain_unregister);
 
 /**
@@ -358,7 +351,6 @@ int __raw_notifier_call_chain(struct raw
 {
 	return notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls);
 }
-
 EXPORT_SYMBOL_GPL(__raw_notifier_call_chain);
 
 int raw_notifier_call_chain(struct raw_notifier_head *nh,
@@ -366,7 +358,6 @@ int raw_notifier_call_chain(struct raw_n
 {
 	return __raw_notifier_call_chain(nh, val, v, -1, NULL);
 }
-
 EXPORT_SYMBOL_GPL(raw_notifier_call_chain);
 
 /*
@@ -403,7 +394,6 @@ int srcu_notifier_chain_register(struct 
 	mutex_unlock(&nh->mutex);
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(srcu_notifier_chain_register);
 
 /**
@@ -435,7 +425,6 @@ int srcu_notifier_chain_unregister(struc
 	synchronize_srcu(&nh->srcu);
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(srcu_notifier_chain_unregister);
 
 /**
@@ -498,7 +487,6 @@ void srcu_init_notifier_head(struct srcu
 		BUG();
 	nh->head = NULL;
 }
-
 EXPORT_SYMBOL_GPL(srcu_init_notifier_head);
 
 /**
@@ -512,11 +500,10 @@ EXPORT_SYMBOL_GPL(srcu_init_notifier_hea
  *	always returns zero.
  */
 
-int register_reboot_notifier(struct notifier_block * nb)
+int register_reboot_notifier(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_register(&reboot_notifier_list, nb);
 }
-
 EXPORT_SYMBOL(register_reboot_notifier);
 
 /**
@@ -529,15 +516,13 @@ EXPORT_SYMBOL(register_reboot_notifier);
  *	Returns zero on success, or %-ENOENT on failure.
  */
 
-int unregister_reboot_notifier(struct notifier_block * nb)
+int unregister_reboot_notifier(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_unregister(&reboot_notifier_list, nb);
 }
-
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
 
-
 static ATOMIC_NOTIFIER_HEAD(die_chain);
 
 int notify_die(enum die_val val, const char *str,

