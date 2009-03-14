Return-Path: <linux-kernel-owner+w=401wt.eu-S1764426AbZCNBmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764426AbZCNBmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbZCNBVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:06 -0400
Received: from kroah.org ([198.145.64.141]:35392 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753437AbZCNBUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:44 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:40 2009
Message-Id: <20090314011040.596765924@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:39 -0700
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
       alan@lxorguk.ukuu.org.uk, Yi Li <yi.li@analog.com>,
       Bryan Wu <cooloney@kernel.org>, Pierre Ossman <drzeus@drzeus.cx>
Subject: [patch 062/114] MMC: fix bug - SDHC card capacity not correct
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=mmc-fix-bug-sdhc-card-capacity-not-correct.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yi Li <yi.li@analog.com>

commit 444122fd58fdc83c96877a92b3f6288cafddb08d upstream.

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/card/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -514,7 +514,7 @@ static int mmc_blk_probe(struct mmc_card
 	if (err)
 		goto out;
 
-	string_get_size(get_capacity(md->disk) << 9, STRING_UNITS_2,
+	string_get_size((u64)get_capacity(md->disk) << 9, STRING_UNITS_2,
 			cap_str, sizeof(cap_str));
 	printk(KERN_INFO "%s: %s %s %s %s\n",
 		md->disk->disk_name, mmc_card_id(card), mmc_card_name(card),


