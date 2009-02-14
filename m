Return-Path: <linux-kernel-owner+w=401wt.eu-S932414AbZBNBYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbZBNBYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762644AbZBNBIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:08:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40918 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762874AbZBNBIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:08:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 8/9] PM: Wait for console in resume
Date: Sat, 14 Feb 2009 02:06:17 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>
References: <200902140157.40869.rjw@sisk.pl>
In-Reply-To: <200902140157.40869.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902140206.18505.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

Avoids later waking up to a blinking cursor if the device woke up and
returned to sleep before the console switch happened.

Signed-off-by: Brian Swetland <swetland@google.com>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

 kernel/power/console.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/kernel/power/console.c
===================================================================
--- linux-2.6.orig/kernel/power/console.c
+++ linux-2.6/kernel/power/console.c
@@ -78,6 +78,12 @@ void pm_restore_console(void)
 	}
 	set_console(orig_fgconsole);
 	release_console_sem();
+
+	if (vt_waitactive(orig_fgconsole)) {
+		pr_debug("Resume: Can't switch VCs.");
+		return;
+	}
+
 	kmsg_redirect = orig_kmsg;
 }
 #endif
