Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbZH3NDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbZH3NDZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 09:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbZH3NDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 09:03:24 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47402 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbZH3NDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 09:03:24 -0400
Date: Sun, 30 Aug 2009 14:03:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] AB3100 regulator support v1
Message-ID: <20090830130325.GA12123@sirena.org.uk>
References: <1250806271-24419-1-git-send-email-linus.walleij@stericsson.com> <20090821105636.GA2850@sirena.org.uk> <63386a3d0908291603i76603a17hc20a8d219c1dc07a@mail.gmail.com> <20090830103448.GD4334@sirena.org.uk> <63386a3d0908300551s9c7f69dt5b3861fa329da35a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63386a3d0908300551s9c7f69dt5b3861fa329da35a@mail.gmail.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 02:51:57PM +0200, Linus Walleij wrote:
> 2009/8/30 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> > On the face of it (and without having actually looked at a running
> > system or anything yet) I'm rather surprised that platform based MFD
> > drivers aren't running into this issue more often. ?CCing in Alan who
> > made the change.

> I think it hasn't happened a lot because most MFD:s spawn their
> platform device children at subsystem_init and then register drivers
> for them at driver_init. E.g. all the wm8350 children have their
> drivers at higher init levels, except for the regulators which are by
> chance saved by having the i2c device as parent.

The WM8350 isn't a platform device, it's an I2C device as are most if
not all of the other MFDs using subsys_initcall() - it's most being done
for the regulators (so they can be available for other drivers during
init) and regulators tend to be on buses like I2C with low pin counts.
There are other MFDs which are memory mapped and therefore based on
platform devices.  These are the devices I'm talking about above.

The bodges with initcall levels will only work when drivers are built in
- as soon as things move into modules things crop up again with these
memory mapped devices since the subdevices tend not to need to link into
the core so often like those on other buses do.
