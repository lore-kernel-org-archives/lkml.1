Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab0CFLjG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 06:39:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:27020 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab0CFLjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 06:39:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=XsekLrphkEPNPQg/m6zMwXeNGoOFEmhI+AwYtTAb4i4j2mP9aLaI+X3O77XgQ72eGx
         ESI2mQ21HAF7p282pEwr+SgMelM+Iv4di4V7pUexI1MoI0UgrLAvl1VqYNr2OG0YmNqG
         zJ8bzpRn6hqLeCHHxhM52f0AV/hy/5us4176Q=
Date: Sat, 6 Mar 2010 14:38:26 +0300
From: Dan Carpenter <error27@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Scott Moreau <oreaus@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] joystick: off by one error
Message-ID: <20100306113826.GO4958@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Scott Moreau <oreaus@gmail.com>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20100306110944.GG4958@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100306110944.GG4958@bicker>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 02:09:44PM +0300, Dan Carpenter wrote:
> This fixes a smatch warning:
> drivers/input/joystick/gamecon.c +838 gc_setup_pad(23) error: buffer overflow 'gc_names' 10 <= 10
> 

Crap.  I already sent this patch.  I'm really sorry about that.

I will fix my QC process to not do this again.

regards,
dan carpenter

> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/input/joystick/gamecon.c b/drivers/input/joystick/gamecon.c
> index ae998d9..7a55714 100644
> --- a/drivers/input/joystick/gamecon.c
> +++ b/drivers/input/joystick/gamecon.c
> @@ -819,7 +819,7 @@ static int __init gc_setup_pad(struct gc *gc, int idx, int pad_type)
>  	int i;
>  	int err;
>  
> -	if (pad_type < 1 || pad_type > GC_MAX) {
> +	if (pad_type < 1 || pad_type >= GC_MAX) {
>  		pr_err("Pad type %d unknown\n", pad_type);
>  		return -EINVAL;
>  	}
