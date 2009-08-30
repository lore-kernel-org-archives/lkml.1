Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbZH3KJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbZH3KJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 06:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZH3KJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 06:09:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44584 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbZH3KJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 06:09:04 -0400
Date: Sun, 30 Aug 2009 11:08:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk
Message-ID: <20090830100857.GC4334@sirena.org.uk>
References: <1250806271-24419-1-git-send-email-linus.walleij@stericsson.com>
 <20090821105636.GA2850@sirena.org.uk>
 <63386a3d0908291603i76603a17hc20a8d219c1dc07a@mail.gmail.com>
 <63386a3d0908291737m5a17eaddxd3c39471553cf500@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63386a3d0908291737m5a17eaddxd3c39471553cf500@mail.gmail.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.6.104.141
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] AB3100 regulator support v1
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 02:37:51AM +0200, Linus Walleij wrote:
> 2009/8/30 Linus Walleij <linus.ml.walleij@gmail.com>:

> > So this is because I am in the parents probe() function of course,
> > and it's all expected.

> I was curious how wm8350 on MX31 did this while using only subsys_initcalls()
> (wm8400 doesn't look like it's completed yet) and found:

What makes you say that wm8400 is not completed?  If you're looking for
a current example of regulator driver probing the most current regulator
drivers I've merged are the wm831x drivers in -next via the MFD tree.
Though...

> which creates a platform device and sets the parent to
> the struct wm8350->dev. But this is actually the i2c_client dev
> and then it is not so strange that it works nicely to have both
> the 8350 core device as parent and the platform devices as
> children in a subsys_initcall() since the i2c core does not
> use the regular device driver matching scheme, but rolls it's
> own (which does NOT try to take the parent's semaphore...)

...though since the WM8400 and WM831x are I2C/SPI devices too they won't
have this issue.
