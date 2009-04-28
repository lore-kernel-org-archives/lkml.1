Return-Path: <linux-kernel-owner+w=401wt.eu-S1760418AbZD1LP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760418AbZD1LP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758950AbZD1LPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:15:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52997 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758922AbZD1LPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:15:46 -0400
Date: Tue, 28 Apr 2009 13:15:32 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: David Brownell <david-b@pacbell.net>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [spi-devel-general] [PATCH v2] spi: Add support for the
	OpenCores SPI controller.
Message-ID: <20090428111532.GA14422@avionic-design.de>
References: <200904041227.54687.david-b@pacbell.net> <1240916464-4187-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240916464-4187-1-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Provags-ID: V01U2FsdGVkX184m94gi8Xp+gLEAheAPghxy15teY3o2gOYnSq
 3LkA8Cljo5plHHW1HQLjiwut7jo6ZXy/HPrmSMAhO1BEx0mT+j
 W9x+qgfEKBW4LG/ye390Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thierry Reding wrote:
> This patch adds a platform device driver that supports the OpenCores SPI
> controller.
> 
> The driver expects two resources: an IORESOURCE_MEM resource defining the
> core's memory-mapped registers and an IORESOURCE_IRQ for the associated
> interrupt. It also requires a clock, "spi-master-clk", used to compute the
> clock divider.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
[snip]

This second version is pretty much a rewrite. Some notes about the most
important changes:

  * uses per-chip states to allow more slaves to use the controller
    concurrently
  * rejects invalid device configurations during setup
  * rejects invalid per-message and per-transfer options
  * queues messages so that they can be processed one after another
      - this also provides for a way to handle power-management
  * omits the spioc.h (and with it the platform data structure):
      - uses the platform_device.id for the bus number
      - always uses 8 chipselects because that's the maximum that the core
        supports

I couldn't really find a way to implement per-transfer overrides for the
word size because the controller simply has no concept of word sizes. Is it
in such cases still necessary to hardwire the word size to 8 bits?

Thierry

