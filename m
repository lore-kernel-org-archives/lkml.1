Return-Path: <linux-kernel-owner+w=401wt.eu-S964861AbZIEAYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964861AbZIEAYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964837AbZIEAYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:24:24 -0400
Received: from kroah.org ([198.145.64.141]:42300 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964805AbZIEAV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:27 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:57 2009
Message-Id: <20090905001456.912461822@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Julien Tinnes <julien@cr0.org>, Tavis Ormandy <taviso@sdf.lonestar.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 62/71] ipv4: make ip_append_data() handle NULL routing table
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=ipv4-make-ip_append_data-handle-null-routing-table.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Julien TINNES <julien@cr0.org>

commit 788d908f2879a17e5f80924f3da2e23f1034482d upstream.

Add a check in ip_append_data() for NULL *rtp to prevent future bugs in
callers from being exploitable.

Signed-off-by: Julien Tinnes <julien@cr0.org>
Signed-off-by: Tavis Ormandy <taviso@sdf.lonestar.org>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/ip_output.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -814,6 +814,8 @@ int ip_append_data(struct sock *sk,
 			inet->cork.addr = ipc->addr;
 		}
 		rt = *rtp;
+		if (unlikely(!rt))
+			return -EFAULT;
 		/*
 		 * We steal reference to this route, caller should not release it
 		 */


