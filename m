Return-Path: <linux-kernel-owner+w=401wt.eu-S934830AbZLKXfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934830AbZLKXfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934401AbZLKXeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:34:01 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34812 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933946AbZLKX3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:24 -0500
Date: Fri, 11 Dec 2009 23:28:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Ryan Mallon <ryan@bluewatersys.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: GPIO support for HTC Dream
Message-ID: <20091211232838.GE12628@n2100.arm.linux.org.uk>
References: <20091208102842.GH12264@elf.ucw.cz> <4B1EB57D.6070408@bluewatersys.com> <20091208214658.GC4164@elf.ucw.cz> <4B1ECEEE.3000209@bluewatersys.com> <4B203575.6050407@bluewatersys.com> <20091210172458.GJ19454@elf.ucw.cz> <4B2150B7.3040207@bluewatersys.com> <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com> <20091211221015.GB24456@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211221015.GB24456@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 11:10:15PM +0100, Pavel Machek wrote:
> +#include <linux/gpio.h>
...
> +#include <mach/gpio.h>
...
> +#include <asm/gpio.h>

Emm, this is getting really silly.

include/linux/gpio.h:
  
  #ifdef CONFIG_GENERIC_GPIO
  #include <asm/gpio.h>
  #else
  ...
  #endif

arch/arm/include/asm/gpio.h:

  #include <mach/gpio.h>

There really is no point in including mach/gpio.h nor asm/gpio.h when
linux/gpio.h will do.  I'm retiscent to add #warnings or #errors into
these files, but it seems that this is such a common thing that it may
be beneficial to do so.
