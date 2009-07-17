Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbZGQUlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbZGQUlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757057AbZGQUlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:41:01 -0400
Received: from kroah.org ([198.145.64.141]:50659 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756911AbZGQUk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:40:59 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:38:24 2009
Message-Id: <20090717203824.780928687@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:37:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhang Rui <rui.zhang@intel.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 6/8] kernel/resource.c: fix sign extension in reserve_setup()
References: <20090717203718.637372453@mini.kroah.org>
Content-Disposition: inline; filename=kernel-resource.c-fix-sign-extension-in-reserve_setup.patch
In-Reply-To: <20090717203935.GA5641@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit 8bc1ad7dd301b7ca7454013519fa92e8c53655ff upstream.

When the 32-bit signed quantities get assigned to the u64 resource_size_t,
they are incorrectly sign-extended.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13253
Addresses http://bugzilla.kernel.org/show_bug.cgi?id=9905

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reported-by: Leann Ogasawara <leann@ubuntu.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Reported-by: <pablomme@googlemail.com>
Tested-by: <pablomme@googlemail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -741,7 +741,7 @@ static int __init reserve_setup(char *st
 	static struct resource reserve[MAXRESERVE];
 
 	for (;;) {
-		int io_start, io_num;
+		unsigned int io_start, io_num;
 		int x = reserved;
 
 		if (get_option (&str, &io_start) != 2)


