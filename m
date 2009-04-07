Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbZDGW52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbZDGW52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 18:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbZDGW5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 18:57:17 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:38882 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZDGW5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 18:57:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=wGwwnL9bNpNN3b9b9YjKuc6u0R22k+sgQstuJQk7sQOPOZzjWwf+dO2+XrycYM9dUN
         1rDZuDQStQSkaWMDNOzQJhOGCSgrvkC4LJ7nRNkH8Ouvj53MA8bWBcvrPQ/q2bvf6Wcy
         ghCj44sy3mY2+nLb3ahi74h1DnLX1Yo2Yn7Uo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [git pull] IDE updates part 4
Date: Wed, 8 Apr 2009 00:59:43 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-10247-g8e2c4f2-dirty; KDE/4.2.1; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200904080020.43175.bzolnier@gmail.com> <49DBD3EE.3010601@garzik.org>
In-Reply-To: <49DBD3EE.3010601@garzik.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904080059.43698.bzolnier@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 April 2009 00:30:06 Jeff Garzik wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > - TRIM support ("discard" operation for SSD devices)
> >   (David Woodhouse & Matthew Wilcox)
> > 
> >   Since this is a new feature and hasn't seen much testing with production
> >   devices it is not enabled by default yet (requires use of "ide_core.trim=1"
> >   kernel parameter).
> 
> 
> As noted by Matthew, this appears to be missing the requisite block support?

I had this nice feeling of missing some detail but I didn't have time to think
about it too much since I was rushing to get all changes integrated for the last
pre -rc1 pull request.  Now it is late due to premature TRIM support... :)

However it is not all that bad since we can just leave things as they are for
now and disable TRIM support until block changes get merged with patch below.

[ I added it to the pull request.  Sorry Linus, this is the best I can do ATM
  before failing asleep -- if this is not acceptable I'll revisit pull request
  tomorrow. ]

>From 316f69abbb73595d0950c56c3b293534056d112e Mon Sep 17 00:00:00 2001
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Wed, 8 Apr 2009 00:42:59 +0200
Subject: [PATCH] ide: disable TRIM until block layer support gets merged

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 7b7cd76..4ed66d0 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -178,11 +178,14 @@ EXPORT_SYMBOL_GPL(ide_pci_clk);
 module_param_named(pci_clock, ide_pci_clk, int, 0);
 MODULE_PARM_DESC(pci_clock, "PCI bus clock frequency (in MHz)");
 
+/* needs block layer support */
+#if 0
 int ide_trim = 0;
 EXPORT_SYMBOL_GPL(ide_trim);
 
 module_param_named(trim, ide_trim, int, 0);
 MODULE_PARM_DESC(trim, "TRIM support (0=off, 1=on)");
+#endif
 
 static int ide_set_dev_param_mask(const char *s, struct kernel_param *kp)
 {
-- 
1.6.0.6

