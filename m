Return-Path: <linux-kernel-owner+w=401wt.eu-S933051AbZAOUYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbZAOUYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762596AbZAOUBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:01:16 -0500
Received: from kroah.org ([198.145.64.141]:49174 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765956AbZAOUA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:58 -0500
Date: Thu, 15 Jan 2009 11:58:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Kyle McMartin <kyle@redhat.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 37/94] [PATCH 06/44] [CVE-2009-0029] Make sys_syslog a
	conditional system call
Message-ID: <20090115195837.GK14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0006--CVE-2009-0029-Make-sys_syslog-a-conditional-system.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit f627a741d24f12955fa2d9f8831c3b12860635bd upstream.

Remove the -ENOSYS implementation for !CONFIG_PRINTK and use
the cond_syscall infrastructure instead.

Acked-by: Kyle McMartin <kyle@redhat.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/printk.c |    5 -----
 kernel/sys_ni.c |    1 +
 2 files changed, 1 insertion(+), 5 deletions(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -742,11 +742,6 @@ EXPORT_SYMBOL(vprintk);
 
 #else
 
-asmlinkage long sys_syslog(int type, char __user *buf, int len)
-{
-	return -ENOSYS;
-}
-
 static void call_console_drivers(unsigned start, unsigned end)
 {
 }
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -131,6 +131,7 @@ cond_syscall(sys_io_destroy);
 cond_syscall(sys_io_submit);
 cond_syscall(sys_io_cancel);
 cond_syscall(sys_io_getevents);
+cond_syscall(sys_syslog);
 
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);

