Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbYKVRjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbYKVRjj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759527AbYKVRg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:36:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58476 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759522AbYKVRgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:36:25 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 19/32] rapidio section noise
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wPA-0006YC-Kh@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:36:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


functions calling devinit and called only from devinit

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/rapidio/rio-scan.c |    4 ++--
 drivers/rapidio/rio.c      |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -879,7 +879,7 @@ static void rio_update_route_tables(struct rio_mport *port)
  * link, then start recursive peer enumeration. Returns %0 if
  * enumeration succeeds or %-EBUSY if enumeration fails.
  */
-int rio_enum_mport(struct rio_mport *mport)
+int __devinit rio_enum_mport(struct rio_mport *mport)
 {
 	struct rio_net *net = NULL;
 	int rc = 0;
@@ -972,7 +972,7 @@ static void rio_enum_timeout(unsigned long data)
  * peer discovery. Returns %0 if discovery succeeds or %-EBUSY
  * on failure.
  */
-int rio_disc_mport(struct rio_mport *mport)
+int __devinit rio_disc_mport(struct rio_mport *mport)
 {
 	struct rio_net *net = NULL;
 	int enum_timeout_flag = 0;
diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -467,7 +467,7 @@ static int __devinit rio_init(void)
 
 device_initcall(rio_init);
 
-int rio_init_mports(void)
+int __devinit rio_init_mports(void)
 {
 	int rc = 0;
 	struct rio_mport *port;
