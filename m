Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbYBXWg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbYBXWg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 17:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYBXWgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 17:36:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54780 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbYBXWgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 17:36:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Julian Blake Kongslie <jblake@omgwallhack.org>
Subject: Re: Hang on suspend
Date: Sun, 24 Feb 2008 23:35:01 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <1203553943.4422.25.camel@dukephillips.omgwallhack.org> <200802241223.46930.rjw@sisk.pl> <1203887415.4154.4.camel@dukephillips.omgwallhack.org>
In-Reply-To: <1203887415.4154.4.camel@dukephillips.omgwallhack.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802242335.01800.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Please don't drop the CC list from replies.]

On Sunday, 24 of February 2008, Julian Blake Kongslie wrote:
> On Sun, 2008-02-24 at 12:23 +0100, Rafael J. Wysocki wrote:
> > Can you please check what's at the address platform_suspend_late+0x19?
> 
> 0xc0253ca9 is in platform_suspend_late (drivers/base/platform.c:579).
> 574	{
> 575		struct platform_driver *drv = to_platform_driver(dev->driver);
> 576		struct platform_device *pdev;
> 577		int ret = 0;
> 578	
> 579		pdev = container_of(dev, struct platform_device, dev);
> 580		if (dev->driver && drv->suspend_late)
> 581			ret = drv->suspend_late(pdev, mesg);
> 582	
> 583		return ret;

That's strange, it looks like the container_of() accessing beyond the
structure.

Is this 100% reproducible?

Rafael
