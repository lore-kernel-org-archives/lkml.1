Return-Path: <linux-kernel-owner+w=401wt.eu-S1760977AbZCNAf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977AbZCNAf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbZCNATW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:22 -0400
Received: from kroah.org ([198.145.64.141]:47143 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753538AbZCNATK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:46 2009
Message-Id: <20090314000746.548541566@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:58 -0700
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
       alan@lxorguk.ukuu.org.uk, Will Newton <will.newton@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 50/96] mtd_dataflash: fix probing of AT45DB321C chips.
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=mtd_dataflash-fix-probing-of-at45db321c-chips.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Will Newton <will.newton@gmail.com>

commit 229cc58ba2b5a83b0b55764c6cb98695c106238a upstream.

Commit 771999b65f79264acde4b855e5d35696eca5e80c ("[MTD] DataFlash: bugfix,
binary page sizes now handled") broke support for probing AT45DB321C flash
chips.  These chips do not support the "page size" status bit, so if we
match the JEDEC id return early.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Will Newton <will.newton@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/devices/mtd_dataflash.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -628,7 +628,8 @@ static struct flash_info *__devinit jede
 					if (!(info->flags & IS_POW2PS))
 						return info;
 				}
-			}
+			} else
+				return info;
 		}
 	}
 


