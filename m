Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbYDGJvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbYDGJvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 05:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755733AbYDGJvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 05:51:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701AbYDGJvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 05:51:01 -0400
Subject: [NFS] Increase size of struct fid raw buffer
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Neil Brown <neilb@suse.de>, "J. Bruce Fields" <bfields@fieldses.org>,
       Adrian Bunk <bunk@kernel.org>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 07 Apr 2008 10:47:57 +0100
Message-Id: <1207561677.3635.166.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ba713d661333d790db5106c54d1f0ee94a876944 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Mon, 7 Apr 2008 09:53:24 +0100
Subject: [PATCH] [NFS] Increase size of struct fid raw buffer

GFS2 requires the NFS filehandle buffer to be larger than the
minimum size as per the bug report: http://lkml.org/lkml/2007/10/24/374
Its a pretty trivial fix for now and I've done a test which shows
that it works ok.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Neil Brown <neilb@suse.de>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Adrian Bunk <bunk@kernel.org>

diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index adcbb05..a6e928d 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -43,7 +43,7 @@ struct fid {
 			u32 parent_ino;
 			u32 parent_gen;
 		} i32;
-		__u32 raw[6];
+		__u32 raw[8];
 	};
 };
 
-- 
1.5.1.2



