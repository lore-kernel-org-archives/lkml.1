Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbXKFDNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbXKFDNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 22:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbXKFDNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 22:13:14 -0500
Received: from ro-out-1112.google.com ([72.14.202.178]:34552 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbXKFDNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 22:13:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=tF4HrW+9ADWMpal/gqWDvDlB3lD9YSKtiig/rcyhYoUgpdOK9E6tU1ZWQqOvEgAHakfWSQYZhr3NWrBNdnqaQVR+dBEB9dtWO72YvQDUT0caTmEwGIs759kqlnevRW/0FVDDSEueg8hXJYkMHpvGzHq5p+YtcglgjvkPigoF8PU=
Date: Tue, 6 Nov 2007 11:12:07 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       Andrew Morton <akpm@osdl.org>, Dong Pu <cocobear.cn@gmail.com>
Subject: [git Patch] mm/util.c: Remove needless code
Message-ID: <20071106031207.GA2478@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


If the code can be executed there, 'new_size' is always larger
than 'ks'. Thus min() is needless.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Dong Pu <cocobear.cn@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>

---
 mm/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/util.c b/mm/util.c
index 5f64026..295c7aa 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -96,7 +96,7 @@ void *krealloc(const void *p, size_t new_size, gfp_t flags)
 
 	ret = kmalloc_track_caller(new_size, flags);
 	if (ret) {
-		memcpy(ret, p, min(new_size, ks));
+		memcpy(ret, p, ks);
 		kfree(p);
 	}
 	return ret;

