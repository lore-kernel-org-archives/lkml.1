Return-Path: <linux-kernel-owner+w=401wt.eu-S1764468AbZAOMkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764468AbZAOMkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbZAOMkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:40:11 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2759 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbZAOMkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:40:10 -0500
Date: Thu, 15 Jan 2009 12:40:07 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.29-rc] regulator: add get_status()
Message-ID: <20090115124007.GD2147@sirena.org.uk>
References: <200811091531.46003.david-b@pacbell.net> <200811161458.17212.david-b@pacbell.net> <20081117015127.GA10883@sirena.org.uk> <200901142303.17906.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901142303.17906.david-b@pacbell.net>
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

On Wed, Jan 14, 2009 at 11:03:17PM -0800, David Brownell wrote:

>  * Define a new regulator driver get_status() method, which is the
>    first method reporting regulator outputs instead of inputs.
>    It can report on/off and error status; or instead of simply
>    "on", report the actual operating mode.

> For the moment, this is a sysfs-only interface, not accessible to 
> regulator clients.  Such clients can use the current notification
> interfaces to detect errors, if the regulator reports them.

It's useful for bootstrapping purposes - the notifiers will only report
changes.  Not that this is something that should happen on a regular
basis so I'd be surprised if there were much demand.

> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but...

> +enum regulator_status {
> +	REGULATOR_STATUS_OFF,
> +	REGULATOR_STATUS_ON,
> +	REGULATOR_STATUS_ERROR,
> +	/* fast/normal/idle/standby are flavors of "on" */
> +	REGULATOR_STATUS_FAST,
> +	REGULATOR_STATUS_NORMAL,
> +	REGULATOR_STATUS_IDLE,
> +	REGULATOR_STATUS_STANDBY,
> +};
> +

> +	/* report regulator status ... most other accessors report
> +	 * control inputs, this reports results of combining inputs
> +	 * from Linux (and other sources) with the actual load.
> +	 */
> +	int (*get_status)(struct regulator_dev *);
> +

...this needs kerneldoc adding.
