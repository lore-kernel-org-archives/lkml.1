Return-Path: <linux-kernel-owner+w=401wt.eu-S1764046AbZCNBiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764046AbZCNBiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbZCNBUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:54 -0400
Received: from kroah.org ([198.145.64.141]:35268 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753780AbZCNBUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:33 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:39 2009
Message-Id: <20090314011038.947763527@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:28 -0700
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
Subject: [patch 051/114] mtd_dataflash: fix probing of AT45DB321C chips.
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=mtd_dataflash-fix-probing-of-at45db321c-chips.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

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
@@ -815,7 +815,8 @@ static struct flash_info *__devinit jede
 					if (!(info->flags & IS_POW2PS))
 						return info;
 				}
-			}
+			} else
+				return info;
 		}
 	}
 


