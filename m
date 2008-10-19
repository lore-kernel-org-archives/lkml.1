Return-Path: <linux-kernel-owner+w=401wt.eu-S1752134AbYJSWr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbYJSWr4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 18:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYJSWrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 18:47:48 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:27475 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751816AbYJSWrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 18:47:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xNCnTfc3zEj0/VxV+ykddbS7yUOhPN3bat2kCAyKLon4d+ac7XxbPoiQeceLrBehchgSKdkN9htuZmClL4/rGdh8MfjMkgrC46EaRPTH0gOOf/Hv33U2SrxAhcH0oiHO5WFiVAO9+ng67aDADXrUxjBNqoioWpEzC/eVLb4U2/o=  ;
X-YMail-OSG: 69G3YTIVM1mqchxxkNiqjJwN1SxWxx5vYoVfoFv9Ng_Ipl1F5ZHz290RGAdCYTrvuzXmTFI8Dm2liJMijrydaHL7QsZTOr43fk8mYOIy08H9j_t6EOzFFaNzVnBa9MHDPq1fTjzHMhhCtVJbjV39xRN_
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: linux-mtd@lists.infradead.org, Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH 1/3] mtd m25p80: add support for Macronix MX25L12805D
Date: Sun, 19 Oct 2008 15:47:45 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>
References: <200810191516.30804.david-b@pacbell.net>
In-Reply-To: <200810191516.30804.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810191547.45449.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the "1/3" -- there's only this one patch.
The other two would have been resends of patches that
never got acked, but do seem to be in the MTD git tree.

However I noticed that this patch will have a problem
applying against that MTD git ... the m25p80 driver
got taught how to use two of the "extended" JEDEC ID
bytes provided by some vendors, so the initializers here
are all missing an extra "u16" value following the JEDEC
code.  Swap in a 0 for the Macronix part and all should
be OK ...

- Dave

On Sunday 19 October 2008, David Brownell wrote:
> From: Lennert Buytenhek <buytenh@wantstofly.org>
> 
> Support one more flavor of SPI flash:  Macronix MX25L12805D
> (128 Mbit, 16 MByte).
> 
> Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> 
> --- a/drivers/mtd/devices/m25p80.c
> +++ b/drivers/mtd/devices/m25p80.c
> @@ -467,6 +467,9 @@ static struct flash_info __devinitdata m25p_data [] = {
>  	{ "at26df161a", 0x1f4601, 64 * 1024, 32, SECT_4K, },
>  	{ "at26df321",  0x1f4701, 64 * 1024, 64, SECT_4K, },
>  
> +	/* Macronix */
> +	{ "mx25l12805d", 0xc22018, 64 * 1024, 256, SECT_4K, },
> +
>  	/* Spansion -- single (large) sector size only, at least
>  	 * for the chips listed here (without boot sectors).
>  	 */
> 
> 
> 


