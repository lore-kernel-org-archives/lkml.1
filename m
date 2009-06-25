Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbZFYMRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbZFYMRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 08:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbZFYMR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 08:17:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20842 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbZFYMRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 08:17:25 -0400
Date: Thu, 25 Jun 2009 14:16:04 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] [drivers] [SPI] SPI_GPIO: add support for controllers with
 missing MISO pin
In-reply-to: <200906231155.15339.david-b@pacbell.net>
To: "'David Brownell'" <david-b@pacbell.net>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net, kyungmin.park@samsung.com,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <000401c9f58e$c1369230$43a3b690$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Acn0NChlCCydrdPyS9+GxVMQMTSlDgBWaiCA
References: <E4D3F24EA6C9E54F817833EAE0D912AC0228288531@bssrvexch01.BS.local>
 <200906231155.15339.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, June 23, 2009 8:55 PM, David Brownell wrote:

> > There are some boards that do not strictly follow SPI standard and use only 3 wires
> > (SCLK, MOSI, SS) for connecting some simple auxiliary chips and controls them with GPIO
> > based 'spi controller'. In this configuration the MISO line is missing (it is not
> > required if the chip does not transfer any data back to host). The example of such
> > board is a NCP ARM S3C64XX based machine. This patch adds support for such non-standard
> > configuration in GPIO-based SPI controller.
> >
> > Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> This is missing one integrity feature:  it should reject all
> requests that provide a read buffer, since obviously it can't
> satisfy any such requests.
> 
> Also, please add a comment in spi_gpio_request() explaining
> this point:  that output-only configs exist, and you're
> supporting them by letting MISO be invalid.
> 
> Address those two points and this will be almost OK.

Thanks for your review. I will post an updated patch soon.

> Thing is, this raises two related issues:  (a) there's the
> analagous input-only case where MOSI isn't used, e.g. for
> some kinds of sensor; and (b) there's also "real 3-wire SPI"
> (spi->mode & SPI_3WIRE) where interactions are limited to
> half duplex and one pin switches roles between MOSI and MISO.
> 
> Clearly this "output-only" case is a subset of SPI_3WIRE (the
> MOMI/SISO pin can't switch direction) so one more change I
> want to see is requiring that spi->mode flag be set in all
> SPI devices registered when this mode is used.
> 
> If you have time, it would be good to generaize this patch
> to cover all of those 3-wire modes ... accept all half
> duplex calls, use gpio_direction_*() to switch direction.
>
> If not -- e.g. nothing to test that with! -- then I can
> understand, but please make your changes with that model
> in mind, and leave an appropriate FIXME in place.

I'm sorry, but I have only a hw board with missing MISO pin so I won't
be able to properly check/debug any other configurations. However I
will add a support for missing MOSI pin as well (simple code
reusage).

> p.s. I'll CC you on one more related patch.  Briefly,
>      there's a new spi_master->flags field that should
>      set SPI_MASTER_HALF_DUPLEX.  Arguably, this specific
>      case should also advertise something like NO_RX.

Thanks. I will add SPI_MASTER_NO_TX/NO_RX flags there.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center



