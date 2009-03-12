Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbZCLKvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbZCLKvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbZCLKv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:51:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1271 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbZCLKv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:51:26 -0400
Date: Thu, 12 Mar 2009 10:37:48 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Subject: Re: [patch 2.6.29-rc7 regulator-next] regulator: refcount fixes
Message-ID: <20090312103744.GA24376@sirena.org.uk>
References: <200903111743.34708.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903111743.34708.david-b@pacbell.net>
X-Cookie: War is an equal opportunity destroyer.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 04:43:34PM -0800, David Brownell wrote:

> Buggy consumers could notice different bug symptoms.  The main
> example would be refcounting bugs; also, any (out-of-tree) users
> of the experimental regulator_set_optimum_mode() stuff which
> don't call it when they're done using a regulator.

I'm OK with this from a code point of view so

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

However any consumers that take advantage of this won't be able to
safely share a regulator without extra work since they have no way of
telling why a regulator is in the state that it's in without extra
stuff.  We should probably have something along the lines of a
regulator_get_exclusive() for them.  Previously the consumer counting
would have stopped them interfering with enables done by other
consumers.

There will be other consumers that can't safely share a regulator anyway
(eg, requiring additional code to notice and handle voltage changes) so
it'd be a good thing to have.
