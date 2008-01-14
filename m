Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbYANQkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbYANQkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYANQkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:40:35 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:41145 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751469AbYANQke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:40:34 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Mike Galbraith <efault@gmx.de>
Subject: Re: 2.6.24-rc7-rt1
Date: Mon, 14 Jan 2008 20:39:39 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
References: <1200250801.9190.7.camel@localhost.localdomain> <Pine.LNX.4.58.0801131552350.10093@gandalf.stny.rr.com> <1200299260.4665.17.camel@homer.simson.net>
In-Reply-To: <1200299260.4665.17.camel@homer.simson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801142039.42463.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

14 Oca 2008 Pts tarihinde, Mike Galbraith şunları yazmıştı: 
> btw, CONFIG_INTEL_IOATDMA compile booboo
> 
>   CC      drivers/dma/ioat_dma.o
> drivers/dma/ioat_dma.c: In function ‘ioat1_tx_submit’:
> drivers/dma/ioat_dma.c:300: error: too few arguments to function ‘__list_splice’
> make[2]: *** [drivers/dma/ioat_dma.o] Error 1

Following seems solves this issue;

Index: linux-2.6.23/drivers/dma/ioat_dma.c
===================================================================
--- linux-2.6.23.orig/drivers/dma/ioat_dma.c
+++ linux-2.6.23/drivers/dma/ioat_dma.c
@@ -260,7 +260,7 @@ static dma_cookie_t ioat1_tx_submit(stru
 	/* write address into NextDescriptor field of last desc in chain */
 	to_ioat_desc(ioat_chan->used_desc.prev)->hw->next =
 							first->async_tx.phys;
-	__list_splice(&new_chain, ioat_chan->used_desc.prev);
+	list_splice(&new_chain, &ioat_chan->used_desc);
 
 	ioat_chan->dmacount += desc_count;
 	ioat_chan->pending += desc_count;


Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
