Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbYKDH0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbYKDH0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 02:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYKDH0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 02:26:03 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:20698 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbYKDH0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 02:26:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZEnC6gZaa3CdMhnCPV0w4WdTKvrmK4c2/0qfE3WM7MYtQKALV9cre/8hve0QkBXh/C
         XE8gnI2frIsZdXy3cMuDIXZrVAMmKY87c7WF1zZv6HBuHGP8xJbJTnANsNNAB0e9I4H2
         hBD0ab9q3oVC71D2o+pS2oAdU+P4kjAXwZatg=
From: "Richard A. Holden III" <aciddeath@gmail.com>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Harkes <jaharkes@cs.cmu.edu>,
       coda@cs.cmu.edu, codalist@coda.cs.cmu.ed
Subject: [PATCH] Fix fs/coda/sysctl.c build warnings when !CONFIG_SYSCTL
Date: Tue,  4 Nov 2008 01:27:19 -0700
Message-Id: <1225787239-25429-1-git-send-email-aciddeath@gmail.com>
X-Mailer: git-send-email 1.5.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix
fs/coda/sysctl.c:14: warning: 'fs_table_header' defined but not used
fs/coda/sysctl.c:44: warning: 'fs_table' defined but not used

these are only used when CONFIG_SYSCTL is defined.

Signed-off-by: Richard A. Holden III <aciddeath@gmail.com>
---
 fs/coda/sysctl.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/coda/sysctl.c b/fs/coda/sysctl.c
index 81b7771..43c96ce 100644
--- a/fs/coda/sysctl.c
+++ b/fs/coda/sysctl.c
@@ -11,7 +11,9 @@
 
 #include "coda_int.h"
 
+#ifdef CONFIG_SYSCTL
 static struct ctl_table_header *fs_table_header;
+#endif
 
 static ctl_table coda_table[] = {
 	{
@@ -41,6 +43,7 @@ static ctl_table coda_table[] = {
 	{}
 };
 
+#ifdef CONFIG_SYSCTL
 static ctl_table fs_table[] = {
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -50,7 +53,7 @@ static ctl_table fs_table[] = {
 	},
 	{}
 };
-
+#endif
 
 void coda_sysctl_init(void)
 {
-- 
1.5.6.4

