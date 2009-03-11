Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZCKUHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZCKUHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZCKUHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:07:34 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:39284 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751499AbZCKUHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:07:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Km9Id97MSDgQz8u+W/cu3jAF7gTmOD9vVNJz41lrip6TgGEFE8vRHrwQ9lmoXgSpr7RyBdMcGU5203nuSdGEYnfExnnF/l5IlbaVEZR9hIBgem7vnQmPLGRtAFU1LToBrmX0zPXDIJpOBLNvPakGbenQZ3sC3II77qqfN++1n80=  ;
X-YMail-OSG: 0WhkzN8VM1lDQmDyqZG3FYNGyYGnEAKhtUtO4dEWASBBuqMKpp.SppzzdrjXMdnO79NqYd2_iQ3r79qF0_tyrXyjAp3t10HJ.JKsnz4sHjvMo.H9Q68fySZuYTpAhqzQD6rSORfDvSi2oMRcKIk3hhnS.n6qbGsmW2.94GubrYtkeYCjT0C2kUGuW5cBR6UJHw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Subject: Re: [PATCH 2/7] mmc_spi: wait more bytes for card response
Date: Wed, 11 Mar 2009 12:05:20 -0800
User-Agent: KMail/1.9.10
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200903111417.43821.wolfgang.mues@auerswald.de>
In-Reply-To: <200903111417.43821.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903111305.21360.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 March 2009, Wolfgang Mües wrote:
> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
> 
> o some cards are slower than the standard allows and need more
>   time to respond to a command. Max. observed number of bytes
>   was 12.
> 
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> 
> ---
> This is one of a line of patches to enhance the usability of
> the mmc spi host port driver from "don't work with most SD cards"
> to "work with nearly all SD cards" (including those ugly cards
> with non-byte-aligned responses).
> 
> diff -uprN 2_6_29_rc7_patch1_spi_mode_3/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch2_wait_16bytes_response/drivers/mmc/host/mmc_spi.c
> --- 2_6_29_rc7_patch1_spi_mode_3/drivers/mmc/host/mmc_spi.c	2009-03-11 12:58:47.000000000 +0100
> +++ 2_6_29_rc7_patch2_wait_16bytes_response/drivers/mmc/host/mmc_spi.c	2009-03-11 13:00:06.000000000 +0100
> @@ -279,8 +279,11 @@ static int mmc_spi_response_get(struct m
>  		 * so it can always DMA directly into the target buffer.
>  		 * It'd probably be better to memcpy() the first chunk and
>  		 * avoid extra i/o calls...
> +		 *
> +		 * Note we check for more than 8 bytes, because in practice,
> +		 * some SD cards are slow...
>  		 */
> -		for (i = 2; i < 9; i++) {
> +		for (i = 2; i < 16; i++) {
>  			value = mmc_spi_readbytes(host, 1);
>  			if (value < 0)
>  				goto done;
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


