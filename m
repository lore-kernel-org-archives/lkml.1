Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbYCHCXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbYCHCXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 21:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756364AbYCHCX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 21:23:27 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:19134 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754727AbYCHCX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 21:23:27 -0500
Date: Sat, 8 Mar 2008 02:23:21 +0000
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH,TRIVIAL] AF_UNIX, accept() and addrlen
Message-ID: <20080308022321.GC5853@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Accept and getpeername are supposed to return the amount of bytes
written in the returned address.  However, on unnamed sockets, only
sizeof(short) is returned, while a 0 is put in the sun_path member.
This patch adds 1 for that additional byte.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

--- linux/net/unix/af_unix.c.orig	2008-03-08 02:17:40.000000000 +0000
+++ linux/net/unix/af_unix.c	2008-03-08 02:17:54.000000000 +0000
@@ -1274,7 +1274,7 @@ static int unix_getname(struct socket *s
 	if (!u->addr) {
 		sunaddr->sun_family = AF_UNIX;
 		sunaddr->sun_path[0] = 0;
-		*uaddr_len = sizeof(short);
+		*uaddr_len = sizeof(short) + 1;
 	} else {
 		struct unix_address *addr = u->addr;
 
