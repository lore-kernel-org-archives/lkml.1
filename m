Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbZKDLmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbZKDLmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbZKDLmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:42:03 -0500
Received: from mga05.intel.com ([192.55.52.89]:28632 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755224AbZKDLmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:42:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,679,1249282800"; 
   d="scan'208";a="743718561"
Date: Wed, 4 Nov 2009 12:43:54 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ben Dooks <ben@simtec.co.uk>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       Simtec Liunx Team <linux@simtec.co.uk>
Subject: Re: tps65010: Allow the board to choose any GPIO base.
Message-ID: <20091104114353.GA3607@sortiz.org>
References: <20091102165220.310450538@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102165220.310450538@fluff.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Mon, Nov 02, 2009 at 04:52:20PM +0000, Ben Dooks wrote:
> If the board does not care where the TPS turns up, then specifiying the
> value -1 to get gpiolib to dynamically allocate the base for the chip
> is valid.
> 
> Change the test to look for != 0, so that any boards specifying zero
> will not end up with gpio that they didn't want.
> 
> Signed-off-by: Ben Dooks <ben@simtec.co.uk>
> Signed-off-by: Simtec Liunx Team <linux@simtec.co.uk>
Applied, thanks a lot.


> ---
>  drivers/mfd/tps65010.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/drivers/mfd/tps65010.c
> ===================================================================
> --- a/drivers/mfd/tps65010.c	2009-10-21 19:09:28.000000000 +0100
> +++ b/drivers/mfd/tps65010.c	2009-10-21 19:09:39.000000000 +0100
> @@ -637,7 +637,7 @@ static int tps65010_probe(struct i2c_cli
>  				tps, DEBUG_FOPS);
>  
>  	/* optionally register GPIOs */
> -	if (board && board->base > 0) {
> +	if (board && board->base != 0) {
>  		tps->outmask = board->outmask;
>  
>  		tps->chip.label = client->name;
> 
> -- 
> Ben (ben@fluff.org, http://www.fluff.org/)
> 
>   'a smiley only costs 4 bytes'

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
