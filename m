Return-Path: <linux-kernel-owner+w=401wt.eu-S1764386AbZCNBmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764386AbZCNBmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbZCNBVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:04 -0400
Received: from kroah.org ([198.145.64.141]:35383 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754141AbZCNBUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:43 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:40 2009
Message-Id: <20090314011040.466541543@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:38 -0700
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
       alan@lxorguk.ukuu.org.uk, Ben Dooks <ben@simtec.co.uk>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: [patch 061/114] mmc: s3cmci: fix s3c2410_dma_config() arguments.
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=mmc-s3cmci-fix-s3c2410_dma_config-arguments.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Dooks <ben@simtec.co.uk>

commit 7c48ed3383bfb2106694807361ec187fe8a4333d upstream.

The s3cmci driver is calling s3c2410_dma_config with incorrect data for
the DCON register.  The S3C2410_DCON_HWTRIG is implicit in the channel
configuration and the device selection of S3C2410_DCON_CH0_SDI is
incorrect as the DMA system may not select channel 0.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Acked-by: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -793,8 +793,7 @@ static void s3cmci_dma_setup(struct s3cmci_host *host,
 			      host->mem->start + host->sdidata);
 
 	if (!setup_ok) {
-		s3c2410_dma_config(host->dma, 4,
-			(S3C2410_DCON_HWTRIG | S3C2410_DCON_CH0_SDI));
+		s3c2410_dma_config(host->dma, 4, 0);
 		s3c2410_dma_set_buffdone_fn(host->dma,
 					    s3cmci_dma_done_callback);
 		s3c2410_dma_setflags(host->dma, S3C2410_DMAF_AUTOSTART);


