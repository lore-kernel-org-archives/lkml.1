Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbZEZWQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbZEZWQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZEZWQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:16:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752563AbZEZWQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:16:33 -0400
Date: Tue, 26 May 2009 15:16:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tobias_Mueller@twam.info
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Jordan Crouse <jordan@cosmicpenguin.net>,
       Ben Gardner <gardner.ben@gmail.com>
Subject: Re: [PATCH 001/001] gpio: AMD CS5535/CS5536 GPIO driver
Message-Id: <20090526151621.a7446c60.akpm@linux-foundation.org>
In-Reply-To: <17be05570905230453i591eb83bnb359f6365c109718@mail.gmail.com>
References: <17be05570905230453i591eb83bnb359f6365c109718@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 May 2009 13:53:58 +0200
Tobias M__ller <Tobias_Mueller@twam.info> wrote:

> From: Tobias Mueller <Tobias_Mueller@twam.info>
> 
> A GPIO driver for AMD Geode Companion Device CS5535/CS5536
> using the GPIO framework as a replacement for old cs5535-gpio driver.

It looks reasonsable from a quick scan.

The patch was somewhat wordwrapped by your email client.

The patch generates a large number of warnings when checked with
scripts/checkpatch.pl.  Please take a look at that and permanently
incorporate checkpatch into your patch generation tools.

Please cc the following individuals on future versions of this patch:

David Brownell <david-b@pacbell.net>
Jordan Crouse <jordan@cosmicpenguin.net>
Ben Gardner <gardner.ben@gmail.com>

> index edb0253..0b7ef6f 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -67,6 +67,14 @@ config GPIO_SYSFS
> 
>  comment "Memory mapped GPIO expanders:"
> 
> +config GPIO_CS5535
> +	tristate "AMD CS5535/CS5536 (Geode Companion Device)"
> +	depends on !CONFIG_CS5535_GPIO && X86 && EXPERIMENTAL
> +	default N
> +	help
> +	  Say yes here to support GPIO pins of AMD CS5535/CS5536
> +          (Geode Companion Device)

We'll need to discuss the migration plan - we don't want to maintain
two drivers for the same thing.


