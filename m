Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbZIVMy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbZIVMy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 08:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbZIVMyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 08:54:17 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58778 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294AbZIVMyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 08:54:14 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>, Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3/4] slqb: Allow SLQB to be used on PPC and S390
Date: Tue, 22 Sep 2009 13:54:14 +0100
Message-Id: <1253624054-10882-4-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253624054-10882-1-git-send-email-mel@csn.ul.ie>
References: <1253624054-10882-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLQB was disabled on PPC as it would stab itself in the face when running
on machines with CPUs on memoryless nodes and was disabled on S390 due
to other functionality difficulties. S390 has been independently fixed
and PPC should work in most configurations with remote locking of nodes
still with some difficulties. Allow SLQB to be configured again so the
dodgy configurations can be further identified and debugged.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 init/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index adc10ab..c56248f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1033,7 +1033,6 @@ config SLUB
 
 config SLQB
 	bool "SLQB (Queued allocator)"
-	depends on !PPC && !S390
 	help
 	  SLQB is a proposed new slab allocator.
 
-- 
1.6.3.3

