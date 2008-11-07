Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbYKGL66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbYKGL66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 06:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYKGL6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 06:58:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:17063 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbYKGL6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 06:58:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,564,1220252400"; 
   d="scan'208";a="357311832"
From: Maciej Sosnowski <maciej.sosnowski@intel.com>
Subject: [PATCH 4/4] dca: fixup initialization dependency
To: dan.j.williams@intel.com
Cc: tom.s.picard@intel.com, mark_rustad@Xiotech.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, stable@kernel.org
Date: Fri, 07 Nov 2008 12:47:17 +0100
Message-ID: <20081107114704.25190.24427.stgit@linux.site>
In-Reply-To: <20081107114325.25190.5419.stgit@linux.site>
References: <20081107114325.25190.5419.stgit@linux.site>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

Mark dca_init as a subsys_initcall since it needs to be ready to go
before dependent drivers start registering themselves.

Cc: <stable@kernel.org>
Reported-and-tested-by: Mark Rustad <mark_rustad@Xiotech.com>
Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/dca/dca-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
index ec249d2..d883e1b 100644
--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -270,6 +270,6 @@ static void __exit dca_exit(void)
 	dca_sysfs_exit();
 }
 
-module_init(dca_init);
+subsys_initcall(dca_init);
 module_exit(dca_exit);
 

