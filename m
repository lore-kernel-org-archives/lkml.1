Return-Path: <linux-kernel-owner+w=401wt.eu-S1030900AbXD1CB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030900AbXD1CB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 22:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030910AbXD1CB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 22:01:59 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030900AbXD1CB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 22:01:57 -0400
Date: Fri, 27 Apr 2007 19:01:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>
Cc: <linux-pcmcia@lists.infradead.org>, "lkml" <linux-kernel@vger.kernel.org>,
       "Dominik Brodowski" <linux@dominikbrodowski.net>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: [PATCH] ide-cs: recognize 2GB CompactFlash from Transcend
Message-Id: <20070427190143.d597dd38.akpm@linux-foundation.org>
In-Reply-To: <D7810733513F4840B4EBAAFA64D9C6A4012D6188@stgw002a.ww002.siemens.net>
References: <20070425171533.22efa133.akpm@linux-foundation.org>
	<D7810733513F4840B4EBAAFA64D9C6A4012D6188@stgw002a.ww002.siemens.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 11:21:01 +0200
"Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com> wrote:

> As pointed to by Peter, and also as indicated by a judicious output in
> dmesg, the 4th parameter should be 0x969aa4f2. Please find below the
> corrected patch:
> 
> Signed-off-by: Fabrice Aeschbacher <fabrice.aeschbacher@siemens.com>
> 
> ===================================================================
> --- linux-2.6.20.7-orig/drivers/ide/legacy/ide-cs.c	2007-04-15
> 21:08:02.000000000 +0200
> +++ linux-2.6.20.7/drivers/ide/legacy/ide-cs.c	2007-04-26
> 11:13:13.000000000 +0200
> @@ -399,6 +399,7 @@
>  	PCMCIA_DEVICE_PROD_ID12("TOSHIBA", "MK2001MPL", 0xb4585a1a,
> 0x3489e003),
>  	PCMCIA_DEVICE_PROD_ID1("TRANSCEND    512M   ", 0xd0909443),
>  	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1,
> 0x2a54d4b1),
> +	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1,
> 0x969aa4f2),
>  	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1,
> 0xf54a91c8),
>  	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
>  	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c,
> 0x212bb918),
> ===================================================================

This one-liner is turning into a fiasco.  All the top-posting and
word-wrapped patches aren't helping :(

I presently have two patches.  Please check them.


ide-cs-recognize-2gb-compactflash-from-transcend.patch:


From: "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>

Without the following patch, the kernel does not automatically detect
2GB CompactFlash cards from Transcend.

Signed-off-by: Fabrice Aeschbacher <fabrice.aeschbacher@siemens.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/legacy/ide-cs.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/ide/legacy/ide-cs.c~ide-cs-recognize-2gb-compactflash-from-transcend drivers/ide/legacy/ide-cs.c
--- a/drivers/ide/legacy/ide-cs.c~ide-cs-recognize-2gb-compactflash-from-transcend
+++ a/drivers/ide/legacy/ide-cs.c
@@ -401,6 +401,8 @@ static struct pcmcia_device_id ide_ids[]
 	PCMCIA_DEVICE_PROD_ID12("TOSHIBA", "MK2001MPL", 0xb4585a1a, 0x3489e003),
 	PCMCIA_DEVICE_PROD_ID1("TRANSCEND    512M   ", 0xd0909443),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1, 0x2a54d4b1),
+	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0xf54a91c8),
+	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0x969aa4f2),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1, 0xf54a91c8),
 	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
 	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c, 0x212bb918),
_


Is this really supposed to add a TS2GCF120 entry with the same IDs as
TS4GCF120?





And pata_pcmcia-recognize-2gb-compactflash-from-transcend.patch:

From: "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>

Allow the pata_pcmcia driver to automatically detect 2GB CompactFlash cards
from Transcend.

Signed-off-by: Fabrice Aeschbacher <fabrice.aeschbacher@siemens.com>
Cc: "Peter Stuge" <stuge-linux-pcmcia@cdy.org>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_pcmcia.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/ata/pata_pcmcia.c~pata_pcmcia-recognize-2gb-compactflash-from-transcend drivers/ata/pata_pcmcia.c
--- a/drivers/ata/pata_pcmcia.c~pata_pcmcia-recognize-2gb-compactflash-from-transcend
+++ a/drivers/ata/pata_pcmcia.c
@@ -396,6 +396,7 @@ static struct pcmcia_device_id pcmcia_de
 	PCMCIA_DEVICE_PROD_ID12("TOSHIBA", "MK2001MPL", 0xb4585a1a, 0x3489e003),
 	PCMCIA_DEVICE_PROD_ID1("TRANSCEND    512M   ", 0xd0909443),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1, 0x2a54d4b1),
+	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0x969aa4f2),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1, 0xf54a91c8),
 	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
 	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c, 0x212bb918),
_

