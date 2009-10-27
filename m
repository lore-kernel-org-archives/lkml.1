Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbZJ0RuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbZJ0RuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 13:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756472AbZJ0RuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 13:50:14 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:42727 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756465AbZJ0RuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 13:50:13 -0400
Subject: [PATCH] nfs: reorder nfs4_sequence_regs to remove 8 bytes of
 padding on 64 bits
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-nfs@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 27 Oct 2009 17:50:12 +0000
Message-Id: <1256665813.2319.26.camel@castor>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reorder nfs4_sequence_args to remove 8 bytes of padding on 64 bit
builds. 

The size of this structure drops to 24 bytes from 32 and reduces the
text size of nfs.ko.
On my x86_64 size reports 

		text       data     bss
2.6.32-rc5 	200996	   8512	    432	 209940	  33414	nfs.ko
+patch 		200884	   8512	    432	 209828	  333a4	nfs.ko


Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

----
patch against 2.6.32-rc5
only lightly tested but it seems to work both with   
64 bit client -> 32 bit server & 32 bit client -> 64 bit server.

regards

Richard 


diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 62f63fb..8c88037 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -170,8 +170,8 @@ struct nfs4_sequence_args {
 struct nfs4_sequence_res {
 	struct nfs4_session	*sr_session;
 	u8			sr_slotid;	/* slot used to send request */
-	unsigned long		sr_renewal_time;
 	int			sr_status;	/* sequence operation status */
+	unsigned long		sr_renewal_time;
 };
 
 struct nfs4_get_lease_time_args {


