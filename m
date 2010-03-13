Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936317Ab0CMBN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:13:29 -0500
Received: from kroah.org ([198.145.64.141]:46641 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935332Ab0CMAal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:41 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:06 2010
Message-Id: <20100313002706.353713088@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:25:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joshua Roys <joshua.roys@gtri.gatech.edu>,
       Paul Moore <paul.moore@hp.com>, James Morris <jmorris@namei.org>
Subject: [013/145] netlabel: fix export of SELinux categories > 127
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Joshua Roys <joshua.roys@gtri.gatech.edu>

commit c36f74e67fa12202dbcb4ad92c5ac844f9d36b98 upstream.

This fixes corrupted CIPSO packets when SELinux categories greater than 127
are used.  The bug occured on the second (and later) loops through the
while; the inner for loop through the ebitmap->maps array used the same
index as the NetLabel catmap->bitmap array, even though the NetLabel bitmap
is twice as long as the SELinux bitmap.

Signed-off-by: Joshua Roys <joshua.roys@gtri.gatech.edu>
Acked-by: Paul Moore <paul.moore@hp.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/selinux/ss/ebitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/selinux/ss/ebitmap.c
+++ b/security/selinux/ss/ebitmap.c
@@ -128,7 +128,7 @@ int ebitmap_netlbl_export(struct ebitmap
 			cmap_idx = delta / NETLBL_CATMAP_MAPSIZE;
 			cmap_sft = delta % NETLBL_CATMAP_MAPSIZE;
 			c_iter->bitmap[cmap_idx]
-				|= e_iter->maps[cmap_idx] << cmap_sft;
+				|= e_iter->maps[i] << cmap_sft;
 		}
 		e_iter = e_iter->next;
 	}


