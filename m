Return-Path: <linux-kernel-owner+w=401wt.eu-S1757690AbZGHEaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690AbZGHEaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbZGHEaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:30:09 -0400
Received: from smtp.outflux.net ([198.145.64.163]:51753 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbZGHEaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:30:08 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jul 2009 00:30:08 EDT
Date: Tue, 7 Jul 2009 21:23:32 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] proc: fix reported unit for RLIMIT_CPU
Message-ID: <20090708042331.GT11156@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/$pid/limits should show RLIMIT_CPU as seconds, which is the unit
used in kernel/posix-cpu-timers.c:

        unsigned long psecs = cputime_to_secs(ptime);
        ...
        if (psecs >= sig->rlim[RLIMIT_CPU].rlim_max) {
                ...
                __group_send_sig_info(SIGKILL, SEND_SIG_PRIV, tsk);

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 fs/proc/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 3ce5ae9..5891360 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -461,7 +461,7 @@ struct limit_names {
 };
 
 static const struct limit_names lnames[RLIM_NLIMITS] = {
-	[RLIMIT_CPU] = {"Max cpu time", "ms"},
+	[RLIMIT_CPU] = {"Max cpu time", "seconds"},
 	[RLIMIT_FSIZE] = {"Max file size", "bytes"},
 	[RLIMIT_DATA] = {"Max data size", "bytes"},
 	[RLIMIT_STACK] = {"Max stack size", "bytes"},
-- 
1.6.3.3

-- 
Kees Cook
Ubuntu Security Team
