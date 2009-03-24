Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbZCXL6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbZCXL6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 07:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756377AbZCXL5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 07:57:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54856 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756066AbZCXL5x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:57:53 -0400
From: "Kumar, Purushotam" <purushotam@ti.com>
To: David Brownell <david-b@pacbell.net>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "drzeus-mmc@drzeus.cx" <drzeus-mmc@drzeus.cx>
Date: Tue, 24 Mar 2009 17:27:27 +0530
Subject: RE: [PATCH 1/1] DaVinci: MMC: Updated MMC/SD controller driver for
 DaVinci family.
Thread-Topic: [PATCH 1/1] DaVinci: MMC: Updated MMC/SD controller driver for
 DaVinci family.
Thread-Index: Acmr9F2Mtw8SU+tFQSKEn1zxQM1zCAAgk5KA
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301CC486460@dbde02.ent.ti.com>
References: <1237378885-5918-1-git-send-email-purushotam@ti.com>
 <200903231317.07231.david-b@pacbell.net>
In-Reply-To: <200903231317.07231.david-b@pacbell.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>  Acked-by: David Brownell <dbrownell@users.sourceforge.net>
> 
> Though the PIO bits still bother me ... I'd use *only* the
> io{read,write}8_rep() calls to load/unload the FIFO.  While
> those calls haven't broken yet, it's rude to (a) open-code
> io{read,write}32_rep() like that, and (b) assume all buffers
> coming in to that function are 32-bit aligned.  PIO is hardly
> ever used, given EDMA.  Maybe just one or two calls when
> enumerating.  (SDIO might use it more often.)  That can be
> fixed a bit later.
> 
> Also, it'd be good to submit a patch to the DaVinci tree
> to make it match whatever Pierre eventually merges.  (Less
> the clock name change, of course, which is only needed to
> cope with the elderly clock logic now in mainline.)

In my testing, I have observed that io{read,write}8_rep() does not work properly in pure PIO mode i.e. when use_dma is set 0. So, I have introduced both io{read,write}8_rep() and io{read,write}32_rep() and we could handle different size of buffers irrespective of whether it is multiple of 4 bytes or not.

> 
> Build bug in probe():
> 
> > +	host->clk = clk_get(&pdev->dev, MMCSDCLK);
> 
> Put quotes around "MMCSDCLK".

I will add quotes and re-submit patch today or tomorrow.
-Purushotam
 

