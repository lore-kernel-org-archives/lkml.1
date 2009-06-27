Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbZF0As3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbZF0As3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 20:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZF0AsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 20:48:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47546 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbZF0AsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 20:48:19 -0400
Date: Sat, 27 Jun 2009 01:48:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Pierre Ossman <pierre@ossman.eu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Eric Miao <eric.y.miao@gmail.com>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Message-ID: <20090627004814.GB4379@sirena.org.uk>
References: <1246057668.10360.316.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246057668.10360.316.camel@brutus>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] MMC/pxamci: workaround regulator framework bugs
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 08:07:48PM -0300, Daniel Ribeiro wrote:
> The voltage regulator framework can't sanely deal with voltage
> regulators which are left enabled by the bootloader. We workaround this
> by forcing an enable()/disable() pair so it has a sane use_count.

Please write a commit message explaining what the actual situation is
here.  Ideally this would include some documentation for the MMC core 
explaining the requirements it has.  The fact that you're trying to
force the regulator off is a big warning sign for the more common
non-exclusive consumers so you need to be clear about why this is
required.

> +		/*
> +		 * When the bootloader leaves a supply active, it's
> +		 * initialized with zero usecount ... and we can't
> +		 * disable it without first enabling it.  Until the
> +		 * framework is fixed, we need a workaround like this
> +		 * (which is safe for MMC, but not in general).

This also needs to explain the actual situation, especially the
exclusivity reqirement of the MMC core.  It might be worth providing a
helper in the MMC core, everything is going to need to be updated to use
exclusive get whenever someone implements it.

As discussed at some length the regulator API is not going to be changed
in the way you demand.  This is not something that it should be easy for
standard consumers to do since for standard consumers it normally points
out a programming error.
