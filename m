Return-Path: <linux-kernel-owner+w=401wt.eu-S1762060AbYF0TKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762060AbYF0TKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 15:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756842AbYF0TKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 15:10:38 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:45435 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756818AbYF0TKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 15:10:37 -0400
Date: Fri, 27 Jun 2008 21:10:14 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, kernel@avr32linux.org,
       shannon.nelson@intel.com, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v4 6/6] Atmel MCI: Driver for Atmel on-chip MMC
 controllers
Message-ID: <20080627211014.0e80db04@siona.local>
In-Reply-To: <1214486603-23655-7-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-4-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-5-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-6-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-7-git-send-email-haavard.skinnemoen@atmel.com>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jun 2008 19:10:16.0140 (UTC) FILETIME=[6ED178C0:01C8D889]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 15:23:23 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> This driver can also use PIO transfers when no DMA channels are
> available, and for transfers where using DMA may be difficult or
> impractical for some reason (e.g. the DMA setup overhead is usually
> not worth it for very short transfers, and badly aligned buffers or
> lengths are difficult to handle.)

Btw, it's probably not that hard to rip the DMA bits out and post them
as a separate patch. This would mean that:
  * Pierre can merge the driver independently of the other 5 patches
  * A separate patch adding DMA support would make it clearer how the
    DMA slave interface is used.
  * The chances of having MMC support out of the box on avr32 boards in
    2.6.27 become greater, and many people have been asking about that
    (including Pierre and David.)

The driver is surprisingly fast with DMA turned off (2-3 MiB/s), but
the CPU usage is of course horrible.

If that sounds like a good plan to you, I'll split the driver tomorrow.

This driver has been out of tree for way too long. I'm hoping we can
get it in before 2.6.27.

Haavard
