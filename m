Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbYGVXYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbYGVXYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbYGVXTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:19:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:57718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197AbYGVXTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:19:17 -0400
Date: Tue, 22 Jul 2008 16:16:06 -0700
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
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 20/47] mm: switch node meminfo Active & Inactive pages to
	Kbytes
Message-ID: <20080722231606.GU8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-switch-node-meminfo-active-inactive-pages-to-kbytes.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: John Blackwood <john.blackwood@ccur.com>

commit 2d5c1be8870383622809c25935fff00d2630c7a5 upstream

There is a bug in the output of /sys/devices/system/node/node[n]/meminfo
where the Active and Inactive values are in pages instead of Kbytes.

Looks like this occurred back in 2.6.20 when the code was changed
over to use node_page_state().

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/node.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -70,8 +70,8 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(i.totalram),
 		       nid, K(i.freeram),
 		       nid, K(i.totalram - i.freeram),
-		       nid, node_page_state(nid, NR_ACTIVE),
-		       nid, node_page_state(nid, NR_INACTIVE),
+		       nid, K(node_page_state(nid, NR_ACTIVE)),
+		       nid, K(node_page_state(nid, NR_INACTIVE)),
 #ifdef CONFIG_HIGHMEM
 		       nid, K(i.totalhigh),
 		       nid, K(i.freehigh),

-- 
