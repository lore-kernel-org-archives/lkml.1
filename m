Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbZGJCG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbZGJCG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 22:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbZGJCGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 22:06:51 -0400
Received: from mail-px0-f193.google.com ([209.85.216.193]:60776 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbZGJCGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 22:06:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=bss9aMhX/wSlHPDYh8uUZK5SoVd4jl8T6yxhoWrrS6ZpTN9oUKKy7UtGysR0XQxmYK
         AqM86+Z7B/9NTZjdlK1vuCfClpQbW2rHjJasjCdIQZYRVDkU34xJSiRJ2dPoeRmfj9Tj
         UjlPlZ/sKLrhhE46ZicLoDoklaldwzGikDQd4=
Subject: [PATCH] vmalloc.c: fix lose num_physpages checking
From: "Figo.zhang" <figo1802@gmail.com>
To: Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 10:06:44 +0800
Message-Id: <1247191604.2572.3.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__get_vm_area_node() lose size (physpages limit) checking, it be called by
__get_vm_area() that some drivers called it directly.

Signed-off-by: Figo.zhang  <figo1802@gmail.com>
--- 
mm/vmalloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f8189a4..99f3aea 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1144,7 +1144,7 @@ static struct vm_struct *__get_vm_area_node(unsigned long size,
 	}
 
 	size = PAGE_ALIGN(size);
-	if (unlikely(!size))
+	if (unlikely(!size || (size >> PAGE_SHIFT) > num_physpages))
 		return NULL;
 
 	area = kmalloc_node(sizeof(*area), gfp_mask & GFP_RECLAIM_MASK, node);


