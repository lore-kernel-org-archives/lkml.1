Return-Path: <linux-kernel-owner+w=401wt.eu-S1765631AbYEHRo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765631AbYEHRo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbYEHRnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:43:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760646AbYEHRnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:43:12 -0400
Date: Thu, 8 May 2008 10:42:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Williams <dan.j.williams@intel.com>, Neil Brown <neilb@suse.de>
Subject: [patch 03/16] md: fix use after free when removing rdev via sysfs
Message-ID: <20080508174200.GD855@suse.de>
References: <20080508173436.454278564@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="md-fix-use-after-free-when-removing-rdev-via-sysfs.patch"
In-Reply-To: <20080508174122.GA855@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Dan Williams <dan.j.williams@intel.com>

commit: 6a51830e14529063cb2685921e1177d9af50e49a upstream

rdev->mddev is no longer valid upon return from entry->store() when the
'remove' command is given.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2096,7 +2096,7 @@ rdev_attr_store(struct kobject *kobj, st
 			rv = -EBUSY;
 		else
 			rv = entry->store(rdev, page, length);
-		mddev_unlock(rdev->mddev);
+		mddev_unlock(mddev);
 	}
 	return rv;
 }

-- 
