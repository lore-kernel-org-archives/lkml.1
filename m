Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbZBRVLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbZBRVLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbZBRVLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:11:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43963 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbZBRVLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:11:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: mgross@linux.intel.com
Subject: Re: [RFD] Automatic suspend
Date: Wed, 18 Feb 2009 22:11:07 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902160010.16955.rjw@sisk.pl> <20090218002704.GB25605@linux.intel.com>
In-Reply-To: <20090218002704.GB25605@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902182211.09788.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009, mark gross wrote:
> On Mon, Feb 16, 2009 at 12:10:15AM +0100, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > The recent descussion about the Android PM patches sent by Arve shows that
> > there is a need to introduce a mechanism allowing us to:
> > (1) automatically put the system as a whole into a sleep state (eg. suspend to
> >     RAM) when it is found to be "idle", where the meaning of "idle" has to be
> >     defined too,
> 
> Can a fast STR state be created for the generic kernel across
> architectures?  Something that can go into and out of SRT in < 20ms?

I don't think it's generally doable on PCs.

> (I picked 20ms as that gives 50Hz screen refresh) I guess the XO does
> something like this between keystrokes. 
> 
> Note: I don't know (but I should) if such a PM design popping into and
> out of STR at worst every 20ms is worth doing on IA but lets assume its
> not so bad for the sake of argument.
> 
> One could assume the system would be idle except for selects on HID
> events when operating in this mode.
> 
> > (2) put given subset of devices into low power states whenever they are not
> >     used, without putting the entire system into a sleep state.
> 
> This is a driver deal to drop the hardware they control into lower power
> states.  Give information for PM-QOS the drivers could do the right
> things here.  (or should be able too) 

That may also depend on the bus the driver is on (like PCI for one example).

> Also how do we attempt to coordinate this with an automatic STR state?

That's one thing to think about.  In principle we can avoid suspending
devices that already are in low power states before a system-wide transition
is started (caveat: wake-up devices on ACPI systems).
 
> How to coexist with user requested STR?
> 
> Do we need to more carefully define what STR really means?  (I'm
> thinking we do)

Well, yes and no.  In fact ACPI defines STR as one of the system sleep states
in which the CPU does not execute instructions, but the ACPI definition need
not be applicable to non-ACPI platforms.

> > To allow these two things to happen, the Andriod patches introduced the
> > wakelocks with the associated infrastructure and the "early suspend" mechanism.
> > However, quite a number of reviewers did not like these patches, for various
> > reasons, so they cannot be regarded as generally acceptable.  For this reason,
> > I think, we should discuss the problem in detail from the beginning and try to
> > find a solution that everyone interested will be comfortable with.
> > 
> > For this purpose, IMO, we should at least reach an agreement on what the
> > kernel's and the userland's roles in (1) and (2) are going to be.  There also
> > are quite a few questions that need to be answered.  For instance, what
> > conditions are going to be used to decide whether or not the system is idle
> > enough so that we can put it into a sleep state?  How are we going to check
> > these conditions?  What is going to happen if one (or more) of them changes
> > while a system-wide power transition (eg. suspend) is in progress?  Are we
> > going to allow the user space to take part in this and if so, to what extent?
> > What mechanisms are going be used to put devices into low power states at run
> > time (ie. before starting any system-wide power transition) and how are they
> > going to be related to the suspend-resume infrastructure used during
> > system-wide power transitions?  The answers to these (and other related)
> > questions will likely affect all of the future Linux PM developlent, so IMO
> > this is a very important matter.
> > 
> > Opinions and comments welcome.
> >
> 
> thank you for starting this FRD.

No big deal. :-)

Thanks,
Rafael
