Return-Path: <linux-kernel-owner+w=401wt.eu-S1761281AbXKON5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761281AbXKON5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 08:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756683AbXKON4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 08:56:53 -0500
Received: from ag-out-0708.google.com ([72.14.246.248]:15049 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356AbXKON4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 08:56:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=mnyQfBNsKJ5I+uJJIhql5YMSFkQX3TbEYCllSX+INh2nQAaZOMEHhyW3MW5NqVK1fclZFjUqG9EVGJvElwUJzs7qgpM0hfacbu3daW9MA0WhWZ9E7oxNRi0cVo/FKzWg2yvwP4pvwGS4upjcJTPDUNW03VQehyILRr+/vlcoxqw=
Date: Thu, 15 Nov 2007 21:54:28 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@osdl.org>, linux-mm@kvack.org
Subject: [Patch] mm/sparse.c: Check the return value of
	sparse_index_alloc().
Message-ID: <20071115135428.GE2489@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Since sparse_index_alloc() can return NULL on memory allocation failure,
we must deal with the failure condition when calling it.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Rik van Riel <riel@redhat.com>

---

diff --git a/Makefile b/Makefile
diff --git a/mm/sparse.c b/mm/sparse.c
index e06f514..d245e59 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -83,6 +83,8 @@ static int __meminit sparse_index_init(unsigned long section_nr, int nid)
 		return -EEXIST;
 
 	section = sparse_index_alloc(nid);
+	if (!section)
+		return -ENOMEM;
 	/*
 	 * This lock keeps two different sections from
 	 * reallocating for the same index
