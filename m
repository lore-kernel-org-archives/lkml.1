Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361Ab0BDU3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:29:12 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:50155 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877Ab0BDU3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:29:10 -0500
Date: Thu, 4 Feb 2010 21:25:07 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>,
       Henrik Kretzschmar <henne@nachtwindheim.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Kay Sievers <kay.sievers@vrfy.org>, peter fuerst <post@pfrst.de>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH 2/9] platform-drivers: move probe to .devinit.text in
 drivers/scsi
Message-ID: <20100204202507.GA24912@linux-mips.org>
References: <20100203150850.GA28815@kroah.com>
 <1265313417-5568-2-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1265313417-5568-2-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 08:56:50PM +0100, Uwe Kleine-König wrote:

> A pointer to a probe callback is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
> 
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.

sgiwd93 bits looks good, so

Acked-by: Ralf Baechle <ralf@linux-mips.org>

The IP22 hardware doesn't support hotplugging so this bug isn't dangerous.

  Ralf
