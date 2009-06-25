Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbZFYXhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbZFYXhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 19:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZFYXha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 19:37:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34251 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbZFYXh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 19:37:29 -0400
Date: Fri, 26 Jun 2009 00:37:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Samuel Ortiz <sameo@linux.intel.com>
Message-ID: <20090625233723.GA13150@sirena.org.uk>
References: <1245961793.10360.26.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245961793.10360.26.camel@brutus>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] PCAP regulator driver (for 2.6.32).
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 05:29:53PM -0300, Daniel Ribeiro wrote:

> +	/*
> +	 * The regulator framework doesn't like regulators which default
> +	 * to ON at boot time, so we just disable it here (when it is safe).
> +	 */
> +	if (pdev->id == VAUX2 || pdev->id == VAUX3)
> +		pcap_regulator_disable(rdev);

No need to do this - the regulator framework is perfectly happy with
regulators that are enabled at boot time and turning regulators that are
actively being used off is likely to cause issues.  Regulator drivers
should just leave everything as they find it and leave it up to the core
and machine drivers to make any changes.

Other than that this looks good; I'm assuming the PCAP core has a
sensible way of getting the platform data to the devices.
