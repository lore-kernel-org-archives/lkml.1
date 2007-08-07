Return-Path: <linux-kernel-owner+w=401wt.eu-S937294AbXHGVYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937294AbXHGVYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965118AbXHGU4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:56:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59883 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965108AbXHGU4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:56:22 -0400
Date: Tue, 7 Aug 2007 13:48:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Milan Broz <mbroz@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.22.2 review 70/84] dm raid1: fix status
Message-ID: <20070807204839.GT23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm-raid1-fix-status.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Milan Broz <mbroz@redhat.com>

Fix mirror status line broken in dm-log-report-fault-status.patch:
  - space missing between two words
  - placeholder ("0") required for compatibility with a subsequent patch
  - incorrect offset parameter

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-raid1.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1288,12 +1288,12 @@ static int mirror_status(struct dm_targe
 		for (m = 0; m < ms->nr_mirrors; m++)
 			DMEMIT("%s ", ms->mirror[m].dev->name);
 
-		DMEMIT("%llu/%llu",
+		DMEMIT("%llu/%llu 0 ",
 			(unsigned long long)ms->rh.log->type->
 				get_sync_count(ms->rh.log),
 			(unsigned long long)ms->nr_regions);
 
-		sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
+		sz += ms->rh.log->type->status(ms->rh.log, type, result+sz, maxlen-sz);
 
 		break;
 

-- 
