Return-Path: <linux-kernel-owner+w=401wt.eu-S1752150AbXFKMU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbXFKMU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 08:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbXFKMUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 08:20:19 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52937 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750774AbXFKMUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 08:20:17 -0400
Date: Mon, 11 Jun 2007 14:17:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: B.Steinbrink@gmx.de, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: fix oops on cat /dev/snapshot
Message-ID: <20070611121716.GA1904@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What /dev/snapshot is simply cat-ed -- without ioctls used in normal
operation -- it oopses. This one should fix it.

Signed-off-by: Pavel Machek <pavel@suse.cz>

--- clean-mm/kernel/power/user.c	2007-06-09 16:18:12.000000000 +0200
+++ linux-mm/kernel/power/user.c	2007-06-11 14:06:19.000000000 +0200
@@ -99,6 +99,8 @@
 	ssize_t res;
 
 	data = filp->private_data;
+	if (!data->ready)
+		return -EINVAL;
 	res = snapshot_read_next(&data->handle, count);
 	if (res > 0) {
 		if (copy_to_user(buf, data_of(data->handle), res))

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
