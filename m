Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbYCHSiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbYCHSiA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 13:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756642AbYCHShq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 13:37:46 -0500
Received: from kumera.dghda.com ([80.68.90.171]:2219 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756468AbYCHShp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 13:37:45 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, sct@redhat.com, akpm@linux-foundation.org,
       adilger@clusterfs.com, Duane Griffin <duaneg@dghda.com>
Subject: jbd/2: eliminate code duplication and gracefully handle cache initialisation failure
Date: Sat,  8 Mar 2008 18:37:33 +0000
Message-Id: <1205001459-5291-1-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 fs/jbd/journal.c  |  149 +++++++++++++++++++++++-------------------------
 fs/jbd/revoke.c   |  164 +++++++++++++++++++++++------------------------------
 fs/jbd2/journal.c |  154 ++++++++++++++++++++++++-------------------------
 fs/jbd2/revoke.c  |  164 +++++++++++++++++++++++------------------------------
 4 files changed, 291 insertions(+), 340 deletions(-)

This is version 2 of the jdb/2 patches to eliminate code duplication and
gracefully handle cace initialisation failure.

Changes since V1:
 * Check whether caches are initialised in journal_init_common. If not then
   attempt to initialise them once before failing.
 * Addressed all Andreas Dilger's comments.
 * Modified the initialisation/destruction methods to match Christoph Hellwig's
   suggestions.
 * Rolled the if/assertion and debugfs changes into the main patch.

Andrew, please drop the earlier versions of these patches and replace them with
these ones, thanks.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
