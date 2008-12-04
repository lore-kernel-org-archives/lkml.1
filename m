Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbYLDLMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbYLDLMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 06:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbYLDLMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 06:12:21 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3696 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbYLDLMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 06:12:16 -0500
Date: Thu, 4 Dec 2008 11:12:12 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>,
       davej@redhat.com
Subject: Re: [patch 2.6.28-rc7] regulator: catch some registration errors
Message-ID: <20081204111206.GA8019@sirena.org.uk>
References: <200812011335.43551.david-b@pacbell.net> <20081201225312.GA6699@sirena.org.uk> <200812012150.36342.david-b@pacbell.net> <1228340921.6529.80.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228340921.6529.80.camel@vega.slimlogic.co.uk>
X-Cookie: NOBODY EXPECTS THE SPANISH INQUISITION!
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 09:48:41PM +0000, Liam Girdwood wrote:

> I wonder if there is another way to approach this as I do agree that
> passing NULL is probably not the best solution. Alternatives like
> embedding struct device with the CPUfreq core or adding a regulator_get
> API call for CPUfreq drivers all involve some work. Fwiw, I'd be happy
> enough with the latter option.

We could also accept the NULL but warn when doing so, perhaps also
adding a dummy device from the regulator core for the logging.  That'd
provide some pushback on cpufreq to move to the device model if nobody
is able to convert it right now.

On the bright side, looking at the situation with the clock API there
don't seem to be any other substantial offenders here.  Most of the
other users are part of the platform code and get to peer inside the
clocking structure, so if cpufreq were fixed there shouldn't be much
problem here.
