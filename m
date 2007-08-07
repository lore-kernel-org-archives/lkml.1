Return-Path: <linux-kernel-owner+w=401wt.eu-S936709AbXHGVRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936709AbXHGVRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964920AbXHGUzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:55:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59712 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935201AbXHGUzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:55:09 -0400
Date: Tue, 7 Aug 2007 13:47:58 -0700
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
       alan@lxorguk.ukuu.org.uk, dev@openvz.org, jack@suse.cz,
       linux-ext4@vger.kernel.org
Subject: [2.6.22.2 review 58/84] jbd commit: fix transaction dropping
Message-ID: <20070807204758.GH23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="jbd-commit-fix-transaction-dropping.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jan Kara <jack@suse.cz>

We have to check that also the second checkpoint list is non-empty before
dropping the transaction.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd/commit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -887,7 +887,8 @@ restart_loop:
 	journal->j_committing_transaction = NULL;
 	spin_unlock(&journal->j_state_lock);
 
-	if (commit_transaction->t_checkpoint_list == NULL) {
+	if (commit_transaction->t_checkpoint_list == NULL &&
+	    commit_transaction->t_checkpoint_io_list == NULL) {
 		__journal_drop_transaction(journal, commit_transaction);
 	} else {
 		if (journal->j_checkpoint_transactions == NULL) {

-- 
