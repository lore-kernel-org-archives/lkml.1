Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbXFKEwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbXFKEwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 00:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbXFKEwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 00:52:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42048 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbXFKEwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 00:52:24 -0400
Message-ID: <466CD502.6010201@garzik.org>
Date: Mon, 11 Jun 2007 00:52:18 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] pata_it821x: (partially) fix DMA in RAID mode
References: <200706101843.20947.bzolnier@gmail.com>
In-Reply-To: <200706101843.20947.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Code intended to check DMA status was checking DMA command register.
> 
> Moreover firmware seems to "forget" to set DMA capable bit for the
> slave device (at least in RAID mode but without ITE RAID volumes) so
> check device ID for DMA capable bit when deciding whether to use DMA
> and remove DMA status check completely.
> 
> Thanks to Pavol ©imo for the bugreport and testing the initial fix.
> 
> This change unfortunately still doesn't fix DMA in RAID mode (which
> works fine with IDE it821x) but Alan is working on the missing pieces
> (pata_it821x vs libata EH issues).
> 
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Tejun Heo <htejun@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> 
>  drivers/ata/pata_it821x.c |   11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)

Patch is OK but it's mangled by your mailer:

@@ -79,7 +80,7 @@
=20
=20
  #define DRV_NAME "pata_it821x"
=2D#define DRV_VERSION "0.3.6"
+#define DRV_VERSION "0.3.7"
=20
  struct it821x_dev
  {
@@ -460,14 +461,8 @@ static unsigned int it821x_passthru_qc_i
=20

=2D     int dma_enabled =3D 0;
         int i;
=20

etc.

