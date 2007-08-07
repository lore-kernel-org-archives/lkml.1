Return-Path: <linux-kernel-owner+w=401wt.eu-S1763028AbXHGVIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763028AbXHGVIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764104AbXHGUxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:53:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59444 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935674AbXHGUxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:53:12 -0400
Date: Tue, 7 Aug 2007 13:46:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, adobriyan@sw.ru, mingo@elte.hu
Subject: [2.6.22.2 review 41/84] Fix leaks on /proc/{*/sched, sched_debug,
	timer_list, timer_stats}
Message-ID: <20070807204640.GQ23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-leaks-on-proc-sched-sched_debug-timer_list-timer_stats.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Alexey Dobriyan <adobriyan@sw.ru>

On every open/close one struct seq_operations leaks.
Kudos to /proc/slab_allocators.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/timer_list.c  |    2 +-
 kernel/time/timer_stats.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -267,7 +267,7 @@ static struct file_operations timer_list
 	.open		= timer_list_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= single_release,
 };
 
 static int __init init_timer_list_procfs(void)
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -391,7 +391,7 @@ static struct file_operations tstats_fop
 	.read		= seq_read,
 	.write		= tstats_write,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= single_release,
 };
 
 void __init init_timer_stats(void)

-- 
