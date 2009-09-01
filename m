Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbZIAWLC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbZIAWLC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 18:11:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbZIAWLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 18:11:01 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35011 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbZIAWLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 18:11:00 -0400
Date: Tue, 1 Sep 2009 23:10:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] AB3100 regulator support v2
Message-ID: <20090901221057.GA20242@sirena.org.uk>
References: <1251667749-31276-1-git-send-email-linus.walleij@stericsson.com> <1251722641.4254.46.camel@finisterre.sirena.org.uk> <63386a3d0908310716x1a33a8fdpddedbaf24648216f@mail.gmail.com> <20090901135123.GS19719@n2100.arm.linux.org.uk> <63386a3d0909011505oed88151i95df1e97cf131c36@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63386a3d0909011505oed88151i95df1e97cf131c36@mail.gmail.com>
X-Cookie: To do nothing is to be nothing.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 12:05:10AM +0200, Linus Walleij wrote:

> But generally speaking the AB3100 can be used on top of any
> i2c adapter and a bunch of them actually use
> wait_for_completion_interruptible_timeout();
> and wait_event_interruptible_timeout(); for example.

There was some discussion of this on the I2C list and a decision that it
was sensible to move away from doing that since it was being found to
cause more problems than it solved - the FSL driver is the one I
remember actually doing so.

> One of them being i2c/buses/i2c-imx.c actually, Mark does
> this mean you actually have the risk of being kill -9:ed in the
> middle of a regulator operation for the WM drivers, for
> example

Yes.  Pretty much any embedded I2C driver could cause issues for the
Wolfson drivers - there's a whole bunch of audio CODECs that are very
widely deployed.

> In the general sense perhaps this doesn't happen so much,

Yes, it's fairly rare which is the main reason it's not being chased
after particularly actively.
