Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbYGIOs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbYGIOs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 10:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbYGIOsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 10:48:18 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:15368 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbYGIOsR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 10:48:17 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: Martin Knoblauch <knobi@knobisoft.de>, Pavel Machek <pavel@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Date: Wed, 9 Jul 2008 14:47:14 +0000
Subject: RE: [PATCH][resubmit] HP iLO driver
Thread-Topic: [PATCH][resubmit] HP iLO driver
Thread-Index: AcjhtH6sybTbSCv3RCeSFUVc1i0SlwAGt84g
Message-ID: <CF70AA892F109448AEA269483B3A983903BBB04751@G1W1215.americas.hpqcorp.net>
References: <200921.6263.qm@web32604.mail.mud.yahoo.com>
In-Reply-To: <200921.6263.qm@web32604.mail.mud.yahoo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Knoblauch wrote:
> Somehow I feel the need to step in, as I believe that this
> thread is really going in the wrong direction.
>
> It is true that David (or HP) definitely could have done a
> better job in describing why this driver is needed and what
> HP-Utilities are depending on it. This might have lead some
> people to misinterpret what ILO is about.

I'm sorry about that.  This driver is needed for tools like:
hponcfg, hpdiags, hp-snmp-agents, and iLO flash utilities.

> ILO (Q: does HP still sell RILOE boards and are they
> supporten by the driver?) is a command processor that allows

RILOE cards are not sold any more, and are not supported by this driver.

>
> ILO can be configured either offline (server OS shut down),
> or via the external interfaces, or from a running OS via some
> HP provided utilities. For this a driver is needed, and that
> is what we are talking about. From my experience as an
> administrator of HP Proliant systems the only local uses for
> the *internal* ILO interface is to set-up the thing, and to
> do firmware upgrades.

Yeah, those are most common.  This driver will also surface data
through HPSMH or HPSIM, if the proper packages are installed.

> To obtain sensor data locally there are other ways, which do
> not need the ILO kernel driver (hplog together with hpasmd,
> which unfortunately are closed source). So , unless the
> HP-ILO driver is just a replacement of the old "cpqci"
> driver, there is no need to pester David on functionality.
> If, of course the HP-ILO driver is needed to get to the
> hpasm/hplog functionality (no driver was needed so far) the
> story might be different. But then HP should provide the
> specs for the Proliant sensor interface anyway and work
> together with the lm_sensors project. But that is a different story.

This is a replacement for cpqci, which was released in the
"hprsm" package, and later replaced by the "hp-ilo" package.
The former package was not GPL, the latter is.
I rewrote the driver to make it (hopefully) more palatable,
in terms of both style and functionality.
