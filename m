Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036Ab0AHKxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab0AHKxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 05:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435Ab0AHKxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 05:53:38 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53357 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab0AHKxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 05:53:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=h52VlQDLK0uWwFD3N2rwTfR7G3QuDLQaU736NNLgXcQ7yTe3ZU30oFBXc/PDToFeMW
         +ee6ytlGuJRua8ZuegW6YxOkA2Ju5tubn9iNS10elwwTc82wEV6+LusQN+14YWavPxqA
         d+AYZ2/JE0OWUChzHJ1kYBxqK6zY4cRBBHMrA=
Subject: Re: [PATCH 1/4] mfd: mc13783: Take care of semantic inversion
 between read and write value of two bits in POWER_MISCELLANEUS register.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
In-Reply-To: <20100105195520.GA8555@pengutronix.de>
References: <1260808880.2022.98.camel@climbing-alby>
	 <1260810776.2022.130.camel@climbing-alby> <4B26799F.1020507@ru.mvista.com>
	 <1260813540.2022.174.camel@climbing-alby>
	 <20100105181541.GE4274@sortiz.org>  <20100105195520.GA8555@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 11:53:31 +0100
Message-ID: <1262948011.2050.3.camel@climbing-alby>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for late response.. as Uwe said, we have discuss about this 
and I will prepare another patch that involve the regulator driver.

Alberto!

Il giorno mar, 05/01/2010 alle 20.55 +0100, Uwe Kleine-König ha scritto:
> On Tue, Jan 05, 2010 at 07:15:42PM +0100, Samuel Ortiz wrote:
> > > @@ -187,6 +190,13 @@ int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val)
> > >  
> > >         buf = 1 << 31 | offset << MC13783_REGOFFSET_SHIFT | val;
> > >  
> > > +       /* Take care of table 4-24 in Freescale MC13783IGPLDRM.pdf making
> > > +        * the assumption that PWGTnDRV signals controls core power supplies
> > > +        * that software must not disable. */
> > > +       if (offset == MC13783_REG_POWER_MISCELLANEOUS)
> > > +               buf &= ~(MC13783_REGCTRL_PWGT1SPIEN |
> > > +                        MC13783_REGCTRL_PWGT2SPIEN);
> > > +
> > Although I see where you want to go, I dont really enjoy that solution.
> > I would prefere to have specific register write/rmw routines for
> > MC13783_REG_POWER_MISCELLANEOUS, and at the same time forbid to access the
> > latter from the current mc13783_reg_* API.
> Ack.  This is what I already suggested in
> 
> 	http://thread.gmane.org/gmane.linux.kernel/927112/focus=930317
> 
> (This happend to be a reply to patch 2/4 as I replied to Alberto's ping
> for patches 1 and 2.)
> 
> Best regards
> Uwe
> 


