Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbZGHCMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbZGHCMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 22:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbZGHCMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 22:12:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:49130 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZGHCMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 22:12:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=U60TD0XNMuEw80uLEDvW8DWMg1lN9TDazxq6Gw4KH4eTGKx+MPXyk/BcvuUMOXZJGT
         jU/ReLp67USkA4zWOsPFlU5EOzC6wyr67fa7PHZVm0ryUF7iK0CJw0VvylNIAn8d2nuK
         J6jK0Cu+JSgRTd1JNqQAMhpLO0V6Pt1jVLX10=
Subject: [PATCH v2] vmalloc.c: fix double error checking
From: "Figo.zhang" <figo1802@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <1246983201.2597.13.camel@myhost>
References: <1246983201.2597.13.camel@myhost>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 10:11:57 +0800
Message-Id: <1247019117.2573.3.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it is no need for double error checking.

in v2, if vmap_pud_ranger() error, directly return err. 

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---
mm/vmalloc.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f8189a4..ed6b4b9 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -168,11 +168,9 @@ static int vmap_page_range_noflush(unsigned long
start, unsigned long end,
 		next = pgd_addr_end(addr, end);
 		err = vmap_pud_range(pgd, addr, next, prot, pages, &nr);
 		if (err)
-			break;
+			return err;
 	} while (pgd++, addr = next, addr != end);
 
-	if (unlikely(err))
-		return err;
 	return nr;
 }
 


