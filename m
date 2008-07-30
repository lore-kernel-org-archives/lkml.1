Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbYGaAD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbYGaAD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbYGaADU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:03:20 -0400
Received: from ns2.suse.de ([195.135.220.15]:35808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbYGaADT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:03:19 -0400
Date: Wed, 30 Jul 2008 16:57:36 -0700
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
       alan@lxorguk.ukuu.org.uk, Karl Beldan <karl.beldan@gmail.com>,
       Eric Miao <eric.miao@marvell.com>, Pierre Ossman <drzeus@drzeus.cx>
Subject: [patch 01/62] pxamci: trivial fix of DMA alignment register bit
	clearing
Message-ID: <20080730235736.GA12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pxamci-trivial-fix-of-dma-alignment-register-bit-clearing.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Karl Beldan <karl.beldan@gmail.com>

commit 4fe16897c59882420d66f2d503106653d026ed6c upstream

Signed-off-by: Karl Beldan <karl.beldan@gmail.com>
Acked-by: Eric Miao <eric.miao@marvell.com>
Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/pxamci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -177,7 +177,7 @@ static void pxamci_setup_data(struct pxa
 	if (dalgn)
 		DALGN |= (1 << host->dma);
 	else
-		DALGN &= (1 << host->dma);
+		DALGN &= ~(1 << host->dma);
 	DDADR(host->dma) = host->sg_dma;
 	DCSR(host->dma) = DCSR_RUN;
 }

-- 
