Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbYEMQyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbYEMQyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 12:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758015AbYEMQx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 12:53:57 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:60008 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760750AbYEMQx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 12:53:56 -0400
Message-ID: <4829C5F6.8010206@freescale.com>
Date: Tue, 13 May 2008 11:46:46 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: Anton Vorontsov <avorontsov@ru.mvista.com>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       Kumar Gala <galak@kernel.crashing.org>, Linux I2C <i2c@lm-sensors.org>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] [POWERPC] Add i2c pins to dts and board setup
References: <4825C445.4020004@scram.de>
In-Reply-To: <4825C445.4020004@scram.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jochen Friedrich wrote:
> Initialize I2C pins on boards with CPM1/CPM2 controllers.
> 
> Signed-off-by: Jochen Friedrich <jochen@scram.de>
> ---
>  arch/powerpc/boot/dts/mpc8272ads.dts         |   10 ++++++++++
>  arch/powerpc/boot/dts/mpc866ads.dts          |   10 ++++++++++
>  arch/powerpc/boot/dts/mpc885ads.dts          |   10 ++++++++++
>  arch/powerpc/platforms/82xx/mpc8272_ads.c    |    4 ++++
>  arch/powerpc/platforms/8xx/mpc86xads_setup.c |    4 ++++
>  arch/powerpc/platforms/8xx/mpc885ads_setup.c |    3 +++
>  6 files changed, 41 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/boot/dts/mpc8272ads.dts b/arch/powerpc/boot/dts/mpc8272ads.dts
> index 46e2da3..57abcc1 100644
> --- a/arch/powerpc/boot/dts/mpc8272ads.dts
> +++ b/arch/powerpc/boot/dts/mpc8272ads.dts
> @@ -217,6 +217,16 @@
>  				linux,network-index = <1>;
>  				fsl,cpm-command = <0x16200300>;
>  			};
> +
> +			i2c@11860 {
> +				compatible = "fsl,mpc8272-i2c",
> +					     "fsl,cpm2-i2c",
> +					     "fsl,cpm-i2c";
> +				reg = <11860 20 8afc 2>;
> +				interrupts = <1 8>;
> +				interrupt-parent = <&PIC>;
> +				fsl,cpm-command = <29600000>;
> +			};
>  		};
>  
>  		PIC: interrupt-controller@10c00 {
> diff --git a/arch/powerpc/boot/dts/mpc866ads.dts b/arch/powerpc/boot/dts/mpc866ads.dts
> index 765e43c..84c190e 100644
> --- a/arch/powerpc/boot/dts/mpc866ads.dts
> +++ b/arch/powerpc/boot/dts/mpc866ads.dts
> @@ -171,6 +171,16 @@
>  				fsl,cpm-command = <0000>;
>  				linux,network-index = <1>;
>  			};
> +
> +			i2c@860 {
> +				compatible = "fsl,mpc866-i2c",
> +					     "fsl,cpm1-i2c",
> +					     "fsl,cpm-i2c";
> +				reg = <860 20 3c80 30>;
> +				interrupts = <10>;
> +				interrupt-parent = <&CPM_PIC>;
> +				fsl,cpm-command = <0010>;
> +			};
>  		};
>  	};
>  
> diff --git a/arch/powerpc/boot/dts/mpc885ads.dts b/arch/powerpc/boot/dts/mpc885ads.dts
> index 9895043..67d0e8d 100644
> --- a/arch/powerpc/boot/dts/mpc885ads.dts
> +++ b/arch/powerpc/boot/dts/mpc885ads.dts
> @@ -215,6 +215,16 @@
>  				fsl,cpm-command = <0x80>;
>  				linux,network-index = <2>;
>  			};
> +
> +			i2c@860 {
> +				compatible = "fsl,mpc885-i2c",
> +					     "fsl,cpm1-i2c",
> +					     "fsl,cpm-i2c";
> +				reg = <860 20 3c80 30>;
> +				interrupts = <10>;
> +				interrupt-parent = <&CPM_PIC>;
> +				fsl,cpm-command = <0010>;
> +			};
>  		};
>  	};
>  

These are v1 dts files -- you need an 0x  prefix on the hex numbers.

-Scott
