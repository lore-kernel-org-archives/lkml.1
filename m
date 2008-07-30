Return-Path: <linux-kernel-owner+w=401wt.eu-S1762758AbYGaAMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762758AbYGaAMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYGaALt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:11:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762584AbYGaALr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:11:47 -0400
Date: Wed, 30 Jul 2008 16:58:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       Davide Libenzi <davidel@xmailserver.org>
Subject: [patch 22/62] Fix build on COMPAT platforms when CONFIG_EPOLL is
	disabled
Message-ID: <20080730235836.GV12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-build-on-compat-platforms-when-config_epoll-is-disabled.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

commit 5f17156fc55abac476d180e480bedb0f07f01b14 upstream

Add missing cond_syscall() entry for compat_sys_epoll_pwait.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sys_ni.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -59,6 +59,7 @@ cond_syscall(sys_epoll_create);
 cond_syscall(sys_epoll_ctl);
 cond_syscall(sys_epoll_wait);
 cond_syscall(sys_epoll_pwait);
+cond_syscall(compat_sys_epoll_pwait);
 cond_syscall(sys_semget);
 cond_syscall(sys_semop);
 cond_syscall(sys_semtimedop);

-- 
