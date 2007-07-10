Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbXGJQHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbXGJQHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbXGJQG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:06:59 -0400
Received: from mail.fieldses.org ([66.93.2.214]:59681 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbXGJQG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:06:58 -0400
Date: Tue, 10 Jul 2007 12:06:53 -0400
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 009 of 20] knfsd: nfsd: use ip-address-based domain in
	secinfo case
Message-ID: <20070710160653.GF17368@fieldses.org>
References: <20070710121949.12548.patches@notabene> <1070710022517.13262@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1070710022517.13262@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Could you fold the below into this patch?  Without this the server can
oops on attempts to access a filesystem not exported to the request's
source address!  Thanks to Olga Kornievskaia for the testing that found
this.

--b.

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 333e5cf..582b494 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -1261,7 +1261,7 @@ gss:
 						&rqstp->rq_chandle);
 	if (PTR_ERR(gssexp) == -ENOENT)
 		return exp;
-	if (exp)
+	if (exp && !IS_ERR(exp))
 		exp_put(exp);
 	return gssexp;
 }
@@ -1291,7 +1291,7 @@ gss:
 						&rqstp->rq_chandle);
 	if (PTR_ERR(gssexp) == -ENOENT)
 		return exp;
-	if (exp)
+	if (exp && !IS_ERR(exp))
 		exp_put(exp);
 	return gssexp;
 }
