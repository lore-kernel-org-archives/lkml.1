Return-Path: <linux-kernel-owner+w=401wt.eu-S1760290AbYARLDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbYARLDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 06:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760493AbYARLC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 06:02:59 -0500
Received: from ns2.suse.de ([195.135.220.15]:34765 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760455AbYARLC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 06:02:58 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 18 Jan 2008 22:02:51 +1100
Message-Id: <1080118110251.30514@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 004 of 4] md: Fix an occasional deadlock in raid5 - FIX
References: <20080118215531.30136.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(This should be merged with fix-occasional-deadlock-in-raid5.patch)

As we don't call stripe_handle in make_request any more, we need to
clear STRIPE_DELAYED to (previously done by stripe_handle) to ensure
that we test if the stripe still needs to be delayed or not.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    1 +
 1 file changed, 1 insertion(+)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-01-18 14:58:55.000000000 +1100
+++ ./drivers/md/raid5.c	2008-01-18 14:59:53.000000000 +1100
@@ -3549,6 +3549,7 @@ static int make_request(struct request_q
 			}
 			finish_wait(&conf->wait_for_overlap, &w);
 			set_bit(STRIPE_HANDLE, &sh->state);
+			clear_bit(STRIPE_DELAYED, &sh->state);
 			release_stripe(sh);
 		} else {
 			/* cannot get stripe for read-ahead, just give-up */
