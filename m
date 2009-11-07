Return-Path: <linux-kernel-owner+w=401wt.eu-S1752211AbZKGPib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbZKGPib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 10:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZKGPi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 10:38:29 -0500
Received: from 1wt.eu ([62.212.114.60]:50820 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZKGPi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 10:38:29 -0500
Date: Sat, 7 Nov 2009 16:37:42 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jean Delvare <khali@linux-fr.org>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [78/99] hwmon: (it87) Fix VID reading on IT8718F/IT8720F
Message-ID: <20091107153741.GB5607@1wt.eu>
References: <20091106221358.309857998@mini.kroah.org> <20091106221549.637855004@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091106221549.637855004@mini.kroah.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, Nov 06, 2009 at 02:15:16PM -0800, Greg KH wrote:
> 2.6.31-stable review patch.  If anyone has any objections, please let us know.

I noticed this one was not merged into 2.6.27.39. I suspect it is
just because it did not apply since IT8720F was not present there.
However I think the test still needs fixing, though I'm not well
qualified to judge about that.

Jean, do you have any opinion on this matter ?

Thanks,
Willy

> ------------------
> From: Jean Delvare <khali@linux-fr.org>
> 
> commit 371dc4a6d8c3c74a9a1c74b87c2affb3fcef6500 upstream.
> 
> Comparing apples to bananas doesn't seem right. Consistently use the
> chips enum for chip type comparisons, to avoid such bugs in the
> future.
> 
> The bug has been there since support for the IT8718F was added, so
> VID never worked for this chip nor for the similar IT8720F.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/hwmon/it87.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> --- a/drivers/hwmon/it87.c
> +++ b/drivers/hwmon/it87.c
> @@ -1028,12 +1028,11 @@ static int __init it87_find(unsigned sho
>  		chip_type, *address, sio_data->revision);
>  
>  	/* Read GPIO config and VID value from LDN 7 (GPIO) */
> -	if (chip_type != IT8705F_DEVID) {
> +	if (sio_data->type != it87) {
>  		int reg;
>  
>  		superio_select(GPIO);
> -		if ((chip_type == it8718) ||
> -		    (chip_type == it8720))
> +		if (sio_data->type == it8718 || sio_data->type == it8720)
>  			sio_data->vid_value = superio_inb(IT87_SIO_VID_REG);
>  
>  		reg = superio_inb(IT87_SIO_PINX2_REG);
> 
> 
> _______________________________________________
> Stable-review mailing list
> Stable-review@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable-review
