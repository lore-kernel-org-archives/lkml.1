Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbYJXEkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbYJXEkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYJXEjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:09 -0400
Received: from kroah.org ([198.145.64.141]:51660 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751449AbYJXEjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:05 -0400
Date: Thu, 23 Oct 2008 21:33:40 -0700
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
       alan@lxorguk.ukuu.org.uk, Miao Xie <miaox@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 04/27] sched: fix the wrong mask_len
Message-ID: <20081024043340.GE30828@kroah.com>
References: <20081024042023.054190751@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sched-fix-the-wrong-mask_len.patch"
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Miao Xie <miaox@cn.fujitsu.com>

commit c851c8676bd7ae456e9b3af8e6bb2c434eddcc75 upstream

If NR_CPUS isn't a multiple of 32, we get a truncated string of sched
domains by catting /proc/schedstat. This is caused by the wrong mask_len.

This patch fixes it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched_stats.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -9,7 +9,7 @@
 static int show_schedstat(struct seq_file *seq, void *v)
 {
 	int cpu;
-	int mask_len = NR_CPUS/32 * 9;
+	int mask_len = (NR_CPUS/32 + 1) * 9;
 	char *mask_str = kmalloc(mask_len, GFP_KERNEL);
 
 	if (mask_str == NULL)

-- 
