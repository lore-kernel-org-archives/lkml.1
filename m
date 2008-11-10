Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbYKJFhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbYKJFhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 00:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYKJFgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 00:36:49 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:4463 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbYKJFgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 00:36:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=hNF/7ffVaJOxrGyPSFdgV4OpU9AoC7DQVBK3EmNzbIvylDmSWWIQLfwfzsdmPdqzWL
         baU+CiFafsL/5fFCkDzRYysKsEaaE/RGSsbOu2n/pVu8+KUhwpA2n3xz/KXr6Y8nmB4U
         TajTWvWgNYmysCpm+hf5HK4CRyI6ucjnn5GjY=
Subject: [PATCH 3/3] lib: proportions.c trivial sparse lock annotation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Nov 2008 21:36:43 -0800
Message-Id: <1226295403.5478.13.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suppresses sparse warning:
lib/proportions.c:159:16: warning: context imbalance in 'prop_get_global': wrong count at exit
lib/proportions.c:159:16:    context 'RCU': wanted 0, got 1
lib/proportions.c:164:2: warning: context imbalance in 'prop_put_global': unexpected unlock
lib/proportions.c:164:2:    context 'RCU': wanted 0, got -1

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 lib/proportions.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/proportions.c b/lib/proportions.c
index 4f387a6..3fda810 100644
--- a/lib/proportions.c
+++ b/lib/proportions.c
@@ -147,6 +147,7 @@ out:
  * this is used to track the active references.
  */
 static struct prop_global *prop_get_global(struct prop_descriptor *pd)
+__acquires(RCU)
 {
 	int index;
 
@@ -160,6 +161,7 @@ static struct prop_global *prop_get_global(struct prop_descriptor *pd)
 }
 
 static void prop_put_global(struct prop_descriptor *pd, struct prop_global *pg)
+__releases(RCU)
 {
 	rcu_read_unlock();
 }
-- 
1.6.0.3.866.gc189b

