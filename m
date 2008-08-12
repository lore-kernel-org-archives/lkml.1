Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbYHLT4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbYHLT4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 15:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYHLT4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:56:03 -0400
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:23227 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbYHLT4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:56:00 -0400
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Aug 2008 15:55:59 EDT
From: Konrad Rzeszutek <ketuzsezr@darnok.org>
To: gregkh@suse.de
Cc: pjones@redhat.com, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, Konrad Rzeszutek <ketuzsezr@darnok.org>
Subject: [PATCH] drivers/firmware/iscsi_ibft.c: make 3 functions static
Date: Tue, 12 Aug 2008 15:43:59 -0400
Message-Id: <1218570239-17766-2-git-send-email-ketuzsezr@darnok.org>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1218570239-17766-1-git-send-email-ketuzsezr@darnok.org>
References: <20080423095230.GK28933@cs181133002.pp.htv.fi>
 <1218570239-17766-1-git-send-email-ketuzsezr@darnok.org>
X-Junkmail-Status: score=10/50, host=mr08.lnh.mail.rcn.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A010205.48A1E88A.00B5,ss=1,fgs=0,
	ip=207.172.4.11,
	so=2007-10-30 19:00:17,
	dmn=5.4.3/2008-02-01
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

This patch makes the following needlessly global functions static:
- ibft_attr_show_initiator()
- ibft_attr_show_nic()
- ibft_attr_show_target()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Konrad Rzeszutek <ketuzsezr@darnok.org>
---
 drivers/firmware/iscsi_ibft.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index 8024e3b..8523811 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -334,9 +334,9 @@ static void ibft_release(struct kobject *kobj)
 /*
  *  Routines for parsing the iBFT data to be human readable.
  */
-ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
-				  struct ibft_attribute *attr,
-				  char *buf)
+static ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
+					struct ibft_attribute *attr,
+					char *buf)
 {
 	struct ibft_initiator *initiator = entry->initiator;
 	void *ibft_loc = entry->header;
@@ -376,9 +376,9 @@ ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
 	return str - buf;
 }
 
-ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
-			    struct ibft_attribute *attr,
-			    char *buf)
+static ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
+				  struct ibft_attribute *attr,
+				  char *buf)
 {
 	struct ibft_nic *nic = entry->nic;
 	void *ibft_loc = entry->header;
@@ -440,9 +440,9 @@ ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
 	return str - buf;
 };
 
-ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
-			       struct ibft_attribute *attr,
-			       char *buf)
+static ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
+				     struct ibft_attribute *attr,
+				     char *buf)
 {
 	struct ibft_tgt *tgt = entry->tgt;
 	void *ibft_loc = entry->header;
-- 
1.5.4.3

