Return-Path: <linux-kernel-owner+w=401wt.eu-S1751227AbYA3Aht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227AbYA3Aht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbYA3Ahl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:37:41 -0500
Received: from ms01.sssup.it ([193.205.80.99]:59648 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751244AbYA3Ahk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:37:40 -0500
Message-ID: <479FC6D2.7040707@gandalf.sssup.it>
Date: Wed, 30 Jan 2008 01:37:38 +0100
From: michael <trimarchi@gandalf.sssup.it>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Andrew Victor <linux@maxim.org.za>
Subject: Re: at91sam9260 wakeup on serial port
References: <479DB934.6090806@gandalf.sssup.it>	<20080128145615.1d756025@dhcp-252-066.norway.atmel.com>	<200801281021.57317.david-b@pacbell.net> <20080128195114.33d7616d@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080128195114.33d7616d@dhcp-252-066.norway.atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> On Mon, 28 Jan 2008 10:21:57 -0800
> David Brownell <david-b@pacbell.net> wrote:
>
> There's a separate WAKE_N pin that is completely asynchronous, so with
> some external logic, we can probably wake up the CPU all the way from
> Static mode if a given input state is present. But that's definitely
> "board specific" territory, and starting the oscillators take a _long_
> time on the AP7000 (especially the 32 kHz, but then again, it barely
> consumes any power, so we might as well keep it running and keep the
> RTC going as well.)
>   
Maybe is possible to create a generic device based on the gpio to provide
wakeup solutions on suspend-ram state to the peripherals
that registered to him

serial->register_gpio_wakeup             x_driver->register_gpio_wakeup 
          

serial->suspend                          x_driver
    |                                        |
    |                                        |
    \------> gpio_power->suspend <-----------/

serial->resume                           x_driver
    |                                        |
    |                                        |
    \------> gpio_power->resume <------------/

               |----request_irq n1
gpio_power-----|----request_irq n2
               |----request_irq n3

Create an attribute on the sysfs to add a wakeup reason to the user space.

Regards Michael

