Return-Path: <linux-kernel-owner+w=401wt.eu-S1756969AbZJSQfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbZJSQfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 12:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756925AbZJSQfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 12:35:16 -0400
Received: from mga12.intel.com ([143.182.124.36]:4579 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751017AbZJSQfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 12:35:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,586,1249282800"; 
   d="scan'208";a="200804548"
Date: Mon, 19 Oct 2009 18:37:16 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: twl4030-power: do not allow negative or zero
 length script
Message-ID: <20091019163715.GG3885@sortiz.org>
References: <1255522550-15199-1-git-send-email-aaro.koskinen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255522550-15199-1-git-send-email-aaro.koskinen@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaro,

On Wed, Oct 14, 2009 at 03:15:49PM +0300, Aaro Koskinen wrote:
> The script length cannot be negative. If the length is zero, return
> an error.
> 
> The patch eliminates the following compiler warning:
Out of curiosity, which toolchain are you using ? I cross compile my mfd tree
for ARM, and I dont get this error...

 
> drivers/mfd/twl4030-power.c: In function 'twl4030_power_init':
twl4030_power_init ? Isnt it twl4030_write_script ?

Cheers,
Samuel.


> drivers/mfd/twl4030-power.c:151: warning: 'err' may be used uninitialized in this function
> drivers/mfd/twl4030-power.c:151: note: 'err' was declared here
> 
> Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
> ---
>  drivers/mfd/twl4030-power.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
> index d423e0c..eae6cda 100644
> --- a/drivers/mfd/twl4030-power.c
> +++ b/drivers/mfd/twl4030-power.c
> @@ -146,9 +146,9 @@ out:
>  }
>  
>  static int __init twl4030_write_script(u8 address, struct twl4030_ins *script,
> -				       int len)
> +				       unsigned len)
>  {
> -	int err;
> +	int err = EINVAL;
>  
>  	for (; len; len--, address++, script++) {
>  		if (len == 1) {
> -- 
> 1.6.0.4
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
