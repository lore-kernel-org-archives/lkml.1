Return-Path: <linux-kernel-owner+w=401wt.eu-S932171AbZAOUGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbZAOUGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765675AbZAOUAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:31 -0500
Received: from kroah.org ([198.145.64.141]:48804 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762950AbZAOUAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:24 -0500
Date: Thu, 15 Jan 2009 11:57:36 -0800
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
Subject: [patch 11/94] tx493[89]ide: Fix length for __ide_flush_dcache_range
Message-ID: <20090115195736.GK14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tx493ide-fix-length-for-__ide_flush_dcache_range.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

commit f26f6ceacaaf017a677138cbca7ab076b565ca87 upstream.

This fixes data corruption on PIO mode.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: sshtylyov@ru.mvista.com
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/tx4938ide.c |    4 ++--
 drivers/ide/tx4939ide.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -181,7 +181,7 @@ static void tx4938ide_input_data_swap(id
 
 	while (count--)
 		*ptr++ = cpu_to_le16(__raw_readw((void __iomem *)port));
-	__ide_flush_dcache_range((unsigned long)buf, count * 2);
+	__ide_flush_dcache_range((unsigned long)buf, roundup(len, 2));
 }
 
 static void tx4938ide_output_data_swap(ide_drive_t *drive, struct request *rq,
@@ -195,7 +195,7 @@ static void tx4938ide_output_data_swap(i
 		__raw_writew(le16_to_cpu(*ptr), (void __iomem *)port);
 		ptr++;
 	}
-	__ide_flush_dcache_range((unsigned long)buf, count * 2);
+	__ide_flush_dcache_range((unsigned long)buf, roundup(len, 2));
 }
 
 static const struct ide_tp_ops tx4938ide_tp_ops = {
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -558,7 +558,7 @@ static void tx4939ide_input_data_swap(id
 
 	while (count--)
 		*ptr++ = cpu_to_le16(__raw_readw((void __iomem *)port));
-	__ide_flush_dcache_range((unsigned long)buf, count * 2);
+	__ide_flush_dcache_range((unsigned long)buf, roundup(len, 2));
 }
 
 static void tx4939ide_output_data_swap(ide_drive_t *drive, struct request *rq,
@@ -572,7 +572,7 @@ static void tx4939ide_output_data_swap(i
 		__raw_writew(le16_to_cpu(*ptr), (void __iomem *)port);
 		ptr++;
 	}
-	__ide_flush_dcache_range((unsigned long)buf, count * 2);
+	__ide_flush_dcache_range((unsigned long)buf, roundup(len, 2));
 }
 
 static const struct ide_tp_ops tx4939ide_tp_ops = {

