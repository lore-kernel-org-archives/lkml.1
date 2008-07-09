Return-Path: <linux-kernel-owner+w=401wt.eu-S1758512AbYGIPPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512AbYGIPPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbYGIPPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:15:12 -0400
Received: from web32604.mail.mud.yahoo.com ([68.142.207.231]:48489 "HELO
	web32604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753492AbYGIPPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:15:11 -0400
X-Mailer: YahooMailRC/1042.33 YahooMailWebService/0.7.199
Date: Wed, 9 Jul 2008 08:15:09 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: [PATCH][resubmit] HP iLO driver
To: "Altobelli, David" <david.altobelli@hp.com>, Pavel Machek <pavel@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19533.95591.qm@web32604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: "Altobelli, David" <david.altobelli@hp.com>
> To: Martin Knoblauch <knobi@knobisoft.de>; Pavel Machek <pavel@suse.cz>
> Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; "greg@kroah.com" <greg@kroah.com>
> Sent: Wednesday, July 9, 2008 4:47:14 PM
> Subject: RE: [PATCH][resubmit] HP iLO driver
> 
> Martin Knoblauch wrote:
> > Somehow I feel the need to step in, as I believe that this
> > thread is really going in the wrong direction.
> >
> > It is true that David (or HP) definitely could have done a
> > better job in describing why this driver is needed and what
> > HP-Utilities are depending on it. This might have lead some
> > people to misinterpret what ILO is about.
> 
> I'm sorry about that.  This driver is needed for tools like:
> hponcfg, hpdiags, hp-snmp-agents, and iLO flash utilities.
> 

 hponcfg - configuration
 hpdiags - ???
 hp-snmp-agents - ??? Do they provide sensor information?
 iLO Flash - Firmware upgrade
 
> > ILO (Q: does HP still sell RILOE boards and are they
> > supporten by the driver?) is a command processor that allows
> 
> RILOE cards are not sold any more, and are not supported by this driver.
> 

 OK, so this is really Proliant and likely Blades only? No chance that this will show up elsewhere?

> >
> > ILO can be configured either offline (server OS shut down),
> > or via the external interfaces, or from a running OS via some
> > HP provided utilities. For this a driver is needed, and that
> > is what we are talking about. From my experience as an
> > administrator of HP Proliant systems the only local uses for
> > the *internal* ILO interface is to set-up the thing, and to
> > do firmware upgrades.
> 
> Yeah, those are most common.  This driver will also surface data
> through HPSMH or HPSIM, if the proper packages are installed.
> 

 Hmm. I am a bit out of touch. What are they doing?

> > To obtain sensor data locally there are other ways, which do
> > not need the ILO kernel driver (hplog together with hpasmd,
> > which unfortunately are closed source). So , unless the
> > HP-ILO driver is just a replacement of the old "cpqci"
> > driver, there is no need to pester David on functionality.
> > If, of course the HP-ILO driver is needed to get to the
> > hpasm/hplog functionality (no driver was needed so far) the
> > story might be different. But then HP should provide the
> > specs for the Proliant sensor interface anyway and work
> > together with the lm_sensors project. But that is a different story.
> 
> This is a replacement for cpqci, which was released in the
> "hprsm" package, and later replaced by the "hp-ilo" package.
> The former package was not GPL, the latter is.
> I rewrote the driver to make it (hopefully) more palatable,
> in terms of both style and functionality.

 I really believe that if the HP-ILO driver is only needed for configuration and FW upgrades, it is OK in the current state. I do not think that anybody really wants to write another hponcfg or iLO-flash.

 But if it is also needed to obtain sensor information, your colleagues should really think about supporting the lm_sensors framework.

Cheers
Martin

