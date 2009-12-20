Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbZLTNsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbZLTNsr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 08:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbZLTNsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 08:48:46 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:43628 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZLTNsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 08:48:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=X0Yyk7cju5l766CtmEo9gkRI7bMNLoOuVf2LffKKGEI4PHT4CBahLtAMAAexdOsdAk
         imuUVLFrvKwlzpOJDRoG3jmKQlZpwp0KPs60sVSO5AALoATZd5y8ctNpHcvdxBxGc6+q
         G3SLdMM5kmilfYNgk4AeHtXcG77E8+6OZom7k=
Subject: Re: [PATCH 2/4] mfd: mc13783: When probing, unlock the mc13783
 before subsystems initialisation.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
In-Reply-To: <20091219201816.GA28742@pengutronix.de>
References: <1260808880.2022.98.camel@climbing-alby>
	 <1260810776.2022.130.camel@climbing-alby>
	 <1260811085.2022.135.camel@climbing-alby>
	 <1261152746.3356.72.camel@climbing-alby>
	 <20091219201816.GA28742@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Dec 2009 14:48:38 +0100
Message-ID: <1261316918.5224.15.camel@climbing-alby>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il giorno sab, 19/12/2009 alle 21.18 +0100, Uwe Kleine-König ha
scritto: 
> Hello,
> 
> On Fri, Dec 18, 2009 at 05:12:26PM +0100, Alberto Panizzo wrote:
> > Ping :)
> > 
> > PATCH 1 & 2 are fixes that can go to .33
> I don't like patch 1.  I'd prefer that drivers touching
> MC13783_REG_POWER_MISCELLANEOUS are aware of the bit in question and
> wouldn't rely on mc13783-core.
> 
> Best regards
> Uwe
> 

Yes, but MC13783_REG_POWER_MISCELLANEOUS contains bit that control
different aspect of mc13783 chip.
GPO are regulator related, but those two bits in question maybe 
apply to a power management driver, so this problem is a matter
of mc13783-core.

Another possible solution, is to trace the writings to those two bits
in mc13783_reg_rmw storing the value written an reproducing it in next
mc13783_reg_rmw calls.
But the problem for this is that we don't know if the bootloader 
had initialised those with another non default value.
Another problem is that if another driver make use of 
mc13783_reg_write for modifying those bits, the state stored will
be inconsistent.

And so? what kind of solution can you suggest?

I am working to support i.MX31 PDK board that make a strong use of mc13783
and GPO's controls important power supplies.

Alberto!



