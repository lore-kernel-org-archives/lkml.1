Return-Path: <linux-kernel-owner+w=401wt.eu-S1765917AbYHDViu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765917AbYHDViu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765579AbYHDVhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:37:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:49986 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764424AbYHDVhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:37:08 -0400
Date: Mon, 4 Aug 2008 14:30:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Nikanth Karthikesan <knikanth@suse.de>
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
       alan@lxorguk.ukuu.org.uk, Neil Brown <neilb@suse.de>,
       Oliver Pinter <oliver.pntr@gmail.com>
Subject: [patch 10/25] linear: correct disk numbering error check
Message-ID: <20080804213018.GJ8014@suse.de>
References: <20080804203506.816201392@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="linear-correct-disk-numbering-error-check.patch"
In-Reply-To: <20080804212725.GA7944@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Nikanth Karthikesan <knikanth@novell.com>

[ Upstream commit 13864515f7bf6cabd60e63c62e09d311386ae1f1 ]

From: "Nikanth Karthikesan" <knikanth@novell.com>

Correct disk numbering problem check.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Neil Brown <neilb@suse.de>
CC: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/linear.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -126,7 +126,7 @@ static linear_conf_t *linear_conf(mddev_
 		int j = rdev->raid_disk;
 		dev_info_t *disk = conf->disks + j;
 
-		if (j < 0 || j > raid_disks || disk->rdev) {
+		if (j < 0 || j >= raid_disks || disk->rdev) {
 			printk("linear: disk numbering problem. Aborting!\n");
 			goto out;
 		}

-- 
