Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbZF2Jnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbZF2Jnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757850AbZF2JnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:43:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43645 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544AbZF2JnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:43:11 -0400
Date: Mon, 29 Jun 2009 10:43:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Daniel Ribeiro <drwyrm@gmail.com>, Pierre Ossman <pierre@ossman.eu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 1/2] MMC/pxamci: workaround regulator framework bugs
Message-ID: <20090629094311.GD11855@sirena.org.uk>
References: <1246057668.10360.316.camel@brutus> <20090627004814.GB4379@sirena.org.uk> <1246071323.10360.386.camel@brutus> <4A482E56.1070604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A482E56.1070604@gmail.com>
X-Cookie: Function reject.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 11:00:38AM +0800, Eric Miao wrote:

> This looks to be running into the same issue as clocks - where for power
> savings the clocks are assumed to be off as many as possible, leaving only
> those essential ones enabled, yet the assumption of the boot loader does
> this correctly is always a big problem, putting this into the kernel,
> however, is ugly.

At the minute the regulator API actually copes pretty well with this -
the only problem I'm aware of is with drivers like the MMC driver which
require exclusive control of the regulator.  With other drivers the core
API can clean up after startup and the drivers never need to worry about
fixing things up.
