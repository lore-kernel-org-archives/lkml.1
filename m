Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbYDHNEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbYDHNEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 09:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYDHNEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 09:04:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbYDHNEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 09:04:13 -0400
Subject: [NFS] Use a zero sized array for raw field in struct fid
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       "J. Bruce Fields" <bfields@fieldses.org>, Adrian Bunk <bunk@kernel.org>,
       ChristophHellwig <hch@infradead.org>
In-Reply-To: <20080408075807.GA8893@infradead.org>
References: <1207561677.3635.166.camel@quoit>
	 <alpine.LFD.1.00.0804070850310.11277@woody.linux-foundation.org>
	 <1207641005.3635.238.camel@quoit>  <20080408075807.GA8893@infradead.org>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 08 Apr 2008 14:01:26 +0100
Message-Id: <1207659686.3635.278.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b8732f8bea4e8abc331b8fa58a4047c91e2e7d02 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Tue, 8 Apr 2008 13:12:52 +0100
Subject: [PATCH] [NFS] Use a zero sized array for raw field in struct fid

The raw field's size can vary so we use a zero sized array since
gcc will not allow a variable sized array inside a union. This
has been tested with ext3 and gfs2 and relates to the bug
report: http://lkml.org/lkml/2007/10/24/374 and discussion
thread: http://lkml.org/lkml/2008/4/7/65

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Neil Brown <neilb@suse.de>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Adrian Bunk <bunk@kernel.org>

diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index adcbb05..de8387b 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -43,7 +43,7 @@ struct fid {
 			u32 parent_ino;
 			u32 parent_gen;
 		} i32;
-		__u32 raw[6];
+		__u32 raw[0];
 	};
 };
 
-- 
1.5.1.2



