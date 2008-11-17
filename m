Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896AbYKQPQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbYKQPQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYKQPQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:16:46 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1029 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbYKQPQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:16:46 -0500
Date: Mon, 17 Nov 2008 15:16:39 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.28-rc5] regulator: enable/disable refcounting
Message-ID: <20081117151636.GG1559@sirena.org.uk>
References: <200811161144.46582.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811161144.46582.david-b@pacbell.net>
X-Cookie: I'm into SOFTWARE!
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 11:44:46AM -0800, David Brownell wrote:

> +	mutex_lock(&rdev->mutex);
> +	if (regulator->enabled == 1) {
> +		ret = _regulator_disable(rdev);
> +		if (ret == 0)
> +			regulator->uA_load = 0;

Why clear the load here?  I'd expect to be able to enable and disable
the regulator while preserving the configuration.
