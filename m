Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435Ab0AETzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab0AETzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346Ab0AETza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:55:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48844 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab0AETz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:55:26 -0500
Date: Tue, 5 Jan 2010 20:55:20 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Alberto Panizzo <maramaopercheseimorto@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 1/4] mfd: mc13783: Take care of semantic inversion
	between read and write value of two bits in POWER_MISCELLANEUS
	register.
Message-ID: <20100105195520.GA8555@pengutronix.de>
References: <1260808880.2022.98.camel@climbing-alby> <1260810776.2022.130.camel@climbing-alby> <4B26799F.1020507@ru.mvista.com> <1260813540.2022.174.camel@climbing-alby> <20100105181541.GE4274@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100105181541.GE4274@sortiz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 07:15:42PM +0100, Samuel Ortiz wrote:
> > @@ -187,6 +190,13 @@ int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val)
> >  
> >         buf = 1 << 31 | offset << MC13783_REGOFFSET_SHIFT | val;
> >  
> > +       /* Take care of table 4-24 in Freescale MC13783IGPLDRM.pdf making
> > +        * the assumption that PWGTnDRV signals controls core power supplies
> > +        * that software must not disable. */
> > +       if (offset == MC13783_REG_POWER_MISCELLANEOUS)
> > +               buf &= ~(MC13783_REGCTRL_PWGT1SPIEN |
> > +                        MC13783_REGCTRL_PWGT2SPIEN);
> > +
> Although I see where you want to go, I dont really enjoy that solution.
> I would prefere to have specific register write/rmw routines for
> MC13783_REG_POWER_MISCELLANEOUS, and at the same time forbid to access the
> latter from the current mc13783_reg_* API.
Ack.  This is what I already suggested in

	http://thread.gmane.org/gmane.linux.kernel/927112/focus=930317

(This happend to be a reply to patch 2/4 as I replied to Alberto's ping
for patches 1 and 2.)

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
