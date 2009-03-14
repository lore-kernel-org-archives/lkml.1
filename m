Return-Path: <linux-kernel-owner+w=401wt.eu-S1760546AbZCNArl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546AbZCNArl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZCNAUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:20:00 -0400
Received: from kroah.org ([198.145.64.141]:35029 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753861AbZCNATo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:44 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:51 2009
Message-Id: <20090314000751.654818834@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:31 -0700
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
Subject: [patch 83/96] ide-iops: fix odd-length ATAPI PIO transfers
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=ide-iops-fix-odd-length-atapi-pio-transfers.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -325,6 +325,8 @@ void ide_output_data(ide_drive_t *drive,
 	u8 io_32bit = drive->io_32bit;
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 
+	len++;
+
 	if (io_32bit) {
 		unsigned long uninitialized_var(flags);
 


