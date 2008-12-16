Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbYLPK1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbYLPK1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 05:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYLPK1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 05:27:37 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3284 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbYLPK1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 05:27:36 -0500
Date: Tue, 16 Dec 2008 10:27:34 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: linux-kernel@vger.kernel.org, Andy Green <andy@openmoko.com>,
       Liam Girdwood <lrg@simlogic.co.uk>
Subject: Re: [PATCH 7/7] regulator: PCF50633 pmic driver
Message-ID: <20081216102734.GE24405@sirena.org.uk>
References: <20081214110152.3307.50843.stgit@cff.thadambail> <20081214110400.3307.57681.stgit@cff.thadambail> <20081215113547.GC31145@sirena.org.uk> <20081215140448.GA2625@cff.thadambail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081215140448.GA2625@cff.thadambail>
X-Cookie: No line available at 300 baud.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 07:34:50PM +0530, Balaji Rao wrote:
> On Mon, Dec 15, 2008 at 11:35:49AM +0000, Mark Brown wrote:
> > On Sun, Dec 14, 2008 at 04:34:00PM +0530, Balaji Rao wrote:

> > > +	.set_suspend_enable = pcf50633_regulator_enable,
> > > +	.set_suspend_disable = pcf50633_regulator_disable,

> > Are you sure that the suspend variants of the operations should be the
> > same as the regular versions?

> Yes, basically the chip doesn't change state during suspend/resume.
> We just enable or disable them the usual way.

In that case you shouldn't be providing these variants - they are for
configuring alternative settings which can be switched to in hardware
when the system suspends.  If the regular functions should be used then
the code to do this should be in the core since the same thing will be
needed for all regulators that don't have the hardware support.
