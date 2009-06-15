Return-Path: <linux-kernel-owner+w=401wt.eu-S1761413AbZFOOea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761413AbZFOOea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761264AbZFOOeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:34:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57552 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761158AbZFOOeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:34:14 -0400
Date: Mon, 15 Jun 2009 15:34:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: Samuel Ortiz <sameo@linux.intel.com>, eric miao <eric.y.miao@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd/da903x: initialize PMIC core early
Message-ID: <20090615143410.GE6106@sirena.org.uk>
References: <4A363841.5090406@compulab.co.il> <20090615135117.GC4094@sortiz.org> <4A3655DC.9090407@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3655DC.9090407@compulab.co.il>
X-Cookie: Prunes give you a run for your money.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 05:08:28PM +0300, Mike Rapoport wrote:
> Samuel Ortiz wrote:

> > Sure. Care to explain why this needs to be called earlier ?

> We want to have da903x regulators available early during boot, and since they
> are subdevices of mfd/da903x they cannot be enabled until the da903x core is
> initialized.
> I just saw Liam Girdwood pull request with "regulator: Move regulator drivers to
> subsys_initcall()" commit and jumped in :)

Any MFD core with regulators on it ought to be pulled forward to
subsys_initcall().  Doing this makes it easier to get a sensible
ordering during boot without having a song and dance in consumer
drivers waiting for the regulators that supply them to instantiate.
