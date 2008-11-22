Return-Path: <linux-kernel-owner+w=401wt.eu-S1759829AbYKVRhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829AbYKVRhy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759185AbYKVRfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:35:38 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58449 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759006AbYKVRfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:35:36 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 14/32] ixgbe section fixes
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com
Message-Id: <E1L3wOM-0006Ti-Jt@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:35:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ixgbe_init_interrupt_scheme() is called from ixgbe_resume().  Build that
with CONFIG_PM and without CONFIG_HOTPLUG and you've got a problem.
Several helpers called by it also are misannotated __devinit.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/ixgbe/ixgbe_main.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -2330,7 +2330,7 @@ static void ixgbe_acquire_msix_vectors(struct ixgbe_adapter *adapter,
  * Once we know the feature-set enabled for the device, we'll cache
  * the register offset the descriptor ring is assigned to.
  **/
-static void __devinit ixgbe_cache_ring_register(struct ixgbe_adapter *adapter)
+static void ixgbe_cache_ring_register(struct ixgbe_adapter *adapter)
 {
 	int feature_mask = 0, rss_i;
 	int i, txr_idx, rxr_idx;
@@ -2367,7 +2367,7 @@ static void __devinit ixgbe_cache_ring_register(struct ixgbe_adapter *adapter)
  * number of queues at compile-time.  The polling_netdev array is
  * intended for Multiqueue, but should work fine with a single queue.
  **/
-static int __devinit ixgbe_alloc_queues(struct ixgbe_adapter *adapter)
+static int ixgbe_alloc_queues(struct ixgbe_adapter *adapter)
 {
 	int i;
 
@@ -2408,8 +2408,7 @@ err_tx_ring_allocation:
  * Attempt to configure the interrupts using the best available
  * capabilities of the hardware and the kernel.
  **/
-static int __devinit ixgbe_set_interrupt_capability(struct ixgbe_adapter
-                                                    *adapter)
+static int ixgbe_set_interrupt_capability(struct ixgbe_adapter *adapter)
 {
 	int err = 0;
 	int vector, v_budget;
@@ -2501,7 +2500,7 @@ static void ixgbe_reset_interrupt_capability(struct ixgbe_adapter *adapter)
  * - Hardware queue count (num_*_queues)
  *   - defined by miscellaneous hardware support/features (RSS, etc.)
  **/
-static int __devinit ixgbe_init_interrupt_scheme(struct ixgbe_adapter *adapter)
+static int ixgbe_init_interrupt_scheme(struct ixgbe_adapter *adapter)
 {
 	int err;
 
