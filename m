Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbYLVTVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbYLVTVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 14:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbYLVTRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 14:17:08 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:50184 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbYLVTRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 14:17:05 -0500
Subject: [PATCH 14/27] drivers/net/netxen: fix sparse warnings: use NULL
	pointer instead of plain integer
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Dec 2008 20:16:59 +0100
Message-ID: <20081222191659.11807.9347.stgit@vmbox.hanneseder.net>
In-Reply-To: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:

  drivers/net/netxen/netxen_nic_hw.c:1462:18: warning: Using plain integer as NULL pointer
  drivers/net/netxen/netxen_nic_hw.c:1536:18: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/netxen/netxen_nic_hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netxen/netxen_nic_hw.c b/drivers/net/netxen/netxen_nic_hw.c
index 86379fd..aa6e603 100644
--- a/drivers/net/netxen/netxen_nic_hw.c
+++ b/drivers/net/netxen/netxen_nic_hw.c
@@ -1459,7 +1459,7 @@ static int netxen_nic_pci_mem_read_direct(struct netxen_adapter *adapter,
 			mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE * 2);
 		else
 			mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE);
-		if (mem_ptr == 0UL) {
+		if (mem_ptr == NULL) {
 			*(uint8_t  *)data = 0;
 			return -1;
 		}
@@ -1533,7 +1533,7 @@ netxen_nic_pci_mem_write_direct(struct netxen_adapter *adapter, u64 off,
 			mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE*2);
 		else
 			mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE);
-		if (mem_ptr == 0UL)
+		if (mem_ptr == NULL)
 			return -1;
 		addr = mem_ptr;
 		addr += start & (PAGE_SIZE - 1);

