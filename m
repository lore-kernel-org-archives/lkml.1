Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbYKLAb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbYKLAb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYKLA0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:18 -0500
Received: from kroah.org ([198.145.64.141]:42206 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753397AbYKLA0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:16 -0500
Date: Tue, 11 Nov 2008 16:23:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Thomas Backlund <tmb@mandriva.org>,
       George Spelvin <linux@horizon.com>, NeilBrown <neilb@suse.de>
Subject: [patch 14/49] md: fix bug in raid10 recovery.
Message-ID: <20081112002322.GO10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="md-fix-bug-in-raid10-recovery.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Neil Brown <neilb@suse.de>

commit a53a6c85756339f82ff19e001e90cfba2d6299a8 upstream

Adding a spare to a raid10 doesn't cause recovery to start.
This is due to an silly type in
  commit 6c2fce2ef6b4821c21b5c42c7207cb9cf8c87eda
and so is a bug in 2.6.27 and .28-rc.

Thanks to Thomas Backlund for bisecting to find this.

Cc: Thomas Backlund <tmb@mandriva.org>
Cc: George Spelvin <linux@horizon.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1132,7 +1132,7 @@ static int raid10_add_disk(mddev_t *mdde
 	if (!enough(conf))
 		return -EINVAL;
 
-	if (rdev->raid_disk)
+	if (rdev->raid_disk >= 0)
 		first = last = rdev->raid_disk;
 
 	if (rdev->saved_raid_disk >= 0 &&

-- 
