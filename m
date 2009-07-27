Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbZG0O4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbZG0O4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZG0O4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:56:49 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:56525 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbZG0O4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:56:48 -0400
Date: Mon, 27 Jul 2009 07:55:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, drbd-dev@lists.linbit.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] drbd: fix build when CONFIG_MODULES=n
Message-Id: <20090727075536.533d1801.randy.dunlap@oracle.com>
In-Reply-To: <20090727180552.eb32515b.sfr@canb.auug.org.au>
References: <20090727180552.eb32515b.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.4A6DC003.0095:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009 18:05:52 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20090724:
> 
> New trees:
> 	drbd
> 
> The drbd tree gained two build failures for which I reverted a commit from
> the rr tree and applied a patch.
> ----------------------------------------------------------------------------


(already fixed?)

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix drbd build when CONFIG_MODULES=n:
drivers/block/drbd/drbd_main.c:3738: error: dereferencing pointer to incomplete type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: drbd-dev@lists.linbit.com
---
 drivers/block/drbd/drbd_main.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-next-20090727.orig/drivers/block/drbd/drbd_main.c
+++ linux-next-20090727/drivers/block/drbd/drbd_main.c
@@ -3733,12 +3733,16 @@ const char *drbd_buildtag(void)
 
 	static char buildtag[38] = "\0uilt-in";
 
+#ifdef CONFIG_MODULES
 	if (buildtag[0] == 0) {
 		if (THIS_MODULE != NULL)
 			sprintf(buildtag, "srcversion: %-24s", THIS_MODULE->srcversion);
 		else
 			buildtag[0] = 'b';
 	}
+#else
+	buildtag[0] = 'b';
+#endif
 
 	return buildtag;
 }
