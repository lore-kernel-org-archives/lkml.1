Return-Path: <linux-kernel-owner+w=401wt.eu-S934474AbZAOU4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934474AbZAOU4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932368AbZAOUDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:03:22 -0500
Received: from kroah.org ([198.145.64.141]:49884 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932184AbZAOUDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:03:10 -0500
Date: Thu, 15 Jan 2009 12:00:46 -0800
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
       alan@lxorguk.ukuu.org.uk,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 92/94] getrusage: RUSAGE_THREAD should return ru_utime and
	ru_stime
Message-ID: <20090115200046.GN14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="getrusage-rusage_thread-should-return-ru_utime-and-ru_stime.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 8916edef5888c5d8fe283714416a9ca95b4c3431 upstream.

Impact: task stats regression fix

Original getrusage(RUSAGE_THREAD) implementation can return ru_utime and
ru_stime. But commit "f06febc: timers: fix itimer/many thread hang" broke it.

this patch restores it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sys.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1553,6 +1553,8 @@ static void k_getrusage(struct task_stru
 	utime = stime = cputime_zero;
 
 	if (who == RUSAGE_THREAD) {
+		utime = task_utime(current);
+		stime = task_stime(current);
 		accumulate_thread_rusage(p, r);
 		goto out;
 	}

