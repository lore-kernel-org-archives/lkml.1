Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbZLMUFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbZLMUFR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 15:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbZLMUFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 15:05:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43343 "HELO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754065AbZLMUFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 15:05:13 -0500
Date: Sun, 13 Dec 2009 21:05:09 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] regulator: mc13783 change to
	platform_driver_register.
Message-ID: <20091213200509.GD14024@pengutronix.de>
References: <1260635829.2054.16.camel@climbing-alby> <1260636523.2054.28.camel@climbing-alby> <1260636819.2054.33.camel@climbing-alby> <1260636976.2054.36.camel@climbing-alby> <1260637577.2054.43.camel@climbing-alby>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1260637577.2054.43.camel@climbing-alby>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Dec 12, 2009 at 06:06:17PM +0100, Alberto Panizzo wrote:
> Change the instant when regulator driver is probed. 
> To have a correct regulators initialisation (enable, disable and voltages 
> selection), the driver must have access to mc13783 registers and so 
> mc13783-core must be loaded before this.
> 
> With this patch mc13783_regulator_probe is called when mc13783-core
> register the regulator subsystem.
> 
> Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
I think the change is OK, the commit log isn't optimal though.

You might want to point out that the problem only occurs if the driver
is built-in and that mc13783_regulator_probe doesn't need to be changed
as it already lives in .devinit.text

As if mc13783-regulator is built-in mc13783-core is built-in, too, the
wording isn't good.  The problem is (I suppose) that regulators are
linked first and so mc13783-core isn't *probed* early enough and so the
mc13783-regulator device isn't available at mc13783-regulator probing
time.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
