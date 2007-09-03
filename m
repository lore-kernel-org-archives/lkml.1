Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbXICReR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbXICReR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 13:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbXICReG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 13:34:06 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:10578 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbXICReE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 13:34:04 -0400
X-IronPort-AV: i="4.20,202,1186372800"; 
   d="scan'208"; a="50425506:sNHT28628355"
Subject: Re: [PATCH] Blackfin BF54x NAND Flash Controller driver
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: David Woodhouse <dwmw2@infradead.org>
Cc: bryan.wu@analog.com, Thomas Gleixner <tglx@linutronix.de>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <1188837990.6075.32.camel@shinybook.infradead.org>
References: <1188804323.29566.6.camel@roc-laptop>
	 <1188837990.6075.32.camel@shinybook.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Tue, 04 Sep 2007 01:33:49 +0800
Message-Id: <1188840829.9063.10.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 03 Sep 2007 17:34:01.0083 (UTC) FILETIME=[9D8434B0:01C7EE50]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-03 at 17:46 +0100, David Woodhouse wrote:
> On Mon, 2007-09-03 at 15:25 +0800, Bryan Wu wrote:
> > +       if (hardware_ecc) {
> > +               if (plat->page_size == NFC_PG_SIZE_256) {
> > +                       chip->ecc.bytes = 3;
> > +                       chip->ecc.size = 256;
> > +               } else if (mtd->writesize == NFC_PG_SIZE_512) { 
> 
> Comparing against plat->page_size in one case, but mtd->writesize in the
> other? 

This is a typo in development. I will fix it ASAP. -:)

> And elsewhere it seems plat->page_size is treated as a boolean,
> indicating only 256-byte vs. 512-byte pages (you don't support 2KiB or
> other page sizes at all?)
> 

When enabled hardware ECC, NFC of BF54x supports 256 and 512 bytes page
size ECC.
it's maybe little confusing with the NAND chip's pagesize. When NAND
chip is 2KiB or other page size, this driver can use multiple 256/512
pages to do hardware ECC. And it's handled by the driver software here.

-Bryan Wu
