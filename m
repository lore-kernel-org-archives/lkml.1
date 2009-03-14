Return-Path: <linux-kernel-owner+w=401wt.eu-S1764093AbZCNBjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764093AbZCNBjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbZCNBUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:55 -0400
Received: from kroah.org ([198.145.64.141]:35279 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753816AbZCNBUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:34 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:39 2009
Message-Id: <20090314011039.092516082@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:29 -0700
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
       alan@lxorguk.ukuu.org.uk, Wu Fengguang <fengguang.wu@intel.com>
Subject: [patch 052/114] proc: fix kflags to uflags copying in /proc/kpageflags
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=proc-fix-kflags-to-uflags-copying-in-proc-kpageflags.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wu Fengguang <fengguang.wu@intel.com>

commit ad3bdefe877afb47480418fdb05ecd42842de65e upstream.

Fix kpf_copy_bit(src,dst) to be kpf_copy_bit(dst,src) to match the
actual call patterns, e.g. kpf_copy_bit(kflags, KPF_LOCKED, PG_locked).

This misplacement of src/dst only affected reporting of PG_writeback,
PG_reclaim and PG_buddy. For others kflags==uflags so not affected.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/page.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -80,7 +80,7 @@ static const struct file_operations proc
 #define KPF_RECLAIM    9
 #define KPF_BUDDY     10
 
-#define kpf_copy_bit(flags, srcpos, dstpos) (((flags >> srcpos) & 1) << dstpos)
+#define kpf_copy_bit(flags, dstpos, srcpos) (((flags >> srcpos) & 1) << dstpos)
 
 static ssize_t kpageflags_read(struct file *file, char __user *buf,
 			     size_t count, loff_t *ppos)


