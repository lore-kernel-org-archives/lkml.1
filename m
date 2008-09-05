Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYIEFfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYIEFfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 01:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYIEFex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 01:34:53 -0400
Received: from pc125.solomon-systech.com ([202.76.106.125]:37227 "HELO
	virus-gateway.solomon-systech.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751216AbYIEFew convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 01:34:52 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: mmc/card/block.c : mmc_blk_open readonly mount bug?
Date: Fri, 5 Sep 2008 13:36:06 +0800
Message-ID: <6334E09627481B4AA5C8DE1E69E19D3B09D1F149@SSLEXCHANGE.solomonsystech.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: mmc/card/block.c : mmc_blk_open readonly mount bug?
Thread-Index: AckPFY7Pm3S0MzRLQTKpPuvBXdBHwgAA00tQ
From: <sasin@solomon-systech.com>
To: <drzeus-list@drzeus.cx>, <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guess nobody tests with readonly?  We had a socket on our board that
flipped the write protect signal, and the rest you know :-)

-----Original Message-----
From: Pierre Ossman [mailto:drzeus-list@drzeus.cx] 
Sent: Friday, September 05, 2008 1:07 PM
To: Andrew Morton
Cc: Sasi Nair; linux-kernel@vger.kernel.org
Subject: Re: mmc/card/block.c : mmc_blk_open readonly mount bug?


On Thu, 4 Sep 2008 16:08:08 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> 
> mmc_block_open() increments md->usage although it returns with -EROFS
when
> default mounting a MMC/SD card with write protect switch on.  This
> reference counting bug prevents /dev/mmcblkX from being released on
card
> removal, and situation worsen with reinsertion until the minor number
> range runs out.
> 
> Reported-by: <sasin@solomon-systech.com>
> Cc: Pierre Ossman <drzeus-list@drzeus.cx>
> Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

I wonder how that bug has been able to go unnoticed for so long...

Acked-by: Pierre Ossman <drzeus@drzeus.cx>

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
