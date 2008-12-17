Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752184AbYLQVk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbYLQVk3 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 16:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYLQVkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 16:40:12 -0500
Received: from gw.goop.org ([64.81.55.164]:32925 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbYLQVkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 16:40:11 -0500
Message-ID: <494971B6.6040508@goop.org>
Date: Wed, 17 Dec 2008 13:40:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@elte.hu, viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, alex.zeffertt@eu.citrix.com,
        Ian.Campbell@citrix.com
Subject: Re: [PATCH UPDATED] xen/xenfs: fix xenbus message reads
References: <49480F39.2010102@goop.org> <20081216125425.30524946.akpm@linux-foundation.org> <49496E17.2010703@goop.org>
In-Reply-To: <49496E17.2010703@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compute the remaining data size properly.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/xenfs/xenbus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/drivers/xen/xenfs/xenbus.c
+++ b/drivers/xen/xenfs/xenbus.c
@@ -132,7 +132,7 @@
 	rb = list_entry(u->read_buffers.next, struct read_buffer, list);
 	i = 0;
 	while (i < len) {
-		unsigned sz = min((unsigned)len - i, rb->cons - rb->len);
+		unsigned sz = min((unsigned)len - i, rb->len - rb->cons);
 
 		ret = copy_to_user(ubuf + i, &rb->msg[rb->cons], sz);
 


