Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbYGIER6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbYGIER6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 00:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbYGIERv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 00:17:51 -0400
Received: from mx1.suse.de ([195.135.220.2]:56167 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbYGIERu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 00:17:50 -0400
Date: Tue, 8 Jul 2008 21:17:48 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git patch] ocfs2 fix for 2.6.26
Message-ID: <20080709041748.GG28100@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This single patch fixes an Ocfs2 regression introduced during the merge
window.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/dlm/dlmmaster.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

Sunil Mushran (1):
      ocfs2/dlm: Fixes oops in dlm_new_lockres()

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index efc015c..44f87ca 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -606,7 +606,9 @@ static void dlm_init_lockres(struct dlm_ctxt *dlm,
 
 	res->last_used = 0;
 
+	spin_lock(&dlm->spinlock);
 	list_add_tail(&res->tracking, &dlm->tracking_list);
+	spin_unlock(&dlm->spinlock);
 
 	memset(res->lvb, 0, DLM_LVB_LEN);
 	memset(res->refmap, 0, sizeof(res->refmap));
 
