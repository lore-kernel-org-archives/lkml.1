Return-Path: <linux-kernel-owner+w=401wt.eu-S1763523AbZAOM3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763523AbZAOM3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756987AbZAOM3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:29:43 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4383 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923AbZAOM3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:29:42 -0500
Date: Thu, 15 Jan 2009 12:29:38 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
Message-ID: <20090115122937.GC2147@sirena.org.uk>
References: <200811091531.46003.david-b@pacbell.net> <200811161458.17212.david-b@pacbell.net> <20081117015127.GA10883@sirena.org.uk> <200901142303.09217.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901142303.09217.david-b@pacbell.net>
X-Cookie: <rcw> liiwi: printk("CPU0 on fire
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

")
Fcc: +sent-mail

On Wed, Jan 14, 2009 at 11:03:09PM -0800, David Brownell wrote:

> introspection.  Example:  troubleshooting, as we previously
> discussed; or, I can see some regulators that are wrongly
> enabled, primarily because of bootloader goofage.

> That raises an issue:  how can Linux get such regulators to
> turn off?  Clock frameworks have the same issue, and they
> tend to resolve this with a SoC-specific Kconfig option to
> disable unused clocks (in a late_initcall, after everthing
> has had a chance to start up).  That conserves power.

That's something that should be done by constraints - add a new flag
that can be set.

> I'm thinking it'd be worth having a similar Kconfig option
> for regulators too.  It could kick in regulator core code to
> call regulator_ops.disable() whenever regulator_dev.use_count
> is zero, possibly warning if !regulator_ops.is_disabled().
> (Handling constraints.always_on too.)

> Comments?

Given the model the API has of not doing anything unless explicitly
told to I'd not expect to see this as a Kconfig option but rather as
something enabled per regulator or at least per board.

The warning would be a bit interesting; ideally there should be one
since it's probably an indication that something is wrong but there
are probably going to be use cases for it that can't be covered by
always_on, not that I can think of any right now.
