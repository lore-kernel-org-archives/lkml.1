Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbXKDJzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbXKDJzS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 04:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbXKDJzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 04:55:06 -0500
Received: from smtp-100-sunday.nerim.net ([62.4.16.100]:51585 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754108AbXKDJzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 04:55:04 -0500
Date: Sun, 4 Nov 2007 10:55:01 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Jon Smirl" <jonsmirl@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org
Subject: Re: [i2c] [PATCH] Fix i2c module parameter permissions for
 read/write
Message-ID: <20071104105501.380a840a@hyperion.delvare>
In-Reply-To: <9e4733910711032155j1649a3b8u56a59e754d77f61b@mail.gmail.com>
References: <9e4733910711032155j1649a3b8u56a59e754d77f61b@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Sun, 4 Nov 2007 00:55:15 -0400, Jon Smirl wrote:
> The permissions of i2c module parameters were set to zero making the
> parameters invisible and unsettable from the kernel command line. This
> patch changes the permissions to the standard 0644 read/write.

These permissions have nothing to do with the kernel command line. They
define whether a file is created in sysfs for the respective module
parameter. Even with permissions set to 0, you can still set the value
in question from the kernel command line with <module>.<parm>=<value>.

Also, there's no such think as "standard 0644" permissions. For some
parameters, it doesn't make much sense to expose them in sysfs. For
others it doesn't make sense (or could even be dangerous) to make them
writable. Each parameter has its own requirements.

> 
> Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
> ---
> 
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index 8033e6b..395e430 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -588,7 +588,7 @@ union i2c_smbus_data {
>  #define I2C_CLIENT_MODULE_PARM(var,desc) \
>    static unsigned short var[I2C_CLIENT_MAX_OPTS] = I2C_CLIENT_DEFAULTS; \
>    static unsigned int var##_num; \
> -  module_param_array(var, short, &var##_num, 0); \
> +  module_param_array(var, short, &var##_num, 0644); \
>    MODULE_PARM_DESC(var,desc)
> 
>  #define I2C_CLIENT_MODULE_PARM_FORCE(name)                             \
> 
> 


-- 
Jean Delvare
