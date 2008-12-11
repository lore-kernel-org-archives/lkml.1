Return-Path: <linux-kernel-owner+w=401wt.eu-S1761442AbYLKTna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442AbYLKTna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbYLKTTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:24 -0500
Received: from kroah.org ([198.145.64.141]:56699 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757408AbYLKTTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:21 -0500
Date: Thu, 11 Dec 2008 11:16:24 -0800
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
       alan@lxorguk.ukuu.org.uk, Gary Hade <garyhade@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jeff Mahoney <jeffm@suse.com>
Subject: [patch 70/83] x86: remove debug code from arch_add_memory()
Message-ID: <20081211191624.GR5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-remove-debug-code-from-arch_add_memory.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Gary Hade <garyhade@us.ibm.com>

commit fe8b868eccb9f85a0e231e35f0abac5b39bac801 upstream.

Impact: remove incorrect WARN_ON(1)

Gets rid of dmesg spam created during physical memory hot-add which
will very likely confuse users.  The change removes what appears to
be debugging code which I assume was unintentionally included in:

  x86: arch/x86/mm/init_64.c printk fixes
  commit 10f22dde556d1ed41d55355d1fb8ad495f9810c8

Signed-off-by: Gary Hade <garyhade@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/init_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -726,7 +726,7 @@ int arch_add_memory(int nid, u64 start, 
 		max_pfn_mapped = last_mapped_pfn;
 
 	ret = __add_pages(zone, start_pfn, nr_pages);
-	WARN_ON(1);
+	WARN_ON_ONCE(ret);
 
 	return ret;
 }

