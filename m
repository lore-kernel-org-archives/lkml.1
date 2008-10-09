Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbYJIMhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbYJIMhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbYJIMha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:37:30 -0400
Received: from sidv0150.hsr.ch ([152.96.52.150]:54727 "EHLO strongswan.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756561AbYJIMha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:37:30 -0400
X-Greylist: delayed 1626 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Oct 2008 08:37:29 EDT
Message-ID: <48EDF4AD.50907@strongswan.org>
Date: Thu, 09 Oct 2008 14:10:21 +0200
From: Tobias Brunner <tobias.brunner@strongswan.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc9] af_key: fix SADB_X_SPDDELETE response
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When deleting an SPD entry using SADB_X_SPDDELETE, c.data.byid is not 
initialized to zero in pfkey_spddelete(). Thus, key_notify_policy() 
responds with a PF_KEY message of type SADB_X_SPDDELETE2 instead of 
SADB_X_SPDDELETE.

Signed-off-by: Tobias Brunner <tobias.brunner@strongswan.org>

--- a/net/key/af_key.c	2008-10-09 13:10:04.000000000 +0200
+++ b/net/key/af_key.c	2008-10-09 13:49:11.000000000 +0200
@@ -2317,6 +2317,7 @@
 
 	c.seq = hdr->sadb_msg_seq;
 	c.pid = hdr->sadb_msg_pid;
+	c.data.byid = 0;
 	c.event = XFRM_MSG_DELPOLICY;
 	km_policy_notify(xp, pol->sadb_x_policy_dir-1, &c);
 

