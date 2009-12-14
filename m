Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbZLNKOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbZLNKOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 05:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbZLNKOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 05:14:14 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35484 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbZLNKON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 05:14:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=egLZSbOsjbXs6iX1CVdDdhcX61/Nr1vN8U7VYrNjFw2ugMbb9vgl+ZOKSEI77/vXSi
         fhlPl9844zFfUClxX0p24MLPTZMgnhC0haD4jpklSwwS7wx3PP2Ff52ARmj4z1JZZWu/
         lTYs032lKQ//pD5zADZGDeH6q+z3R7lFyQfeA=
Subject: Re: [PATCH 1/4] mfd: mc13783: Take care of semantic inversion
 between read and write value of two bits in POWER_MISCELLANEUS register.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20091213195606.GA14024@pengutronix.de>
References: <1260635829.2054.16.camel@climbing-alby>
	 <1260636523.2054.28.camel@climbing-alby>
	 <20091213195606.GA14024@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 11:14:07 +0100
Message-ID: <1260785647.2022.28.camel@climbing-alby>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe..

Il giorno dom, 13/12/2009 alle 20.56 +0100, Uwe Kleine-König ha scritto:
> On Sat, Dec 12, 2009 at 05:48:43PM +0100, Alberto Panizzo wrote:
> > MC13783_REGCTRL_PWGTnSPIEN controls the states of the corresponding
> > PWGTn_DRV output.
> > Reading 1 on the corresponding bit mean that the output is enabled
> > Writing 1 on the corresponding bit disable that output!
> > 
> > So, if not asked directly to modify those bits, write the inverted
> > value.
> Hmm, I'm not sure this completely right.  The Spec has:
> 
>         Bit PWGTxSPIEN | Pin PWGTxEN | PWGTxDRV |  Read Back
>           0 = default  |             |          | PWGTxSPIEN
>         ---------------+-------------+----------+------------
>               1        |      x      |   Low    |     0
>               0        |      0      |   High   |     1
>               0        |      1      |   Low    |     0
> 
> So it looks a bit harder than just inverting the read bit.
> 
> Best regards
> Uwe
> 

Yes, it is a bit harder, and because we don't have the complete 
information (we cannot check via software the state of Pin PWGTxEN)
the problem have no complete solution: if the read back value is 0 what I
choose is to assign to the software the master part.

We have to decide what to do, the other option is to write always 0 
(that's what the freescale code do) to let the hardware control itself.
This one for my board work as well, but it is the same, it is not a
complete solution.

Maybe we can trace via software the state of those two bits, starting
from an initial value, 0? (maybe the bootloader wrote 1 on those..)

Alberto.


