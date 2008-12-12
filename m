Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbYLLNkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbYLLNkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 08:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758127AbYLLNjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 08:39:53 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:60393 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757040AbYLLNjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 08:39:53 -0500
Subject: [PATCH] netfilter: remove padding from struct xt_match on 64bit
	builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: coreteam@netfilter.org
Cc: lkml <linux-kernel@vger.kernel.org>, netfilter@vger.kernel.org
Content-Type: text/plain
Date: Fri, 12 Dec 2008 13:39:50 +0000
Message-Id: <1229089190.2921.7.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reorder struct xt_match to remove 8 bytes of padding and make its size
128 bytes.

This saves a small amount of data space in each of the xt netfilter
modules and fits xt_match in one 128 byte cache line.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
----

patch against v2.6.28-rc8
Compiled & running on AMD X2 desktop machine.
regards
Richard



diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index e52ce47..c7ee874 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -270,6 +270,7 @@ struct xt_match
 	struct list_head list;
 
 	const char name[XT_FUNCTION_MAXNAMELEN-1];
+	u_int8_t revision;
 
 	/* Return true or false: return FALSE and set *hotdrop = 1 to
            force immediate packet drop. */
@@ -302,7 +303,6 @@ struct xt_match
 	unsigned short proto;
 
 	unsigned short family;
-	u_int8_t revision;
 };
 
 /* Registration hooks for targets. */


