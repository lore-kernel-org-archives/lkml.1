Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbYBUHVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbYBUHVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 02:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYBUHVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 02:21:41 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:35866 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbYBUHVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 02:21:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ojlIa/LJ97kzQP3xPNSp29BSywQUaaBmZUmHV1ZkgUf6wECydDlzBcOFmPga3FaraMZcXvD0PHa9uvbhiJGhVZ53SR+Ku5lycwroPEXwlPIe0e8hqKTyZEpbRmglFYHjLOlaGQm0dChiT8Z7bpTRcLV4IwaZejTMNVOlgpgvbXs=
Subject: [PATCH] markers: fix sparse warnings in markers.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 23:21:54 -0800
Message-Id: <1203578514.20345.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

char can be unsigned
kernel/marker.c:64:20: error: dubious one-bit signed bitfield
kernel/marker.c:65:14: error: dubious one-bit signed bitfield

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Introduced between -rc1 and -rc2
 kernel/marker.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/marker.c b/kernel/marker.c
index c4c2cd8..50effc0 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -61,8 +61,8 @@ struct marker_entry {
 	int refcount;	/* Number of times armed. 0 if disarmed. */
 	struct rcu_head rcu;
 	void *oldptr;
-	char rcu_pending:1;
-	char ptype:1;
+	unsigned char rcu_pending:1;
+	unsigned char ptype:1;
 	char name[0];	/* Contains name'\0'format'\0' */
 };
 
-- 
1.5.4.2.200.g99e75



