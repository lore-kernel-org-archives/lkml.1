Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbZHJV6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbZHJV6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 17:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbZHJV6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 17:58:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42878 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbZHJV6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 17:58:12 -0400
Date: Mon, 10 Aug 2009 22:58:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Mike Rapoport <mike@compulab.co.il>,
       linux-kernel@vger.kernel.org
Message-ID: <20090810215800.GB4528@sirena.org.uk>
References: <20090810200553.GB4652@gandalf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810200553.GB4652@gandalf>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Question about userspace-consumer
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 11:05:54PM +0300, Felipe Balbi wrote:

> I was reading userspace-consumer file ad was wondering whether would be
> possible to use that in order to implement what SBS-IF [1] proposes
> using sbs-enabled devices.

Looking at that I'm not sure why you wish to push this into user space?

The existing drivers for this sort of functionality are all regular
kernel drivers (in drivers/power and to a lesser extent drivers/hwmon)
and it looks like it'd be at least as much work to rearrange the power
supply stuff to support userspace drivers.  My initial expectation would
be for a generic driver with some policy exposed to user space and some
configuration exposed for architecture code (especially for setting up
multi-battery board layouts and things).  That's not a terribly informed
opinion, though.

> For doing that, probably userspace-consumer would have to be able to
> set_voltage/get_voltage, set/get_current_limit and so on. So I was
> thinking on changing userspace-consumer to use regulator_get() instead
> of regulator_bulk_get() and make each instance of userspace-consumer to
> talk to only and only one regulator.

I'd like to preserve the bulk switch if possible - part of the thinking
was that things with more complex needs may well find it easier and/or
more robust to have custom kernel stubs which mapped one or more
regulators into the interfaces they needed.  That was more for things
like working out which of multiple supplies is which, though.

The existing virtual consumer, while intended as a test harness
originally and rather clunky as-is, is much closer to your needs.  It is
the way it is partly as a sign that you really shouldn't be using it in
production (which seems to be working!).

> Anyways, how do you guys feel about it ?

Like I say, from a quick read through of the specs I'm not sure that I'd
push this into user space but I've not thought about this deeply and may
be missing something.
