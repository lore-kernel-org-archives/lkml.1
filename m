Return-Path: <linux-kernel-owner+w=401wt.eu-S1761428AbZCNAic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761428AbZCNAic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbZCNATa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:30 -0400
Received: from kroah.org ([198.145.64.141]:34778 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753363AbZCNATR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:17 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:47 2009
Message-Id: <20090314000747.629293662@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:05 -0700
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
       alan@lxorguk.ukuu.org.uk, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [patch 57/96] proc: fix PG_locked reporting in /proc/kpageflags
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=proc-fix-pg_locked-reporting-in-proc-kpageflags.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Helge Bahmann <helge.bahmann@secunet.com>

commit e07a4b9217d1e97d2f3a62b6b070efdc61212110 upstream.

Expr always evaluates to zero.

Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/proc_misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -824,7 +824,7 @@ static ssize_t kpageflags_read(struct fi
 		else
 			kflags = ppage->flags;
 
-		uflags = kpf_copy_bit(KPF_LOCKED, PG_locked, kflags) |
+		uflags = kpf_copy_bit(kflags, KPF_LOCKED, PG_locked) |
 			kpf_copy_bit(kflags, KPF_ERROR, PG_error) |
 			kpf_copy_bit(kflags, KPF_REFERENCED, PG_referenced) |
 			kpf_copy_bit(kflags, KPF_UPTODATE, PG_uptodate) |


