Return-Path: <linux-kernel-owner+w=401wt.eu-S934542AbZIEAUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934542AbZIEAUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934499AbZIEAU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:20:29 -0400
Received: from kroah.org ([198.145.64.141]:42034 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934174AbZIEAU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:47 2009
Message-Id: <20090905001447.110796519@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:13:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hannes Hering <hering2@de.ibm.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 01/71] ehea: Fix napi list corruption on ifconfig down
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=ehea-fix-napi-list-corruption-on-ifconfig-down.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Hannes Hering <hering2@de.ibm.com>

commit 357eb46d8f275b4e8484541234ea3ba06065e258 upstream.

This patch fixes the napi list handling when an ehea interface is shut
down to avoid corruption of the napi list.

Signed-off-by: Hannes Hering <hering2@de.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ehea/ehea.h      |    2 +-
 drivers/net/ehea/ehea_main.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ehea/ehea.h
+++ b/drivers/net/ehea/ehea.h
@@ -40,7 +40,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0101"
+#define DRV_VERSION	"EHEA_0102"
 
 /* eHEA capability flags */
 #define DLPAR_PORT_ADD_REM 1
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -1545,6 +1545,9 @@ static int ehea_clean_portres(struct ehe
 {
 	int ret, i;
 
+	if (pr->qp)
+		netif_napi_del(&pr->napi);
+
 	ret = ehea_destroy_qp(pr->qp);
 
 	if (!ret) {


