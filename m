Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab0BBRwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:52:14 -0500
Received: from exprod6og101.obsmtp.com ([64.18.1.181]:45109 "HELO
	exprod6og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755256Ab0BBRwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 12:52:12 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PWM PATCH 3/5] Expunge old Atmel PWMC driver, replacing it with one that conforms to the PWM API
Date: Tue, 2 Feb 2010 12:52:08 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909020E99CD@mi8nycmail19.Mi8.com>
In-Reply-To: <f5be82a3ae501709e8568e9fa06ab036fd363567.1265094517.git.bgat@billgatliff.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PWM PATCH 3/5] Expunge old Atmel PWMC driver, replacing it with one that conforms to the PWM API
Thread-Index: Acqj16cfLxk1fy1YRwyH5eVusFFXhAAV97Cw
References: <cover.1265094517.git.bgat@billgatliff.com> <f5be82a3ae501709e8568e9fa06ab036fd363567.1265094517.git.bgat@billgatliff.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Bill Gatliff" <bgat@billgatliff.com>, <linux-embedded@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Feb 2010 17:52:10.0795 (UTC) FILETIME=[71CA4FB0:01CAA430]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 02, 2010 12:15 AM, Bill Gatliff wrote:
> Signed-off-by: Bill Gatliff <bgat@billgatliff.com>
> ---
>  drivers/misc/Makefile    |    6 +-
>  drivers/misc/atmel_pwm.c |  409 --------------------------------
>  drivers/pwm/atmel-pwm.c  |  589 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 594 insertions(+), 410 deletions(-)
>  delete mode 100644 drivers/misc/atmel_pwm.c
>  create mode 100644 drivers/pwm/atmel-pwm.c

A couple quick comments, more after a better review.

[snip]

> diff --git a/drivers/misc/atmel_pwm.c b/drivers/misc/atmel_pwm.c
> deleted file mode 100644
> index 6aa5294..0000000
> --- a/drivers/misc/atmel_pwm.c
> +++ /dev/null

[snip]

> -static struct platform_driver atmel_pwm_driver = {
> -	.driver = {
> -		.name = "atmel_pwm",
> -		.owner = THIS_MODULE,
> -	},

[snip]

> -MODULE_DESCRIPTION("Driver for AT32/AT91 PWM module");
> -MODULE_LICENSE("GPL");
> -MODULE_ALIAS("platform:atmel_pwm");
> diff --git a/drivers/pwm/atmel-pwm.c b/drivers/pwm/atmel-pwm.c
> new file mode 100644
> index 0000000..a2a08c5
> --- /dev/null
> +++ b/drivers/pwm/atmel-pwm.c

[snip]

> +static struct platform_driver atmel_pwm_driver = {
> +	.driver = {
> +		.name = "atmel_pwmc",
> +		.owner = THIS_MODULE,
> +	},

[snip]

> +MODULE_AUTHOR("Bill Gatliff <bgat@billgatliff.com>");
> +MODULE_DESCRIPTION("Driver for Atmel PWMC peripheral");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:atmel_pwmc");

You have a couple name changes here, were they intentional?

    Filename: atmel_pwm.c        -> atmel-pwm.c
 Driver name: atmel_pwm          -> atmel_pwmc
Module alias: platform:atmel_pwm -> platform:atmel_pwmc

Also, will this new driver still work for all the existing users of
the old one?  Are there any platform changes that need to be done?

Regards,
Hartley
