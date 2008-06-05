Return-Path: <linux-kernel-owner+w=401wt.eu-S1760138AbYFESjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138AbYFESjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYFESji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:39:38 -0400
Received: from smtp-out.google.com ([216.239.33.17]:48817 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbYFESjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:39:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:mime-version:
	content-type:content-transfer-encoding:content-disposition;
	b=YPM8dtpW+H7IKzyxUjxhTd5VaOy6tGDm6bES5d4TqauqrQE5kmo7iqkSw44+EMb0W
	qlAF24eVjCL8aSwrQYBVw==
Message-ID: <4ca0a85e0806051139q28d70661w569a036f54dcf89b@mail.gmail.com>
Date: Thu, 5 Jun 2008 14:39:25 -0400
From: "Thomas Tuttle" <ttuttle@google.com>
To: mpm@selenic.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] pagemap: Return map count, not reference count, in /proc/kpagecount. (v2 of series)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since pagemap is all about examining pages mapped into processes' memory
spaces, it makes sense for kpagecount to return the map counts, not the
reference counts.

Signed-off-by: Thomas Tuttle
---
 fs/proc/proc_misc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 32dc14c..5a16090 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -726,7 +726,7 @@ static ssize_t kpagecount_read(struct file *file,
char __user *buf,
                if (!ppage)
                        pcount = 0;
                else
-                       pcount = atomic_read(&ppage->_count);
+                       pcount = page_mapcount(ppage);

                if (put_user(pcount, out++)) {
                        ret = -EFAULT;
--
1.5.3.6
