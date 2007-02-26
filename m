Return-Path: <linux-kernel-owner+w=401wt.eu-S932760AbXBZVxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbXBZVxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932620AbXBZVxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:53:42 -0500
Received: from mail.screens.ru ([213.234.233.54]:35322 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932760AbXBZVxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:53:41 -0500
Date: Tue, 27 Feb 2007 00:53:30 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: [PATCH] ____call_usermodehelper: don't flush_signals()
Message-ID: <20070226215330.GA403@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

____call_usermodehelper() has no reason for flush_signals(). It is a fresh
forked process which is going to exec a user-space application or exit on
failure.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- WQ/kernel/kmod.c~	2007-02-18 22:56:49.000000000 +0300
+++ WQ/kernel/kmod.c	2007-02-27 00:05:08.000000000 +0300
@@ -256,7 +256,6 @@ static int ____call_usermodehelper(void 
 
 	/* Unblock all signals and set the session keyring. */
 	new_session = key_get(sub_info->ring);
-	flush_signals(current);
 	spin_lock_irq(&current->sighand->siglock);
 	old_session = __install_session_keyring(current, new_session);
 	flush_signal_handlers(current, 1);

