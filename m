Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbXLJQQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbXLJQQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 11:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbXLJQQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 11:16:12 -0500
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:52001 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752020AbXLJQQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 11:16:11 -0500
Date: Mon, 10 Dec 2007 17:16:09 +0100
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       eric miao <eric.y.miao@marvell.com>
Subject: Re: [patch 2.6.24-rc4-mm 4/6] gpiolib:  create empty drivers/gpio
Message-ID: <20071210171609.0d4738b8@hyperion.delvare>
In-Reply-To: <200712092039.57722.david-b@pacbell.net>
References: <200712092022.14062.david-b@pacbell.net>
	<200712092039.57722.david-b@pacbell.net>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sun, 9 Dec 2007 20:39:57 -0800, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Add an empty drivers/gpio directory for gpiolib based GPIO expanders.
> We already have three of them (two I2C, one SPI), and there are dozens
> of similar chips that only exist for GPIO expansion.
> 
> This won't be the only place to hold such gpio_chip code.  Many external
> chips add a few GPIOs as secondary functionality, and platform code
> frequently needs to closely integrate GPIO and IRQ support.
> 
> This is placed *early* in the build/link sequence since it's common for
> other drivers to depend on GPIOs to do their work, so they need to be
> initialized early in the device_initcall() sequence.

Note that I foresee potential problems with this. These GPIO drivers
need I2C or SPI to be initialized before they can load. However on some
systems, I2C or SPI buses are hanging off GPIOs, meaning that these
GPIOS need to be initialized before I2C or SPI, respectively. I can
imagine weird setups where for example an SPI bus would be driven by an
I2C-based GPIO chip, or vice-versa. I sure hope that nobody does this,
but you never know... And I'm not sure how we would possibly support
this.

-- 
Jean Delvare
