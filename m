Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbZGQUTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbZGQUTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbZGQUTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:19:49 -0400
Received: from kroah.org ([198.145.64.141]:43112 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958AbZGQUTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:12:33 2009
Message-Id: <20090717201232.906038306@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:09:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [patch 13/24] dma-debug: fix off-by-one error in overlap function
References: <20090717200851.907421303@mini.kroah.org>
Content-Disposition: inline; filename=dma-debug-fix-off-by-one-error-in-overlap-function.patch
In-Reply-To: <20090717201639.GA14209@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit c79ee4e466dd12347f112e2af306dca35198458f upstream.

This patch fixes a bug in the overlap function which returned true if
one region ends exactly before the second region begins. This is no
overlap but the function returned true in that case.

Reported-by: Andrew Randrianasulu <randrik@mail.ru>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/dma-debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -599,7 +599,7 @@ static inline bool overlap(void *addr, u
 
 	return ((addr >= start && addr < end) ||
 		(addr2 >= start && addr2 < end) ||
-		((addr < start) && (addr2 >= end)));
+		((addr < start) && (addr2 > end)));
 }
 
 static void check_for_illegal_area(struct device *dev, void *addr, u64 size)


