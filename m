Return-Path: <linux-kernel-owner+w=401wt.eu-S1762361AbYGKN5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762361AbYGKN5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759552AbYGKNsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:48:25 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34977 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755853AbYGKNrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:52 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 10/30] W1: Document add, remove, search_count, and pullup.
Date: Fri, 11 Jul 2008 17:51:25 +0400
Message-Id: <12157843063232-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
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

