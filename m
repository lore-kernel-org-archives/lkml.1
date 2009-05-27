Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbZE0Btu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbZE0Btu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758229AbZE0Btl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:49:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:58660 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460AbZE0Btk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:49:40 -0400
From: Xiaotian Feng <Xiaotian.Feng@windriver.com>
To: galak@kernel.crashing.org, davem@davemloft.net, netdev@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] gianfar: fix babbling rx error event bug
Date: Wed, 27 May 2009 09:52:36 +0800
Message-Id: <1243389156-1668-1-git-send-email-Xiaotian.Feng@windriver.com>
X-Mailer: git-send-email 1.5.5.1
X-OriginalArrivalTime: 27 May 2009 01:49:30.0677 (UTC) FILETIME=[60647E50:01C9DE6D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gianfar interrupt handler uses IEVENT_ERR_MASK to check and handle errors.
Babbling RX error (IEVENT_BABR) should be included in IEVENT_ERROR_MASK.
Otherwise if BABR is raised, it never gets handled nor cleared, and an
interrupt storm results. This has been observed to happen on sending a
burst of ethernet frames to a gianfar based board.

Signed-off-by: Xiaotian Feng <xiaotian.feng@windriver.com>
---
 drivers/net/gianfar.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/gianfar.h b/drivers/net/gianfar.h
index 0642d52..cf35296 100644
--- a/drivers/net/gianfar.h
+++ b/drivers/net/gianfar.h
@@ -259,7 +259,7 @@ extern const char gfar_driver_version[];
 (IEVENT_RXC | IEVENT_BSY | IEVENT_EBERR | IEVENT_MSRO | \
  IEVENT_BABT | IEVENT_TXC | IEVENT_TXE | IEVENT_LC \
  | IEVENT_CRL | IEVENT_XFUN | IEVENT_DPE | IEVENT_PERR \
- | IEVENT_MAG)
+ | IEVENT_MAG | IEVENT_BABR)
 
 #define IMASK_INIT_CLEAR	0x00000000
 #define IMASK_BABR              0x80000000
-- 
1.5.5.1

