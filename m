Return-Path: <linux-kernel-owner+w=401wt.eu-S1751316AbZL1TFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbZL1TFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 14:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZL1TFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 14:05:35 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53367 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZL1TFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 14:05:34 -0500
Date: Mon, 28 Dec 2009 21:05:32 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org
Subject: [GIT PULL] SLAB updates for 2.6.33-rc2
Message-ID: <alpine.DEB.2.00.0912282103160.18425@melkki.cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a fix for SLAB lockdep annotation breakage that's causing false 
positives in 2.6.33-rc2.

 			Pekka

The following changes since commit 6b7b284958d47b77d06745b36bc7f36dab769d9b:
   Linus Torvalds (1):
         Linux 2.6.33-rc2

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6 slab/urgent

Pekka Enberg (1):
       SLAB: Fix lockdep annotation breakage

  mm/slab.c |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 7d41f15..7451bda 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -654,7 +654,7 @@ static void init_node_lock_keys(int q)

  		l3 = s->cs_cachep->nodelists[q];
  		if (!l3 || OFF_SLAB(s->cs_cachep))
-			return;
+			continue;
  		lockdep_set_class(&l3->list_lock, &on_slab_l3_key);
  		alc = l3->alien;
  		/*
@@ -665,7 +665,7 @@ static void init_node_lock_keys(int q)
  		 * for alloc_alien_cache,
  		 */
  		if (!alc || (unsigned long)alc == BAD_ALIEN_MAGIC)
-			return;
+			continue;
  		for_each_node(r) {
  			if (alc[r])
  				lockdep_set_class(&alc[r]->lock,
