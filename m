Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbZBSKC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbZBSKC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 05:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZBSKCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 05:02:47 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:33378 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbZBSKCr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 05:02:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FdMcCE5MKr/8c1kiqiHLDSDAkgDjeMrMfGQa2UKBNTptT8Nh27psuim8w69iYpsqNJ
         wZ0C4khG9ONONYI3YP05yS+02yufTOfoGwcmvDQc81tp7+9/7f5sc1qcJfinQIqBUPMY
         HWnVOlOYpFXaW6SjfQcstAzH/RN8iOj96zRwI=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0902181547110.31742@wrl-59.cs.helsinki.fi>
References: <Pine.LNX.4.64.0902181547110.31742@wrl-59.cs.helsinki.fi>
Date: Thu, 19 Feb 2009 12:55:02 +0300
Message-ID: <a63d67fe0902190155x423c517avf369c61bab7376df@mail.gmail.com>
Subject: Re: [PATCH] sx.c: fix dbl statement if - add missing braces
From: Dan Carpenter <error27@gmail.com>
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/18/09, Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:
>
> Caused by 736d54533aed (sx.c: fix missed unlock_kernel()
> on error path in sx_fw_ioctl()). You guys keep breaking
> things this way in every single kernel release in at least
> couple of places... :-(
>

Yep.  Sorry about that.

Signed-off-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter

> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> Cc: Dan Carpenter <error27@gmail.com>
> ---
>  drivers/char/sx.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/char/sx.c b/drivers/char/sx.c
> index f146e90..d7c4165 100644
> --- a/drivers/char/sx.c
> +++ b/drivers/char/sx.c
> @@ -1746,9 +1746,10 @@ static long sx_fw_ioctl(struct file *filp, unsigned
> int cmd,
>  		sx_dprintk(SX_DEBUG_FIRMWARE, "returning type= %ld\n", rc);
>  		break;
>  	case SXIO_DO_RAMTEST:
> -		if (sx_initialized)	/* Already initialized: better not ramtest the board.
>  */
> +		if (sx_initialized) {	/* Already initialized: better not ramtest the
> board.  */
>  			rc = -EPERM;
>  			break;
> +		}
>  		if (IS_SX_BOARD(board)) {
>  			rc = do_memtest(board, 0, 0x7000);
>  			if (!rc)
> --
> 1.5.2.2
>
