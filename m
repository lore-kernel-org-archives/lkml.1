Return-Path: <linux-kernel-owner+w=401wt.eu-S932067AbZLNK7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbZLNK7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 05:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbZLNK7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 05:59:38 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:36403 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714AbZLNK7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 05:59:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KRqTZIQy3bmp0SFyMVFpbKS4nF+Kbuv1nLs//0Eje/h/RGXdYppA9jnvMkt23V1FrH
         kdAQg9VfHx0Bgoz+xyZYfUeY5qqKW1NupfDyd38axf18WHDM84nbp9IYFZdm9wJW1Yg4
         DlSPy4uHgIwf4uDIBvR9TEZuREF7z9yFiOqPE=
Subject: Re: [PATCH 4/4] regulator: mc13783 change to
 platform_driver_register.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20091213200509.GD14024@pengutronix.de>
References: <1260635829.2054.16.camel@climbing-alby>
	 <1260636523.2054.28.camel@climbing-alby>
	 <1260636819.2054.33.camel@climbing-alby>
	 <1260636976.2054.36.camel@climbing-alby>
	 <1260637577.2054.43.camel@climbing-alby>
	 <20091213200509.GD14024@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 11:59:32 +0100
Message-ID: <1260788372.2022.73.camel@climbing-alby>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il giorno dom, 13/12/2009 alle 21.05 +0100, Uwe Kleine-König ha scritto:
> Hello,
> 
> On Sat, Dec 12, 2009 at 06:06:17PM +0100, Alberto Panizzo wrote:
> > Change the instant when regulator driver is probed. 
> > To have a correct regulators initialisation (enable, disable and voltages 
> > selection), the driver must have access to mc13783 registers and so 
> > mc13783-core must be loaded before this.
> > 
> > With this patch mc13783_regulator_probe is called when mc13783-core
> > register the regulator subsystem.
> > 
> > Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
> I think the change is OK, the commit log isn't optimal though.
> 
> You might want to point out that the problem only occurs if the driver
> is built-in and that mc13783_regulator_probe doesn't need to be changed
> as it already lives in .devinit.text
> 

My problem is a not great knowledge of different types of initcall, I 
have to improve myself in this! 

> As if mc13783-regulator is built-in mc13783-core is built-in, too, the
> wording isn't good.  The problem is (I suppose) that regulators are
> linked first and so mc13783-core isn't *probed* early enough and so the
> mc13783-regulator device isn't available at mc13783-regulator probing
> time.

This is the problem. As I understand subsystem_initcall it is the function
called by the system when that subsystem is initialised.
Because of mc13783-regulator is in the regulator subsystem it is called very 
early in the boot process (regulators are meant to be initialised in a very
early phase).

The way that mc13783-regulator's subsystem_initcall call mc13783_regulator_probe
is correct, is only if mc13783-regulator is a subsystem of mc13783-core (mfd?).


Thanks all for reviewing!

Best regards.
Alberto!




