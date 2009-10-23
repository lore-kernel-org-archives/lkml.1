Return-Path: <linux-kernel-owner+w=401wt.eu-S1752127AbZJWU0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbZJWU0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 16:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbZJWU0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 16:26:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58359 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZJWU0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 16:26:21 -0400
Date: Fri, 23 Oct 2009 22:26:22 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: platform_device_add_data(pdev, NULL, 0)
Message-ID: <20091023202622.GA11843@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

mfd_add_device() (defined in drivers/mfd/mfd-core.c) is a wrapper do
allocate platform_devices.

It contains:

	ret = platform_device_add_data(pdev,
			cell->platform_data, cell->data_size);

If cell->data_size is 0 (and so likely cell->platform_data == NULL),
still pdev->dev.platform_data get assigned ZERO_SIZE_PTR.

IMHO the result should better be that pdev->dev.platform_data ends being
NULL, too.  Agreed?

If yes, where is the right place to fix that, mfd_add_device() or
platform_device_add_data()?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
