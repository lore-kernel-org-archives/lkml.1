Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbZCLU5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbZCLU5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 16:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbZCLU5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 16:57:06 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:48869 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755057AbZCLU5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 16:57:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KpH9aDAKp5UYGA0cZEB2J2v6cHpyvk5FzTtG/Jh13983WQLMFfj3vrUWq0NMFdlsXjIN/lbvAM282rNMWWE8iStymXsj1pDHcYDnCpvBoo7xxuJC3C5CkGB8ITtN6PrRO0HlS6X2W0mpU6CwBdUcYPDcDfHH/vzPb68pOmvPGhc=  ;
X-YMail-OSG: mf9HzLoVM1msNyG1nUtWMibqqIrLPVO9.RNCqmpQx3FxvhPdJG_vTLHEiM5hmqKFFmQ4b3uQ1.72sT3qTK2s8nWUJjv09JrvOdlMbJ_CcY9denBBb1S8OjIjw6CuC3C4BXB3wpMtKRkoZfVPgM8hRtUEePlby_OnyZUQI6kar4z_PdYcSjaW2We.XPeeEs8KTbr9ySLrYPHcHNcgeJTw5GJyZuPc8vlnv5KYPXJrsoOoPrrR
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Subject: Re: [PATCH 10/7] mmc_spi: fix bug introduced in patch 3/7
Date: Thu, 12 Mar 2009 12:57:00 -0800
User-Agent: KMail/1.9.10
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200903121549.37620.wolfgang.mues@auerswald.de>
In-Reply-To: <200903121549.37620.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903121357.00743.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, Wolfgang Mües wrote:
> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
> 
> o Fix bug introduced in patch 3/7.
>   The first 3 bits of the data response may be undefined;
>   assuming that these bits are always 1 lead to unreliable
>   transmission.
> 
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

Could you just send an updated version of #3?  Addressing
both this issue and the previous "comment is confusing" one.
I could ack such an update.


> 
> ---
> 
> diff -uprN 2_6_29_rc7_patch9_speedup/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch10_bugfix_of_patch3/drivers/mmc/host/mmc_spi.c
> --- 2_6_29_rc7_patch9_speedup/drivers/mmc/host/mmc_spi.c	2009-03-12 14:35:27.000000000 +0100
> +++ 2_6_29_rc7_patch10_bugfix_of_patch3/drivers/mmc/host/mmc_spi.c	2009-03-12 14:40:03.000000000 +0100
> @@ -725,6 +725,9 @@ mmc_spi_writeblock(struct mmc_spi_host *
>  	pattern |= scratch->status[2] << 8;
>  	pattern |= scratch->status[3];
>  
> +	/* First 3 bit of pattern are undefined */
> +	pattern |= 0xE0000000;
> +
>  	/* left-adjust to leading 0 bit */
>  	while (pattern & 0x80000000)
>  		pattern <<= 1;
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


