Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbZKFWJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbZKFWJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759916AbZKFWFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:05:51 -0500
Received: from kroah.org ([198.145.64.141]:39753 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113AbZKFWFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:05:49 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:51 2009
Message-Id: <20091106215951.589569188@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>
Subject: [12/30] ray_cs: Fix copy_from_user handling
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=ray_cs-fix-copy_from_user-handling.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Cox <alan@linux.intel.com>

commit 575c9ed7798218dc923f319c0d78f0c25ca506b9 upstream.

I've not touched the other stuff here but the word "locking" comes to mind.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ray_cs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2758,7 +2758,7 @@ static void raycs_write(const char *name
 static int write_essid(struct file *file, const char __user *buffer, unsigned long count, void *data)
 {
 	static char proc_essid[33];
-	int len = count;
+	unsigned int len = count;
 
 	if (len > 32)
 		len = 32;


