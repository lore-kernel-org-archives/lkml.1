Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZA0Fji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZA0Fji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 00:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZA0Fj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 00:39:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50605 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbZA0Fj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 00:39:29 -0500
Date: Tue, 27 Jan 2009 00:39:20 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kyle McMartin <kyle@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Bartelmus <lirc@bartelmus.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH] make checkpatch warn about access to current->comm
Message-ID: <20090127053920.GB5034@bombadil.infradead.org>
References: <20090120071641.B0A3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <AuEeLWHZjFB@christoph> <20090128140615.D464.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090126211655.c7287768.akpm@linux-foundation.org> <20090127051919.GA5034@bombadil.infradead.org> <20090126212615.2658b29e.akpm@linux-foundation.org> <20090126212918.d4770115.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126212918.d4770115.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

Suggest using the get_task_comm accessor versus direct access to
current->comm.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

---

I just mashed it in the middle of existing checks to minimize risk of
collisions.

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 45eb0ae..4f2da5d 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2533,6 +2533,11 @@ sub process {
 				$herecurr);
 		}
 
+# direct access to current task name is racy, suggest accessor instead.
+		if ($line =~ /current\-\>comm/) {
+			WARN("direct access to current->comm is racy, use get_task_comm() instead.\n" . $herecurr);
+		}
+
 # use of NR_CPUS is usually wrong
 # ignore definitions of NR_CPUS and usage to define arrays as likely right
 		if ($line =~ /\bNR_CPUS\b/ &&
