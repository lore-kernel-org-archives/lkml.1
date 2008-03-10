Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbYCJFOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbYCJFOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 01:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYCJFOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 01:14:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:44813 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbYCJFOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 01:14:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BGfIcrPjyw4x4ZcQHrFsdFZWEKjPREuuTzRwIpQKxRf+bMst/feJtTN8/loWs9a4/Vq8cfQKRlwiqnfSjZ7i0Q75smFMHwVa5CK3VPvnlVpbGjsF47mTevKciQNViOFbTh1nVIyFK19BLKIrSgUK1/dtrHWKM30dpey80j1Qdzg=
Message-ID: <f17812d70803092214x2fefe245i741902bc62dee9d2@mail.gmail.com>
Date: Mon, 10 Mar 2008 13:14:35 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [patch 2.6.25-rc4] gpio/pca953x bugfix: mark as can_sleep
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Rtp Arnaud Patard" <arnaud.patard@rtp-net.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200803091356.20024.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803091356.20024.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK

On Mon, Mar 10, 2008 at 4:56 AM, David Brownell <david-b@pacbell.net> wrote:
> The pca953x driver is an I2C driver so gpio_chip->can_sleep should be set.
>  This lets upper layers know they should use the gpio_*_cansleep() calls
>  to access values, and may not access them from nonsleeping contexts.
>
>  Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
>  Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
>  ---
>  Merge before 2.6.25-final, please.  This will for example prevent
>  leds-gpio from issuing blocking I2C calls from timer/irq contexts.
>
>   drivers/gpio/pca953x.c |    1 +
>   1 file changed, 1 insertion(+)
>
>  --- g26.orig/drivers/gpio/pca953x.c     2008-03-08 11:17:22.000000000 -0800
>  +++ g26/drivers/gpio/pca953x.c  2008-03-09 13:51:13.000000000 -0700
>  @@ -184,6 +184,7 @@ static void pca953x_setup_gpio(struct pc
>         gc->direction_output = pca953x_gpio_direction_output;
>         gc->get = pca953x_gpio_get_value;
>         gc->set = pca953x_gpio_set_value;
>  +       gc->can_sleep = 1;
>
>         gc->base = chip->gpio_start;
>         gc->ngpio = gpios;
>



-- 
Cheers
- eric
