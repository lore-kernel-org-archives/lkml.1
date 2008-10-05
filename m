Return-Path: <linux-kernel-owner+w=401wt.eu-S1761779AbYJEQmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761779AbYJEQmw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760276AbYJEQie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:38:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54294 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759028AbYJEQi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:38:26 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 16/19] mptsas: remove unneeded check
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:38:26 +0100
Message-ID: <20081005163822.3799.61508.stgit@localhost.localdomain>
In-Reply-To: <20081005163302.3799.61899.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From coverity checker. Closes #9675

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/message/fusion/mptsas.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 12b7325..a9019f0 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2279,9 +2279,8 @@ mptsas_delete_expander_phys(MPT_ADAPTER *ioc)
 	mutex_lock(&ioc->sas_topology_mutex);
 	list_for_each_entry_safe(port_info, n, &ioc->sas_topology, list) {
 
-		if (port_info->phy_info &&
-		    (!(port_info->phy_info[0].identify.device_info &
-		    MPI_SAS_DEVICE_INFO_SMP_TARGET)))
+		if (!(port_info->phy_info[0].identify.device_info &
+		    MPI_SAS_DEVICE_INFO_SMP_TARGET))
 			continue;
 
 		if (mptsas_sas_expander_pg0(ioc, &buffer,

