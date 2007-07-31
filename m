Return-Path: <linux-kernel-owner+w=401wt.eu-S969114AbXGaEhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969114AbXGaEhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967600AbXGaEcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:32:09 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34605 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968187AbXGaEcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:32:07 -0400
Date: Mon, 30 Jul 2007 21:33:11 -0700
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
       alan@lxorguk.ukuu.org.uk, tonyj@suse.de, viro@zeniv.linux.org.uk,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 17/26] audit: fix oops removing watch if audit disabled
Message-ID: <20070731043311.GR3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="audit-fix-oops-removing-watch-if-audit-disabled.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tony Jones <tonyj@suse.de>

Removing a watched file will oops if audit is disabled (auditctl -e 0).

To reproduce:
- auditctl -e 1
- touch /tmp/foo
- auditctl -w /tmp/foo
- auditctl -e 0
- rm /tmp/foo (or mv)

Signed-off-by: Tony Jones <tonyj@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 kernel/auditfilter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21.6.orig/kernel/auditfilter.c
+++ linux-2.6.21.6/kernel/auditfilter.c
@@ -905,7 +905,7 @@ static void audit_update_watch(struct au
 
 		/* If the update involves invalidating rules, do the inode-based
 		 * filtering now, so we don't omit records. */
-		if (invalidating &&
+		if (invalidating && current->audit_context &&
 		    audit_filter_inodes(current, current->audit_context) == AUDIT_RECORD_CONTEXT)
 			audit_set_auditable(current->audit_context);
 

-- 
