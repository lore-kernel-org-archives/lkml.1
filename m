Return-Path: <linux-kernel-owner+w=401wt.eu-S932586AbZAOUHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbZAOUHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765834AbZAOUAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:33 -0500
Received: from kroah.org ([198.145.64.141]:48811 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762828AbZAOUAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:25 -0500
Date: Thu, 15 Jan 2009 11:57:38 -0800
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
       alan@lxorguk.ukuu.org.uk, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       sshtylyov@ru.mvista.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 12/94] tx4939ide: Do not use zero count PRD entry
Message-ID: <20090115195738.GL14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tx4939ide-do-not-use-zero-count-prd-entry.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

commit a0fce792b55b260589c3d77293a224e84395ec07 upstream.

This fixes data corruption on some heavy load.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: sshtylyov@ru.mvista.com
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/tx4939ide.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -259,6 +259,12 @@ static int tx4939ide_build_dmatable(ide_
 			bcount = 0x10000 - (cur_addr & 0xffff);
 			if (bcount > cur_len)
 				bcount = cur_len;
+			/*
+			 * This workaround for zero count seems required.
+			 * (standard ide_build_dmatable do it too)
+			 */
+			if ((bcount & 0xffff) == 0x0000)
+				bcount = 0x8000;
 			*table++ = bcount & 0xffff;
 			*table++ = cur_addr;
 			cur_addr += bcount;

