Return-Path: <linux-kernel-owner+w=401wt.eu-S1422649AbXCBATL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422649AbXCBATL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 19:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422650AbXCBATL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 19:19:11 -0500
Received: from mail.velocitynet.com.au ([203.17.154.25]:49067 "EHLO
	m0.velocity.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422649AbXCBATJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 19:19:09 -0500
Message-ID: <45E76D65.30405@iinet.net.au>
Date: Fri, 02 Mar 2007 11:18:45 +1100
From: Ben Nizette <ben.nizette@iinet.net.au>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Dmitry Torokhov <dtor@mail.ru>, pHilipp Zabel <philipp.zabel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.21-rc2] gpio_keys driver shouldn't be ARM-specific
References: <200703011551.29696.david-b@pacbell.net>
In-Reply-To: <200703011551.29696.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> The gpio_keys driver is wrongly ARM-specific; it can't build on
> other platforms with GPIO suport.  This fixes that problem.
> 
I did up a similar patch a few days back, you beat me too it ;).  I've 
been using this driver on AVR32 for a while now.

The other thing was that this driver only depends on the machine 
supporting your generic GPIO conventions.  Currently the Kconfig entry 
for gpio_keys reads:

	depends on (ARCH_SA1100 || ARCH_PXA || ARCH_S3C2410)

With the || AVR32 I've added to my version it's getting a bit out of 
hand!  Anyone else think it would be worth introducing a GPIO_FRAMEWORK 
symbol selected by each machine which supports it and just set the 
gpio_keys dependency to that?

Ben.
