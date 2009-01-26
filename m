Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZAZU0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZAZU0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 15:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbZAZU0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 15:26:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37872 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbZAZU0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 15:26:18 -0500
Date: Mon, 26 Jan 2009 18:25:50 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 1/1] blktrace: the ftrace interface needs CONFIG_TRACING
Message-ID: <20090126202549.GC11038@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend, the first time I forgot to add [PATCH tip 1/1].

Ingo, this fix that problem you reported me, where a .config didn't had
CONFIG_TRACING selected.

Impact: Fix Kconfig selection for blktrace

Also mention in the help text that blktrace now can be used using
the ftrace interface.

Cc: Jens Axboe <jens.axboe@oracle.com>
Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/block/Kconfig b/block/Kconfig
index 0cbb3b8..7cdaa1d 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -50,6 +50,8 @@ config BLK_DEV_IO_TRACE
 	select RELAY
 	select DEBUG_FS
 	select TRACEPOINTS
+	select TRACING
+	select STACKTRACE
 	help
 	  Say Y here if you want to be able to trace the block layer actions
 	  on a given queue. Tracing allows you to see any traffic happening
@@ -58,6 +60,12 @@ config BLK_DEV_IO_TRACE
 
 	  git://git.kernel.dk/blktrace.git
 
+	  Tracing also is possible using the ftrace interface, e.g.:
+
+	    echo 1 > /sys/block/sda/sda1/trace/enable
+	    echo blk > /sys/kernel/debug/tracing/current_tracer
+	    cat /sys/kernel/debug/tracing/trace_pipe
+
 	  If unsure, say N.
 
 config BLK_DEV_BSG
