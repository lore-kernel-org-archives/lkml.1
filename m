Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbYJMOOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbYJMOOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYJMOO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:14:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45245 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752056AbYJMOO2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:14:28 -0400
Date: Mon, 13 Oct 2008 15:05:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mptsas: remove pointless null check
Message-ID: <20081013150529.75f22702@lxorguk.ukuu.org.uk>
In-Reply-To: <48F34CB9.3020000@pobox.com>
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru>
	<48F2F138.6020103@kernel.org>
	<48F34CB9.3020000@pobox.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mptsas: remove unneeded check

From: Alan Cox <alan@redhat.com>

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
