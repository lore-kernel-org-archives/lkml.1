Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbZDVRlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbZDVRlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 13:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbZDVRlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 13:41:16 -0400
Received: from kroah.org ([198.145.64.141]:35176 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752942AbZDVRlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 13:41:15 -0400
Date: Wed, 22 Apr 2009 09:50:49 -0700
From: Greg KH <greg@kroah.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg KH <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
       Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       David Schleef <ds@schleef.org>
Subject: Re: staging: comedi: non working tests on unsigned cmd->convert_arg
Message-ID: <20090422165049.GC19524@kroah.com>
References: <49EDC792.60100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EDC792.60100@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 03:18:10PM +0200, Roel Kluin wrote:
> vi drivers/staging/comedi/comedi.h +342
> 
> and note that cmd->convert_arg in s626_ai_cmdtest() is unsigned. Should there
> maybe be a test:
> 
> if (cmd->convert_src == TRIG_EXT && cmd->convert_arg > MAX)
> 
> (and what should MAX be then?)

I don't know.  Let's ask the comedi developers :)

Frank, what do you think about this?


> Otherwise you may want to apply the cleanup patch below
> 
> Roel
> ------------------------------>8-------------8<---------------------------------
> Remove redundant tests on unsigned
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com> 
> ---
> diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
> index 30dec9d..928c4c6 100644
> --- a/drivers/staging/comedi/drivers/s626.c
> +++ b/drivers/staging/comedi/drivers/s626.c
> @@ -1906,7 +1906,7 @@ static int s626_ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s
>  		err++;
>  	}
>  
> -	if (cmd->convert_src == TRIG_EXT && cmd->convert_arg < 0) {
> +	if (cmd->convert_src == TRIG_EXT) {
>  		cmd->convert_arg = 0;
>  		err++;
>  	}
