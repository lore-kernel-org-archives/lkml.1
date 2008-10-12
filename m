Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbYJLNp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbYJLNp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 09:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYJLNpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 09:45:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:55585 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbYJLNpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 09:45:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=c7EL7DQraHBwKwSRBI/9NtkI22i+4B/5i2ne9Y6rNDcWvAGLXkrpOkJJhVnfvo96Pn
         r/sjwxYcGciT9+C+Vp7vm0j5aCQ5K5KZeU7S5aJM3Ale65Z7gJ0WD6Aff3V2NTLVxELa
         oQWZyyEWrMRNev4Xyb8Fdy2orxgGxXBBkN1Zs=
Message-ID: <fbd277f20810120645g7feb4b85g49211641829e153e@mail.gmail.com>
Date: Sun, 12 Oct 2008 21:45:12 +0800
From: "bibo mao" <bibo.mao@gmail.com>
To: akpm@linux-foundation.org
Subject: [patch 0/1]pat: remove redundant condition check
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On file pat.c, if (start <= entry->start), it also means (start <
entry->end). This patch removes
redundant condition check.

Signed-off-by: bibo.mao@gmail.com
thanks
bibo,mao

------------------------------------------------------
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 2a50e0f..12cac5e 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -305,27 +305,6 @@ int reserve_memtype(u64 start, u64 end, unsigned
long req_type,
 							struct memtype, nd);
 			}
 			break;
-		} else if (start < entry->end) { /* start > entry->start */
-			err = chk_conflict(new, entry, new_type);
-			if (!err) {
-				dprintk("Overlap at 0x%Lx-0x%Lx\n",
-					entry->start, entry->end);
-				cached_entry = list_entry(entry->nd.prev,
-							struct memtype, nd);
-
-				/*
-				 * Move to right position in the linked
-				 * list to add this new entry
-				 */
-				list_for_each_entry_continue(entry,
-							&memtype_list, nd) {
-					if (start <= entry->start) {
-						where = entry->nd.prev;
-						break;
-					}
-				}
-			}
-			break;
 		}
 	}
