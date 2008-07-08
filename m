Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbYGHXrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbYGHXrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbYGHXrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:47:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:31198 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbYGHXrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:47:31 -0400
Message-ID: <1d3f23370807081647y446534dp6db16f560e4e0a2d@mail.gmail.com>
Date: Wed, 9 Jul 2008 09:47:29 +1000
From: "John Williams" <john.williams@petalogix.com>
To: monstr@monstr.eu
Subject: Re: [PATCH 19/58] microblaze_v5: early_printk support
Cc: linux-kernel@vger.kernel.org, monstr@seznam.cz, arnd@arndb.de,
       linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org
In-Reply-To: <2aa1ac7891af57959237aae3addf4bbe607f55d7.1215517976.git.monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
	 <2aa1ac7891af57959237aae3addf4bbe607f55d7.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +++ b/arch/microblaze/kernel/early_printk.c
> @@ -0,0 +1,130 @@

> +#ifdef CONFIG_EARLY_PRINTK
> +#define BASE_ADDR ((unsigned char *)CONFIG_EARLY_PRINTK_UARTLITE_ADDRESS)

This is a problem - default value of EARLY_PRINTK_UARTLITE_ADDRESS is
0x0, so by default the kernel will try to access a uartlite at 0x0
which is the reset vector!  I know there is the test in the actual
output routine but it's not good to rely on that in the default case.

Can we either

#if CONFIG_EARLY_PRINTK_UARTLITE_ADDRESS==0
#warning EARLY_PRINTK address not set, disabling
...
#else
..
#endif

or query the OF subsystem (is it up yet?), and default to using the
first uartlite in the system for early printk?

John
