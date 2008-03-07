Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbYCGFBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbYCGFBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 00:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760220AbYCGFAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 00:00:54 -0500
Received: from ns1.suse.de ([195.135.220.2]:41054 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759940AbYCGFAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 00:00:52 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 7 Mar 2008 16:00:47 +1100
Message-Id: <1080307050047.26113@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 001 of 2] md: Fix formatting error in /proc/mdstat.
References: <20080307155754.25976.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If an md array is "auto-read-only", then this appears in /proc/mdstat
as

   /dev/md0: active(auto-read-only)

whereas if it is truely readonly, it appears as

   /dev/md0: active (read-only)

The difference being a space. 

One program known to parse this file expects the space and gets badly
confused.  It will be fixed, but it would be best if what the kernel
generates is more consistent too.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-03-07 15:51:24.000000000 +1100
+++ ./drivers/md/md.c	2008-03-07 15:52:21.000000000 +1100
@@ -5149,7 +5149,7 @@ static int md_seq_show(struct seq_file *
 			if (mddev->ro==1)
 				seq_printf(seq, " (read-only)");
 			if (mddev->ro==2)
-				seq_printf(seq, "(auto-read-only)");
+				seq_printf(seq, " (auto-read-only)");
 			seq_printf(seq, " %s", mddev->pers->name);
 		}
 
