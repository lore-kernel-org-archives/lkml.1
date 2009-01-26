Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbZAZSBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbZAZSBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 13:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbZAZSBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 13:01:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33638 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbZAZSBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 13:01:03 -0500
Date: Mon, 26 Jan 2009 16:00:40 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: blktrace: the ftrace interface needs CONFIG_TRACING
Message-ID: <20090126180040.GA11038@ghostprotocols.net>
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
