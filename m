Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZHCTWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZHCTWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbZHCTWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:22:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43210 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbZHCTWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:22:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: Re: [PATCH V2] au1xmmc: dev_pm_ops conversion
Date: Mon, 3 Aug 2009 21:23:16 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PM List <linux-pm@lists.linux-foundation.org>
References: <20090803163304.GF5002@laptop>
In-Reply-To: <20090803163304.GF5002@laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908032123.17069.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Albin Tonnerre wrote:
> On Sat, Jul 25, 2009, Frans Pop wrote:
> > Yes, I see that in drivers/base/platform.c (legacy) .suspend resp. .resume
> > also got called for those cases?
> > Ouch :-(
> 
> This really looks like it's error-prone (I made this mistake for atmel_serial
> and wouldn't have noticed if Frans hadn't told me), and AFAICS, for a number of
> drivers we'll have suspend = freeze = poweroff and resume = thaw = restore.
> Maybe putting something like this in pm.h would help ?
> 
> #define PM_OPS(name, suspend, resume) \
> struct dev_pm_ops name = { \
> 	.suspend = suspend, \
> 	.resume = resume, \
> 	.freeze = suspend, \
> 	.thaw = resume, \
> 	.poweroff = suspend, \
> 	.restore = resume, \
> };

That looks like a good idea, but please call that macro SIMPLE_PM_OPS (or
something similar) and submit a patch.

Best,
Rafael
