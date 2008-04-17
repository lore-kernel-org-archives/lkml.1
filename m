Return-Path: <linux-kernel-owner+w=401wt.eu-S933833AbYDQB0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933833AbYDQB0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760198AbYDQBJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:09:14 -0400
Received: from sous-sol.org ([216.99.217.87]:58979 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757390AbYDQBJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:09:13 -0400
Message-Id: <20080417010309.044818777@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:25 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ingo van Lil <inguin@gmx.de>, Joern Engel <joern@lazybastard.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: mtd: memory corruption in block2mtd.c
Content-Disposition: inline; filename=mtd-memory-corruption-in-block2mtd.c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Ingo van Lil <inguin@gmx.de>

upstream commit: 2875fb65f8e40401c4b781ebc5002df10485f635

The block2mtd driver (drivers/mtd/devices/block2mtd.c) will kfree an on-stack
pointer when handling an invalid argument line (e.g.
block2mtd=/dev/loop0,xxx).

The kfree was added some time ago when "name" was dynamically allocated.

Signed-off-by: Ingo van Lil <inguin@gmx.de>
Acked-by: Joern Engel <joern@lazybastard.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/mtd/devices/block2mtd.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -408,7 +408,6 @@ static int block2mtd_setup2(const char *
 	if (token[1]) {
 		ret = parse_num(&erase_size, token[1]);
 		if (ret) {
-			kfree(name);
 			parse_err("illegal erase size");
 		}
 	}

-- 
