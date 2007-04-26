Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbXDZRA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbXDZRA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbXDZRA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:00:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39673 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbXDZRAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:00:50 -0400
Date: Thu, 26 Apr 2007 09:56:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       bill.irwin@oracle.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com,
       clameter@sgi.com
Subject: [patch 24/33] fix OOM killing processes wrongly thought MPOL_BIND
Message-ID: <20070426165651.GY1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-oom-killing-processes-wrongly-thought-mpol_bind.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hugh@veritas.com>

I only have CONFIG_NUMA=y for build testing: surprised when trying a memhog
to see lots of other processes killed with "No available memory
(MPOL_BIND)".  memhog is killed correctly once we initialize nodemask in
constrained_alloc().

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Acked-by: William Irwin <bill.irwin@oracle.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/oom_kill.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -176,6 +176,8 @@ static inline int constrained_alloc(stru
 	struct zone **z;
 	nodemask_t nodes;
 	int node;
+
+	nodes_clear(nodes);
 	/* node has memory ? */
 	for_each_online_node(node)
 		if (NODE_DATA(node)->node_present_pages)

-- 
