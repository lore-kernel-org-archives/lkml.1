Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab0CATmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:42:32 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:50843 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab0CATma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:42:30 -0500
Date: Mon, 1 Mar 2010 14:41:53 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: Ben Gardner <gardner.ben@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] gpio: cs5535-gpio: fix input direction
Message-ID: <20100301144153.735690aa@droptest.queued.net>
In-Reply-To: <808c8e9d1003010804r331d39a6g9cf520cb27595e75@mail.gmail.com>
References: <808c8e9d1003010804r331d39a6g9cf520cb27595e75@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Mar 2010 10:04:19 -0600
Ben Gardner <gardner.ben@gmail.com> wrote:

> gpio: cs5535-gpio: fix input direction
> 
> The cs5535-gpio driver's get() function was returning the output value.
> This means that the GPIO pins would never work as an input, even if configured
> as an input.
> The driver should return the READ_BACK value, which is the sensed line value.
> To make that work when the direction is 'output', INPUT_ENABLE needs to be set.
> 
> In addition, the driver was not disabling OUTPUT_ENABLE when the
> direction is set to 'input'. That would cause the GPIO to continue to
> drive the pin if the direction was ever set to output.
> 
> This issue was noticed when attempting to use the gpiolib driver to read
> an external input. I had previously been using the char/cs5535-gpio driver.
> 
> This patch should also be applied to 2.6.33.x, as that is the first version
> that contains the gpio/cs5535-gpio driver.
> 
> Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
> CC: Andres Salomon <dilinger@collabora.co.uk>

Looked it over and tested it, seems fine to me.  Thanks!


Acked-by: Andres Salomon <dilinger@collabora.co.uk>
