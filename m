Return-Path: <linux-kernel-owner+w=401wt.eu-S934083AbZIDUXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083AbZIDUXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933960AbZIDUXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:23:13 -0400
Received: from kroah.org ([198.145.64.141]:36095 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933943AbZIDUOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:11 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:50 2009
Message-Id: <20090904200850.355960571@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hannes Hering <hering2@de.ibm.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 03/48] ehea: Fix napi list corruption on ifconfig down
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=ehea-fix-napi-list-corruption-on-ifconfig-down.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Hannes Hering <hering2@de.ibm.com>

commit 357eb46d8f275b4e8484541234ea3ba06065e258 upstream.

This patch fixes the napi list handling when an ehea interface is shut
down to avoid corruption of the napi list.

Signed-off-by: Hannes Hering <hering2@de.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ehea/ehea_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -1530,6 +1530,9 @@ static int ehea_clean_portres(struct ehe
 {
 	int ret, i;
 
+	if (pr->qp)
+		netif_napi_del(&pr->napi);
+
 	ret = ehea_destroy_qp(pr->qp);
 
 	if (!ret) {


