Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYAQJe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYAQJe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 04:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbYAQJeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 04:34:20 -0500
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:39172 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753524AbYAQJeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 04:34:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2C/AShRKkOtX6dVwki0v45LaS1j9HOBa6H4e/NpljP66DMdj5KYvgrxD14DRv1mMQpVqYbpnTDGImH+Tu9YZgmmoWdGwE5k+frCioBYTrukE3fRPg/2qsBa9xhEX2cO1GGo7CYS/6IkUQWfruVYVBbLSHpTKNCdl3uL9Zdon3nI=  ;
X-YMail-OSG: zMk2p9IVM1mqBhITAgtjNgT9ueV_MDh8DHOaurft4YeUYYBIuo1dHYqxb90e4xW32b727Y4EgQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] AT91: correct at91sam9263ek LCD power gpio pin
Date: Thu, 17 Jan 2008 01:34:16 -0800
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Andrew Victor <linux@maxim.org.za>
References: <478F1AFC.40404@atmel.com>
In-Reply-To: <478F1AFC.40404@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801170134.16516.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2008, Nicolas Ferre wrote:
>  static void at91_lcdc_power_control(int on)
>  {
>         if (on)
> -               at91_set_gpio_value(AT91_PIN_PD12, 0);  /* power up */
> +               at91_set_gpio_value(AT91_PIN_PA30, 1);  /* power up */
>         else
> -               at91_set_gpio_value(AT91_PIN_PD12, 1);  /* power down */
> +               at91_set_gpio_value(AT91_PIN_PA30, 0);  /* power down */
>  }

It would really be a lot simpler as just:

	gpio_set_value(AT91_PIN_PA30, on);

This isn't a case where SOC-specific mechanisms need to kick in
(like enabling open drain output drive mode, or input debounce);
and even the SOC-specific calls handle that "if" themselves.  :)

- Dave


