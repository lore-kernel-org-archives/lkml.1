Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754025AbYLRLtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbYLRLtx (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 06:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYLRLt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 06:49:28 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38297 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbYLRLt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 06:49:27 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2008-12-16-00-43 uploaded (fs)
Cc: kosaki.motohiro@jp.fujitsu.com, Randy Dunlap <randy.dunlap@oracle.com>,
        linux-kernel@vger.kernel.org, npiggin@suse.de
In-Reply-To: <20081218200145.D7B3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081216102136.08ba1714.akpm@linux-foundation.org> <20081218200145.D7B3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081218204842.D7B9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 18 Dec 2008 20:49:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I have fixing patch. this patch series have
> 
> 1) reiser4 fix
> 2) ubifs fix
> 3) fuse fix


Tested on mmotm1217 + fs-symlink-write_begin-allocation-context-fix.patch

==
Subject: [PATCH 3/3] fix fuse build error of fs-symlink-write_begin-allocation-context-fix.patch

build fix.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/fs/fuse/file.c
===================================================================
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -789,7 +789,7 @@ static ssize_t fuse_fill_write_pages(str
 			break;
 
 		err = -ENOMEM;
-		page = __grab_cache_page(mapping, index);
+		page = grab_cache_page_write_begin(mapping, index, 0);
 		if (!page)
 			break;
 


