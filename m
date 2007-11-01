Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbXKARwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbXKARwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756326AbXKARv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:51:57 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:50901 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbXKARv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:51:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XzrTiT8brpEIy7oIBqcMmKxJw8PB2GXKv3iuh4+Nwq1lPW/+EvBe+fDNsX/K6RBNgbP74EJqj3xp8T116zRJUVpGWFNNxgeRHgWAOdMA6jSJBC0rQziaKnyeIAgFVCWME2eH/a8/BaP8mbwHSccHV35+bBdSGej20VOnNkxkHEI=
Message-ID: <8bd0f97a0711011051o6d52f635i76c3a63b478ac817@mail.gmail.com>
Date: Thu, 1 Nov 2007 13:51:55 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <bryan.wu@analog.com>
Subject: Re: [PATCH 2/2] Blackfin I2C/TWI driver: add missing pin mux operation
Cc: khali@linux-fr.org, i2c@lm-sensors.org, linux-kernel@vger.kernel.org
In-Reply-To: <1193736797-9005-3-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193736797-9005-1-git-send-email-bryan.wu@analog.com>
	 <1193736797-9005-3-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/07, Bryan Wu <bryan.wu@analog.com> wrote:
> --- a/drivers/i2c/busses/i2c-bfin-twi.c
> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
> +static int setup_pin_mux(int action, struct bfin_twi_iface *iface)
> +{
> +
> +       u16 pin_req[2][3] = {
> +               {P_TWI0_SCL, P_TWI0_SDA, 0},
> +               {P_TWI1_SCL, P_TWI1_SDA, 0},
> +       };

might be better to have this in the boards file ... consider the
scenario on the BF54x where the user wants to use I2C0 and not I2C1 or
vice versa so that they can use the set of pins for something else ...
this would prevent such a setup

> +       if (action) {
> +               if (peripheral_request_list(pin_req[iface->bus_num], DRV_NAME))
> +                       return -EFAULT;
> +       } else {
> +               peripheral_free_list(pin_req[iface->bus_num]);
> +       }
> +
> +       return 0;
> +}

EFAULT is incorrect i think ... want to pass back the actual value
from peripheral_request_list()

> --- a/drivers/i2c/busses/i2c-bfin-twi.c
> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
> +static int setup_pin_mux(int action, struct bfin_twi_iface *iface)
> +{
> +
> +       u16 pin_req[2][3] = {
> +               {P_TWI0_SCL, P_TWI0_SDA, 0},
> +               {P_TWI1_SCL, P_TWI1_SDA, 0},
> +       };

might be better to have this in the boards file ... consider the
scenario on the BF54x where the user wants to use I2C0 and not I2C1 or
vice versa so that they can use the set of pins for something else ...
this would prevent such a setup

       if (action)
               return peripheral_request_list(pin_req[iface->bus_num],
DRV_NAME);
       else
               peripheral_free_list(pin_req[iface->bus_num]);

       return 0;
-mike
