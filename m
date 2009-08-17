Return-Path: <linux-kernel-owner+w=401wt.eu-S1758389AbZHQXsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389AbZHQXsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 19:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbZHQXsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 19:48:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752575AbZHQXsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 19:48:19 -0400
Date: Mon, 17 Aug 2009 16:47:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: soni.trilok@gmail.com, greg@kroah.com, arve@android.com,
       linux-kernel@vger.kernel.org, swetland@google.com,
       dmitry.torokhov@gmail.com, dtor@mail.ru, linux-input@vger.kernel.org,
       linux-i2c@vger.kernel.org
Subject: Re: Synaptics touchscreen for HTC Dream: check that smbus is
 available
Message-Id: <20090817164759.43c39f2d.akpm@linux-foundation.org>
In-Reply-To: <20090808134049.GA13083@elf.ucw.cz>
References: <20090714100634.GA4054@elf.ucw.cz>
	<5d5443650907140320w334864f4uc1ee13ed32fdb874@mail.gmail.com>
	<20090715133627.GA2538@elf.ucw.cz>
	<5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com>
	<20090721102153.GE4133@elf.ucw.cz>
	<5d5443650907210334k3f562cebsc665511a161c8639@mail.gmail.com>
	<20090808134049.GA13083@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Aug 2009 15:40:50 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> > >> Because this driver is using smbus i2c apis, it will be good to add
> > >> that check too.
> > >
> > > So I should do something like
> > >
> > > if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WORD_DATA))
> > > __ __ __ __...
> > >
> > > in addition?
> > 
> > Yes.
> 
> Ok, here it is.
> 
> --- 
> 
> Check that SMBUS APIs are available in touchscreen driver.

Why?

> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/drivers/staging/dream/synaptics_i2c_rmi.c b/drivers/staging/dream/synaptics_i2c_rmi.c
> index dc1e3c7..6e23276 100644
> --- a/drivers/staging/dream/synaptics_i2c_rmi.c
> +++ b/drivers/staging/dream/synaptics_i2c_rmi.c
> @@ -373,6 +373,12 @@ static int __devinit synaptics_ts_probe(
>  		goto err_check_functionality_failed;
>  	}
>  
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
> +		pr_err("synaptics_ts_probe: need I2C_FUNC_SMBUS_WORD_DATA\n");
> +		ret = -ENODEV;
> +		goto err_check_functionality_failed;
> +	}
> +
>  	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
>  	if (ts == NULL) {
>  		ret = -ENOMEM;

