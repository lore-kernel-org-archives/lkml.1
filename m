Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756Ab0AMKo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab0AMKo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397Ab0AMKoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:44:55 -0500
Received: from bamako.nerim.net ([62.4.17.28]:54480 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392Ab0AMKoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:44:54 -0500
Date: Wed, 13 Jan 2010 11:44:51 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hwmon: (smsc47m1) Fix section mismatch
Message-ID: <20100113114451.3f21ac20@hyperion.delvare>
In-Reply-To: <20100113004938.528241344@suse.com>
References: <20100113004938.528241344@suse.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On Tue, 12 Jan 2010 19:48:56 -0500, Jeff Mahoney wrote:
> Subject: [patch 1/6] smsc47m1: Fix section mismatch
> References: <20100113004855.550486769@suse.com>
> Content-Disposition: inline; filename=patches.rpmify/smsc47m1-fix-section-mismatch
> 
>  smsc47m1_restore is called from sm_smsc47m1_exit, which is an __exit
>  function, so it can't be __init.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  drivers/hwmon/smsc47m1.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/hwmon/smsc47m1.c
> +++ b/drivers/hwmon/smsc47m1.c
> @@ -488,7 +488,7 @@ static int __init smsc47m1_find(unsigned
>  }
>  
>  /* Restore device to its initial state */
> -static void __init smsc47m1_restore(const struct smsc47m1_sio_data *sio_data)
> +static void smsc47m1_restore(const struct smsc47m1_sio_data *sio_data)
>  {
>  	if ((sio_data->activate & 0x01) == 0) {
>  		superio_enter();
> 

Good catch, thanks for reporting. I do not get any warning about this
one, even though I build the driver as a module and with hotplug
support enabled. I don't get it.

Anyway, patch applied, thanks.

-- 
Jean Delvare
