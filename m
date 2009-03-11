Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbZCKUE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbZCKUE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZCKUEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:04:43 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:22482 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751499AbZCKUEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:04:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Koub69fUhra3hWKinpxKQW3YmMs4a840nj5cVROjwroNkQaPISXxoM34e2vtx0Jj4/3tYT+YDJoIg4YQXf2YPVud1zFZGNC7mnkOVcZY+HdZpLP2406r8U5jCXyToxmtz9Gkt4cOzxDNjS1RAzPFcILSto6JukmI58RgGVH9/Pg=  ;
X-YMail-OSG: 5i0IzYQVM1mC8rC837kRI0QQ4JZFmHtWuBYBPGJvQoXddzGW4GeZbjSKB_7Qtn8OGLd75EW9n3UqM23BhoddUbjpCrxl1cykeI9OBIWd.d.nZDFGSRCf7SO55p9Wk8vEVS4Q6BFonrvS848DectKF3K5VMECPS16BLJ3B56kXHfhCTAjPAtvAKXKJ15jp.QQgSxCV5XV5XIIBAuVBZyE3D0pM9.cXFz6JvqM1g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Subject: Re: [PATCH 1/7] mmc_spi: allow setting of spi mode 3
Date: Wed, 11 Mar 2009 12:04:38 -0800
User-Agent: KMail/1.9.10
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200903111413.15981.wolfgang.mues@auerswald.de>
In-Reply-To: <200903111413.15981.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903111304.39251.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 March 2009, Wolfgang Mües wrote:
> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
> 
> o allow the platform data structures to specify spi mode 3
>   (if there is a pullup on the clock line or the spi hardware
>    is not able to serve spi mode 0).
> 
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> ---
> This is one of a line of patches to enhance the usability of
> the mmc spi host port driver from "don't work with most SD cards"
> to "work with nearly all SD cards" (including those ugly cards
> with non-byte-aligned responses). 



>   
> diff -uprN 2_6_29_rc7_backported/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch1_spi_mode_3/drivers/mmc/host/mmc_spi.c
> --- 2_6_29_rc7_backported/drivers/mmc/host/mmc_spi.c	2009-03-04 02:05:22.000000000 +0100
> +++ 2_6_29_rc7_patch1_spi_mode_3/drivers/mmc/host/mmc_spi.c	2009-03-11 12:58:47.000000000 +0100
> @@ -1204,10 +1204,12 @@ static int mmc_spi_probe(struct spi_devi
>  
>  	/* MMC and SD specs only seem to care that sampling is on the
>  	 * rising edge ... meaning SPI modes 0 or 3.  So either SPI mode
> -	 * should be legit.  We'll use mode 0 since it seems to be a
> -	 * bit less troublesome on some hardware ... unclear why.
> +	 * should be legit.  We'll use mode 0 since the steady state is 0,
> +	 * which is appropriate for hotplugging, unless the platform data
> +	 * specify mode 3 (if hardware is not compatible to mode 0).
>  	 */
> -	spi->mode = SPI_MODE_0;
> +	if (spi->mode != SPI_MODE_3)
> +		spi->mode = SPI_MODE_0;
>  	spi->bits_per_word = 8;
>  
>  	status = spi_setup(spi);
> 
> ---
> regards
> 
> i. A. Wolfgang Mües
> -- 
> Auerswald GmbH & Co. KG
> Hardware Development
> Telefon: +49 (0)5306 9219 0
> Telefax: +49 (0)5306 9219 94 
> E-Mail: Wolfgang.Mues@Auerswald.de
> Web: http://www.auerswald.de
>  
> --------------------------------------------------------------
> Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
> Registriert beim AG Braunschweig HRA 13289
> p.h.G Auerswald Geschäftsführungsges. mbH
> Registriert beim AG Braunschweig HRB 7463
> Geschäftsführer: Dipl-Ing. Gerhard Auerswald
> 
> 


