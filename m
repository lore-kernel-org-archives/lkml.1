Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYLBNcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYLBNcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbYLBNcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:32:32 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3382 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbYLBNcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:32:31 -0500
Date: Tue, 2 Dec 2008 13:32:28 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: lrg@slimlogic.co.uk, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.28-rc7] regulator: catch some registration errors
Message-ID: <20081202133228.GD7940@sirena.org.uk>
References: <200812011335.43551.david-b@pacbell.net> <20081201225312.GA6699@sirena.org.uk> <200812012150.36342.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812012150.36342.david-b@pacbell.net>
X-Cookie: Did I do an INCORRECT THING??
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 09:50:35PM -0800, David Brownell wrote:

> Prevent registration of duplicate "struct regulator" names.
> They'd be unavailable, and clearly indicate something wrong.

This bit is good but...

> Also make sure the consumer device is provided.  It's nonsensical
> to omit these, and not a documented part of the interface.  Since
> no code in mainline does such stuff, this is just anti-oops medicine.

...we do still need to cater for cpufreq and other struct deviceless
consumers.  If you can guarantee that no such consumers will ever exist
then great but we're not there yet.
