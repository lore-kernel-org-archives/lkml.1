Return-Path: <linux-kernel-owner+w=401wt.eu-S1757670AbYGILL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670AbYGILL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbYGILLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:11:09 -0400
Received: from web32604.mail.mud.yahoo.com ([68.142.207.231]:41067 "HELO
	web32604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754278AbYGILLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:11:08 -0400
X-Mailer: YahooMailRC/1042.33 YahooMailWebService/0.7.199
Date: Wed, 9 Jul 2008 04:11:04 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Reply-To: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: [PATCH][resubmit] HP iLO driver
To: Pavel Machek <pavel@suse.cz>, "Altobelli, David" <david.altobelli@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <200921.6263.qm@web32604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Pavel Machek <pavel@suse.cz>
> To: "Altobelli, David" <david.altobelli@hp.com>
> Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; "greg@kroah.com" <greg@kroah.com>
> Sent: Wednesday, July 9, 2008 1:08:50 AM
> Subject: Re: [PATCH][resubmit] HP iLO driver
> 
> On Tue 2008-07-08 22:19:18, Altobelli, David wrote:
> > Pavel Machek wrote:
> > > Could you provide the list of commands (at least) so we can be more
> > > concrete?
> > 
> > Unfortunately, I don't believe that I can.  We reviewed this internally,
> > and the question of documentation was raised.  The hardware teams
> 
> You could at least provide list of high-level functionality.
> 
> > > (I assume management processors have pretty similar functionality
> > > accross vendors, right?)
> > 
> > I can't speak for other vendors.
> 
> And neither can they speak, because you did not tell us what the iLO
> does.
> 
> > >> It seems much cleaner to keep the kernel interface simple and opaque
> > >> (ie read/write), and handle the details of the commands in user
> > >> space. From my limited understanding, I thought that was a common
> > >> goal here: move what you can to userspace.
> > >
> > > We are not _that_ extreme. Yes, keep stuff in userspace is important,
> > > but "hide hardware differences" is more important goal.
> > 
> > That seems like a larger question/goal.  Giving users some consistent
> > interfaces to do stuff would be nice, but I'd really like to handle this
> > driver on its own.
> 
> This driver can't be handled on its own, that would lead to a mess in
> future. Sorry. We need more info here.

Somehow I feel the need to step in, as I believe that this thread is really going in the wrong direction.

It is true that David (or HP) definitely could have done a better job in describing why this driver is needed and what HP-Utilities are depending on it. This might have lead some people to misinterpret what ILO is about.

ILO (Q: does HP still sell RILOE boards and are they supporten by the driver?) is a command processor that allows *external* administration (Power control, Rebooting, Remote Console, ..) of certain HP (and HP only) products. For this it provides a separate NIC and a separate serial connector. Access is completely independant of an OS running on the server. This HP-ILO has nothing to do with that functionality.

ILO can be configured either offline (server OS shut down), or via the external interfaces, or from a running OS via some HP provided utilities. For this a driver is needed, and that is what we are talking about. From my experience as an administrator of HP Proliant systems the only local uses for the *internal* ILO interface is to set-up the thing, and to do firmware upgrades.

To obtain sensor data locally there are other ways, which do not need the ILO kernel driver (hplog together with hpasmd, which unfortunately are closed source). So , unless the HP-ILO driver is just a replacement of the old "cpqci" driver, there is no need to pester David on functionality. If, of course the HP-ILO driver is needed to get to the hpasm/hplog functionality (no driver was needed so far) the story might be different. But then HP should provide the specs for the Proliant sensor interface anyway and work together with the lm_sensors project. But that is a different story.

Cheers
Martin
