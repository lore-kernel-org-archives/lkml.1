Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZGNIJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZGNIJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 04:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbZGNIJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 04:09:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36095 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbZGNIJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 04:09:52 -0400
Date: Tue, 14 Jul 2009 10:09:47 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Nicolas Pitre <nico@marvell.com>
Cc: Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Lennert Buijtenhek <buytenh@marvell.com>,
       Saeed Bishara <saeed@marvell.com>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] move orion_nand's probe function to .devinit.text
Message-ID: <20090714080947.GA2896@pengutronix.de>
References: <1247345591-22643-18-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-19-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-20-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-21-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-22-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-23-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-24-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-25-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-26-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.0907131536070.3138@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0907131536070.3138@xanadu.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On Mon, Jul 13, 2009 at 03:37:23PM -0400, Nicolas Pitre wrote:
> On Sat, 11 Jul 2009, Uwe Kleine-König wrote:
> 
> > A pointer to orion_nand_probe is passed to the core via
> > platform_driver_register and so the function must not disappear when the
> > .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> > unbinding and binding a device to the driver via sysfs will result in an
> > oops as does a device being registered late.
> > 
> > An alternative to this patch is using platform_driver_probe instead of
> > platform_driver_register plus removing the pointer to the probe function
> > from the struct platform_driver.
> 
> For those kind of platform devices I'd prefer the alternative.
Can I interpret that as your intend to implement and test it?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
