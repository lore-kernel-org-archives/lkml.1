Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbZISXJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbZISXJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 19:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbZISXJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 19:09:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:23439 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbZISXJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 19:09:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,416,1249282800"; 
   d="scan'208";a="189516030"
Subject: Re: [PATCH] move sh_flctl's probe function to .devinit.text
From: David Woodhouse <david.woodhouse@intel.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1247345591-22643-11-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090711170548.GC5205@suse.de>
	 <1247345591-22643-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1247345591-22643-2-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1247345591-22643-3-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1247345591-22643-4-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1247345591-22643-5-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1247345591-22643-6-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1247345591-22643-7-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1247345591-22643-8-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1247345591-22643-9-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1247345591-22643-10-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1247345591-22643-11-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation. Pipers Way, Swindon, Wiltshire, SN3 1RJ,
 UK.
Date: Sat, 19 Sep 2009 16:09:54 -0700
Message-Id: <1253401794.6317.50.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-11 at 13:52 -0700, Uwe Kleine-König wrote:
> A pointer to flctl_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
> 
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.

... which is what you did for orion_nand, so let's do that for sh_flctl
too.

http://git.infradead.org/mtd-2.6.git/commitdiff/894572a3635

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

