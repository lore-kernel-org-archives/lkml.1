Return-Path: <linux-kernel-owner+w=401wt.eu-S1759652AbYGaC4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbYGaC4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbYGaCuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:50:16 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:60579 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759556AbYGaCuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:50:11 -0400
Date: Wed, 30 Jul 2008 21:49:00 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/30] W1: Document add, remove, search_count, and pullup.
Message-ID: <20080731024859.GK12181@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net> <20080729161356.2de456fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729161356.2de456fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 30 Jul 2008 21:49:00 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document w1_master_add, w1_master_remove, search_count, and pullup.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 Documentation/w1/w1.generic |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/Documentation/w1/w1.generic b/Documentation/w1/w1.generic
index 4c6509d..e3333ee 100644
--- a/Documentation/w1/w1.generic
+++ b/Documentation/w1/w1.generic
@@ -79,10 +79,13 @@ w1 master sysfs interface
 <xx-xxxxxxxxxxxxx> - a directory for a found device. The format is family-serial
 bus                - (standard) symlink to the w1 bus
 driver             - (standard) symlink to the w1 driver
+w1_master_add      - Manually register a slave device
 w1_master_attempts - the number of times a search was attempted
 w1_master_max_slave_count
                    - the maximum slaves that may be attached to a master
 w1_master_name     - the name of the device (w1_bus_masterX)
+w1_master_pullup   - 5V strong pullup 0 enabled, 1 disabled
+w1_master_remove   - Manually remove a slave device
 w1_master_search   - the number of searches left to do, -1=continual (default)
 w1_master_slave_count
                    - the number of slaves found
@@ -90,7 +93,13 @@ w1_master_slaves   - the names of the slaves, one per line
 w1_master_timeout  - the delay in seconds between searches
 
 If you have a w1 bus that never changes (you don't add or remove devices),
-you can set w1_master_search to a positive value to disable searches.
+you can set the module parameter search_count to a small positive number
+for an initially small number of bus searches.  Alternatively it could be
+set to zero, then manually add the slave device serial numbers by
+w1_master_add device file.  The w1_master_add and w1_master_remove files
+generally only make sense when searching is disabled, as a search will
+redetect manually removed devices that are present and timeout manually
+added devices that aren't on the bus.
 
 
 w1 slave sysfs interface
-- 
1.4.4.4
