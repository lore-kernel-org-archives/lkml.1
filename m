Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170Ab0AZXsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab0AZXsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060Ab0AZXsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:48:36 -0500
Received: from kroah.org ([198.145.64.141]:35487 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906Ab0AZXoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:13 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:31 2010
Message-Id: <20100126233931.492407523@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [81/98] UBI: fix memory leak in update path
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit ebddd63b74dcf1cb676d14328d5852f1fee19a8a upstream.

When truncating an UBI volume, UBI should allocates a PEB-sized
buffer but does not release it, which leads to memory leaks.
This patch fixes the issue.

Reported-by: Marek Skuczynski <mareksk7@gmail.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Tested-by: Marek Skuczynski <mareksk7@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/ubi/upd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/ubi/upd.c
+++ b/drivers/mtd/ubi/upd.c
@@ -155,6 +155,7 @@ int ubi_start_update(struct ubi_device *
 		if (err)
 			return err;
 		vol->updating = 0;
+		return 0;
 	}
 
 	vol->upd_buf = vmalloc(ubi->leb_size);


