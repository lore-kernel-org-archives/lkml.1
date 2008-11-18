Return-Path: <linux-kernel-owner+w=401wt.eu-S1752442AbYKRKwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbYKRKwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 05:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYKRKwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 05:52:23 -0500
Received: from www.tglx.de ([62.245.132.106]:43875 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbYKRKwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 05:52:22 -0500
Message-ID: <49229E59.8040306@linutronix.de>
Date: Tue, 18 Nov 2008 11:52:09 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH] USB/ISP1760: Add support for the generic platfrom device
 centralized driver model (v2)
References: <1227000093-19034-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1227000093-19034-1-git-send-email-cooloney@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> v2-v1:
>  - cleanup style issue
>  - add Kconfig option CONFIG_USB_ISP1760_PDEV
>  - isp1760 interrupt is default setup TRIGGER_LOW
Trigger low should be fine.

> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/usb/host/Kconfig      |    6 +++
>  drivers/usb/host/isp1760-if.c |   95 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/usb/isp1760.h   |   19 ++++++++
>  3 files changed, 120 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/usb/isp1760.h
> 
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 427b3ac..1e38e8a 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -123,6 +123,12 @@ config USB_ISP1760_HCD
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called isp1760.
>  
> +config USB_ISP1760_PDEV
> +	bool "Support for the generic platfrom device driver model"
> +	depends on USB_ISP1760_HCD
> +	---help---
> +	  Enables support for the generic platfrom device centralized driver model
> +

This is probably a misunderstanding. In the previous email I was refering 
the patch [1] which removes the Kconfig entries and makes it 
unconditional. Since platform device are always available we can get rid 
of depend on PCI || OF in Kconfig and depend just on USB same like isp116x 
does. The patch I am refering to is mainline so this won't apply, sorry.
I'm fine with the other parts of the patch.

[1] http://marc.info/?l=linux-usb&m=122563596420156&w=2


Sebastian
