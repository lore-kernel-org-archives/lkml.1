Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbZDWUCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbZDWUCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 16:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbZDWUCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 16:02:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44117 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbZDWUCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 16:02:41 -0400
Date: Thu, 23 Apr 2009 21:02:33 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org, philipp.zabel@gmail.com
Message-ID: <20090423200232.GD6642@sirena.org.uk>
References: <1240510243-28969-1-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240510243-28969-1-git-send-email-robert.jarzmik@free.fr>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] Maxim 1586 regulator driver
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 08:10:43PM +0200, Robert Jarzmik wrote:

> +/*
> + * max1586.c  --  Voltage and current regulation for the Maxim 1586
> + *
> + * Copyright (C) 2008 Robert Jarzmik

You're living in the past here!

> +/*
> + * V6 voltage
> + * On I2C bus, sending a "x" byte to the max1586 means :
> + *   set V6 to either 0V, 1.8V, 2.5V, 3V depending on (x & 0x3)
> + * As regulator framework doesn't accept voltages to be 0V, we use 1uV.
> + */

Having seen the regulation constraints you're using on your board I'm
thinking even more that it'd be better to implement enable and disable
operations for the driver.  On the other hand, the driver is useful now
and my other comments are all very much nitpicks so from my point of
view:

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> +	dev_dbg(&client->dev, "changing voltage v6 to %dmv\n",
> +		max1586_v6_calc_voltage(selector) / 1000);

mv should be mV.
