Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbYDRGCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbYDRGCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 02:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYDRGCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 02:02:13 -0400
Received: from mail1.physik.fu-berlin.de ([160.45.35.12]:52179 "EHLO
	mail1.physik.fu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbYDRGCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 02:02:12 -0400
Subject: Re: [PATCH] usb-serial: option: Don't match Huawei driver CD images
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: Greg KH <greg@kroah.com>
Cc: smurf@smurf.noris.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <20080418032405.GB8754@kroah.com>
References: <1208472569.14194.5.camel@hermes2.karcher.local>
	 <20080418032405.GB8754@kroah.com>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 08:01:34 +0200
Message-Id: <1208498494.14194.28.camel@hermes2.karcher.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-HELO-Warning: Remote host 89.247.224.62 (i59f7e03e.versanet.de) incorrectly presented itself as [192.168.0.121]
X-ZEDV-Virus-Scanned: No viruses found. [ClamAV 0.92/6817/Fri Apr 18 03:15:07 2008]
X-ZEDV-Spam-Level: ----
X-ZEDV-Spam-Checker-Version: SpamAssassin 3.2.3 (2007-08-08) on zs01.physik.fu-berlin.de
X-ZEDV-Spam-Status: No, score=-4.4 required=5.0 tests=ALL_TRUSTED,BAYES_00 autolearn=ham version=3.2.3
X-ZEDV-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
X-Scan-Signature: 573c884b685e4c0b3a02a2d482af22fc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 17.04.2008, 20:24 -0700 schrieb Greg KH:
> What is this patch against?  We have a change that went into 2.6.25
> after 2.6.25-rc9 that should make this patch not be needed.
The patch is developed against 2.6.25-rc8 + some git patches, but I have
forward-ported it to current git.

I *guess* you are talking about commit aad8a278 (USB: support more
Huawei data card product IDs), as I could not find . The header of this
patch talks about three changes (declaration of unusual devices,
disabling product ID matching in driver.c and finally declaring the
product in option.c). I find only the first and the last point if this
reflected in the patch, and there are *no* patches at all to
drivers/usb/core/driver.c in the timeframe you mentioned. This patch
addresses the second point of that list, but in another way.

The problem is that those huawei products have four USB interfaces,
three usb-serial like interfaces handled by the option driver and a
fourth one to be handled by usb-storage. When the stick gets initially
plugged, only the mass storage device is visible and needs a magic kick
to expose the other interfaces. aad8a278 contains a valid and working
patch to kick those USB devices if the mass storage interface gets bound
by usb-storage. At least in 2.6.25-rc8, if the option module is loaded,
the mass storage device gets bound to the option driver instead that
exposes a useless and non-functional serial interface on the mass
storage endpoint. This prevents the usb-storage driver to perform the
needed kicking.

> Can you try that release and verify this?
I will try with a current git kernel without my patch and report back,
but I will be surprised if the problem described above is gone. System
is currently compiling.

> thanks,
You're welcome.

Kind regards,
  Michael Karcher


