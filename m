Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbZBOWMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbZBOWMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 17:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbZBOWMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 17:12:06 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53330 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbZBOWME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 17:12:04 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 15 Feb 2009 23:11:38 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: constify device ID tables
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.4edc17c763388731@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/dv1394.c    |    2 +-
 drivers/ieee1394/eth1394.c   |    2 +-
 drivers/ieee1394/nodemgr.c   |    4 ++--
 drivers/ieee1394/nodemgr.h   |    2 +-
 drivers/ieee1394/raw1394.c   |    2 +-
 drivers/ieee1394/sbp2.c      |    2 +-
 drivers/ieee1394/video1394.c |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

Index: linux/drivers/ieee1394/dv1394.c
===================================================================
--- linux.orig/drivers/ieee1394/dv1394.c
+++ linux/drivers/ieee1394/dv1394.c
@@ -2175,7 +2175,7 @@ static const struct file_operations dv13
  * Export information about protocols/devices supported by this driver.
  */
 #ifdef MODULE
-static struct ieee1394_device_id dv1394_id_table[] = {
+static const struct ieee1394_device_id dv1394_id_table[] = {
 	{
 		.match_flags	= IEEE1394_MATCH_SPECIFIER_ID | IEEE1394_MATCH_VERSION,
 		.specifier_id	= AVC_UNIT_SPEC_ID_ENTRY & 0xffffff,
Index: linux/drivers/ieee1394/eth1394.c
===================================================================
--- linux.orig/drivers/ieee1394/eth1394.c
+++ linux/drivers/ieee1394/eth1394.c
@@ -438,7 +438,7 @@ static int eth1394_update(struct unit_di
 	return eth1394_new_node(hi, ud);
 }
 
-static struct ieee1394_device_id eth1394_id_table[] = {
+static const struct ieee1394_device_id eth1394_id_table[] = {
 	{
 		.match_flags = (IEEE1394_MATCH_SPECIFIER_ID |
 				IEEE1394_MATCH_VERSION),
Index: linux/drivers/ieee1394/nodemgr.c
===================================================================
--- linux.orig/drivers/ieee1394/nodemgr.c
+++ linux/drivers/ieee1394/nodemgr.c
@@ -484,7 +484,7 @@ static struct device_attribute *const fw
 static ssize_t fw_show_drv_device_ids(struct device_driver *drv, char *buf)
 {
 	struct hpsb_protocol_driver *driver;
-	struct ieee1394_device_id *id;
+	const struct ieee1394_device_id *id;
 	int length = 0;
 	char *scratch = buf;
 
@@ -658,7 +658,7 @@ static int nodemgr_bus_match(struct devi
 {
 	struct hpsb_protocol_driver *driver;
 	struct unit_directory *ud;
-	struct ieee1394_device_id *id;
+	const struct ieee1394_device_id *id;
 
 	/* We only match unit directories */
 	if (dev->platform_data != &nodemgr_ud_platform_data)
Index: linux/drivers/ieee1394/nodemgr.h
===================================================================
--- linux.orig/drivers/ieee1394/nodemgr.h
+++ linux/drivers/ieee1394/nodemgr.h
@@ -125,7 +125,7 @@ struct hpsb_protocol_driver {
 	 * probe function below can implement further protocol
 	 * dependent or vendor dependent checking.
 	 */
-	struct ieee1394_device_id *id_table;
+	const struct ieee1394_device_id *id_table;
 
 	/*
 	 * The update function is called when the node has just
Index: linux/drivers/ieee1394/raw1394.c
===================================================================
--- linux.orig/drivers/ieee1394/raw1394.c
+++ linux/drivers/ieee1394/raw1394.c
@@ -2982,7 +2982,7 @@ static int raw1394_release(struct inode 
  * Export information about protocols/devices supported by this driver.
  */
 #ifdef MODULE
-static struct ieee1394_device_id raw1394_id_table[] = {
+static const struct ieee1394_device_id raw1394_id_table[] = {
 	{
 	 .match_flags = IEEE1394_MATCH_SPECIFIER_ID | IEEE1394_MATCH_VERSION,
 	 .specifier_id = AVC_UNIT_SPEC_ID_ENTRY & 0xffffff,
Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -285,7 +285,7 @@ static const struct hpsb_address_ops sbp
 /*
  * Interface to driver core and IEEE 1394 core
  */
-static struct ieee1394_device_id sbp2_id_table[] = {
+static const struct ieee1394_device_id sbp2_id_table[] = {
 	{
 	 .match_flags	= IEEE1394_MATCH_SPECIFIER_ID | IEEE1394_MATCH_VERSION,
 	 .specifier_id	= SBP2_UNIT_SPEC_ID_ENTRY & 0xffffff,
Index: linux/drivers/ieee1394/video1394.c
===================================================================
--- linux.orig/drivers/ieee1394/video1394.c
+++ linux/drivers/ieee1394/video1394.c
@@ -1294,7 +1294,7 @@ static const struct file_operations vide
  * Export information about protocols/devices supported by this driver.
  */
 #ifdef MODULE
-static struct ieee1394_device_id video1394_id_table[] = {
+static const struct ieee1394_device_id video1394_id_table[] = {
 	{
 		.match_flags	= IEEE1394_MATCH_SPECIFIER_ID | IEEE1394_MATCH_VERSION,
 		.specifier_id	= CAMERA_UNIT_SPEC_ID_ENTRY & 0xffffff,

-- 
Stefan Richter
-=====-==--= --=- -====
http://arcgraph.de/sr/

