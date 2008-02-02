Return-Path: <linux-kernel-owner+w=401wt.eu-S1762040AbYBBA3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762040AbYBBA3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763395AbYBBAYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:24:49 -0500
Received: from ns1.suse.de ([195.135.220.2]:54601 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763385AbYBBAYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:24:47 -0500
Date: Fri, 1 Feb 2008 16:20:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Li Zefan <lizf@cn.fujitsu.com>, "David S. Miller" <davem@davemloft.net>
Subject: [patch 14/27] CONNECTOR: Dont touch queue dev after decrement of
	ref count.
Message-ID: <20080202002039.GO8368@suse.de>
References: <20080202001232.472591439@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="connector-don-t-touch-queue-dev-after-decrement-of-ref-count.patch"
In-Reply-To: <20080202001927.GA8368@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Li Zefan <lizf@cn.fujitsu.com>

[CONNECTOR]: Don't touch queue dev after decrement of ref count.

[ Upstream commit: cf585ae8ae9ac7287a6d078425ea32f22bf7f1f7 ]

cn_queue_free_callback() will touch 'dev'(i.e. cbq->pdev), so it
should be called before atomic_dec(&dev->refcnt).

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/connector/cn_queue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/connector/cn_queue.c
+++ b/drivers/connector/cn_queue.c
@@ -99,8 +99,8 @@ int cn_queue_add_callback(struct cn_queu
 	spin_unlock_bh(&dev->queue_lock);
 
 	if (found) {
-		atomic_dec(&dev->refcnt);
 		cn_queue_free_callback(cbq);
+		atomic_dec(&dev->refcnt);
 		return -EINVAL;
 	}
 

-- 
