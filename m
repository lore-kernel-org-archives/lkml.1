Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbZCOAiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbZCOAiH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 20:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZCOAhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 20:37:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2850 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbZCOAhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 20:37:53 -0400
Date: Sun, 15 Mar 2009 00:37:44 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Message-ID: <20090315003743.GB11052@sirena.org.uk>
References: <200903111743.34708.david-b@pacbell.net> <200903111932.16317.david-b@pacbell.net> <20090312120119.GB24376@sirena.org.uk> <200903141725.35541.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903141725.35541.david-b@pacbell.net>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [patch 2.6.29-rc8 regulator-next] regulator: init fixes (v4)
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 05:25:35PM -0700, David Brownell wrote:

> +	} else if (ops->is_enabled) {
> +		/* ... if the bootloader left it on, drivers need a
> +		 * nonzero enable count else it can't be disabled.
> +		 */
> +		ret = ops->is_enabled(rdev);
> +		if (ret > 0)
> +			rdev->use_count = 1;
> +		ret = 0;

This means that drivers that do balanced enables and disables will never
be able to cause the regulator to actually be disabled since there will
always be this extra reference count there.  Without this patch what'll
happen with those drivers is that they'll do an enable then later on
when the last one disables its supply the reference count will fall to
zero and the regulator will be disabled.
