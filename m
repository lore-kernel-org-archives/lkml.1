Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbZGVFRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbZGVFRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 01:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZGVFRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 01:17:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41277 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbZGVFRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 01:17:43 -0400
Date: Wed, 22 Jul 2009 07:17:39 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Nicolas Pitre <nico@marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Lennert Buijtenhek <buytenh@marvell.com>,
       Saeed Bishara <saeed@marvell.com>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Woodhouse <dwmw2@infradead.org>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] register orion_nand using platform_driver_probe
Message-ID: <20090722051739.GA614@pengutronix.de>
References: <alpine.LFD.2.00.0907141211260.3138@xanadu.home> <1248209196-15705-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.0907211822330.30629@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0907211822330.30629@xanadu.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On Tue, Jul 21, 2009 at 06:26:50PM -0400, Nicolas Pitre wrote:
> On Tue, 21 Jul 2009, Uwe Kleine-König wrote:
> 
> > orion_nand_probe lives in .init.text, so using platform_driver_register
> > to register it is wrong because binding a device after the init memory
> > is discarded (e.g. via sysfs) results in an oops.
> > 
> > As requested by Nicolas Pitre platform_driver_probe is used instead of
> > moving the probe function to .devinit.text as proposed initially.
> > This saves some memory, but devices registered after the driver is
> > probed are not bound (probably there are none) and binding via sysfs
> > isn't possible.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Cc: Lennert Buytenhek <buytenh@marvell.com>
> > Cc: Saeed Bishara <saeed@marvell.com>
> > Cc: Jörn Engel <joern@logfs.org>
> > Cc: Nicolas Pitre <nico@marvell.com>
> > Cc: Tzachi Perelstein <tzachi@marvell.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Cc: David Woodhouse <dwmw2@infradead.org>
> > Cc: linux-mtd@lists.infradead.org
> 
> Acked-by: Nicolas Pitre <nico@marvell.com>
Did you test if all devices bind as expected?
 
> Thanks.  BTW Tzachi's email address is no longer valid.
Yes, I got a mail from Marvell's mailer daemon stating the same.  :-)

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
