Return-Path: <linux-kernel-owner+w=401wt.eu-S966902AbXEHR1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966902AbXEHR1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966292AbXEHR1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:27:46 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:52288 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966876AbXEHR1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:27:45 -0400
Date: Tue, 8 May 2007 19:26:55 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net,
       Andrew Victor <andrew@sanpeople.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] atmel_lcdfb: AT91/AT32 LCD
 Controller framebuffer driver
Message-ID: <20070508192655.08b1d649@dhcp-252-105.norway.atmel.com>
In-Reply-To: <1178574017.4674.30.camel@daplas>
References: <463F3388.7020102@rfo.atmel.com>
	<1178574017.4674.30.camel@daplas>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antonio,

Thanks for the feedback. I'm just going to reply to one of your
comments and leave the rest for Nicolas...

On Tue, 08 May 2007 05:40:17 +0800
"Antonino A. Daplas" <adaplas@gmail.com> wrote:

> > +static int __init atmel_lcdfb_init(void)
> > +{
> > +	return platform_driver_probe(&atmel_lcdfb_driver, atmel_lcdfb_probe);
> > +}  
> 
> Is this intentional?  Why not platform_driver_register()?

Yes, it's intentional. This way, the atmel_lcdfb_probe function can be
__init since it doesn't need to be referenced from atmel_lcdfb_driver.
Saves a bit of memory at run time.

The downside is that hot plugging won't work, but that isn't very
relevant for on-chip devices anyway.

Haavard
