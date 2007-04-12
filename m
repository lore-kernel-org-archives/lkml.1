Return-Path: <linux-kernel-owner+w=401wt.eu-S1161522AbXDLCwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161522AbXDLCwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161523AbXDLCwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:52:19 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:61978 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161514AbXDLCwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:52:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=EhYnUf+7k2M26xxRpgqCiexy0t5B6zVMPVUbC13hPUpPoq3qsZr49aH4v9509LlFRilgBt9xgc/QsqAvH+weojyWIyXRc7A0frKhdAr5oRfVkeyqjmPDy3Xe2t+7LN2NySlSocD7uiY1mAQrL/kBiiboWdu9wtNMOoafk707zaE=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       David Woodhouse <dwmw2@infradead.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Anton Altaparmakov <aia21@cantab.net>,
       Evgeniy Dushistov <dushistov@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       reiserfs-dev@namesys.com
Date: Wed, 11 Apr 2007 19:49:38 -0700
Message-Id: <20070412024938.27380.6659.patchbomb.py@localhost>
In-Reply-To: <20070412024938.27380.54538.patchbomb.py@localhost>
Subject: [PATCH 5/17] hfsplus: remove redundant read_mapping_page error check
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that read_mapping_page() does error checking internally, there is no
need to check PageError here.

Signed-off-by: Nate Diller <nate.diller@gmail.com> 

--- 

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/hfsplus/bnode.c linux-2.6.21-rc6-mm1-test/fs/hfsplus/bnode.c
--- linux-2.6.21-rc6-mm1/fs/hfsplus/bnode.c	2007-04-09 17:20:13.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/hfsplus/bnode.c	2007-04-10 21:28:45.000000000 -0700
@@ -442,10 +442,6 @@ static struct hfs_bnode *__hfs_bnode_cre
 		page = read_mapping_page(mapping, block, NULL);
 		if (IS_ERR(page))
 			goto fail;
-		if (PageError(page)) {
-			page_cache_release(page);
-			goto fail;
-		}
 		page_cache_release(page);
 		node->page[i] = page;
 	}
