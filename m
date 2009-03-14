Return-Path: <linux-kernel-owner+w=401wt.eu-S1765546AbZCNB7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765546AbZCNB7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbZCNBV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:56 -0400
Received: from kroah.org ([198.145.64.141]:35832 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754964AbZCNBV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:27 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:46 2009
Message-Id: <20090314011046.651474624@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:11:20 -0700
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
       alan@lxorguk.ukuu.org.uk, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 103/114] ide-iops: fix odd-length ATAPI PIO transfers
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=ide-iops-fix-odd-length-atapi-pio-transfers.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit a509538d4fb4f99cdf0a095213d57cc3b2347615 upstream.

Commit 9567b349f7e7dd7e2483db99ee8e4a6fe0caca38 (ide: merge ->atapi_*put_bytes
and ->ata_*put_data methods) introduced a regression  WRT the odd-length ATAPI
PIO transfers -- the final word didn't get written (causing command timeouts).

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-iops.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -324,6 +324,8 @@ void ide_output_data(ide_drive_t *drive,
 	u8 io_32bit = drive->io_32bit;
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 
+	len++;
+
 	if (io_32bit) {
 		unsigned long uninitialized_var(flags);
 


