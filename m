Return-Path: <linux-kernel-owner+w=401wt.eu-S1752949AbXJWJu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbXJWJu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXJWJuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:50:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbXJWJuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:50:18 -0400
From: Andreas Schwab <schwab@suse.de>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] unlock 12c_mutex before return
References: <471D398E.8080209@tiscali.nl>
X-Yow: I hope you millionaires are having fun!  I just invested half
 your life savings in yeast!!
Date: Tue, 23 Oct 2007 11:50:16 +0200
In-Reply-To: <471D398E.8080209@tiscali.nl> (Roel Kluin's message of "Tue\, 23
	Oct 2007 02\:00\:14 +0200")
Message-ID: <je3aw217on.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin <12o3l@tiscali.nl> writes:

>     unlock 12c_mutex before return -EINVAL
>     
>     Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/media/dvb/dvb-usb/au6610.c b/drivers/media/dvb/dvb-usb/au6610.c
> index 18e0b16..31f47c7 100644
> --- a/drivers/media/dvb/dvb-usb/au6610.c
> +++ b/drivers/media/dvb/dvb-usb/au6610.c
> @@ -82,8 +82,10 @@ static int au6610_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
>  	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
>  		return -EAGAIN;
>  
> -	if (num > 2)
> +	if (num > 2) {
> +                mutex_unlock(&d->i2c_mutex);
>  		return -EINVAL;

How about moving the check before the lock?

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
