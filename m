Return-Path: <linux-kernel-owner+w=401wt.eu-S1760320AbYHVMne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760320AbYHVMne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 08:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbYHVMnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 08:43:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62140 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759039AbYHVMnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 08:43:12 -0400
Subject: Re: char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
From: Kay Sievers <kay.sievers@vrfy.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: ambx1@neo.rr.com, elendil@planet.nl, trenn@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tpm@selhorst.net, rjw@sisk.pl, greg@kroah.com
In-Reply-To: <200808220606.39722.bjorn.helgaas@hp.com>
References: <24565067.73831219353513508.JavaMail.servlet@kundenserver>
	 <200808211558.23725.bjorn.helgaas@hp.com>
	 <1219394447.20723.51.camel@lgn.site>
	 <200808220606.39722.bjorn.helgaas@hp.com>
Content-Type: text/plain
Date: Fri, 22 Aug 2008 14:43:05 +0200
Message-Id: <1219408985.20723.66.camel@lgn.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+tdnrR0TsQoWVYLux9dTvj+Gb88wApidwThhy
 5kDiBaXFleFDbMbjm5B5o1EKq4NtfjUw73I7ws8FlyZytlyTJv
 yQQ31BOZJ1WM4laO+X/XUOV/7zJam1O
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-22 at 06:06 -0600, Bjorn Helgaas wrote:
> On Friday 22 August 2008 2:40:46 am Kay Sievers wrote:
> > On Thu, 2008-08-21 at 15:58 -0600, Bjorn Helgaas wrote:
> > > On Thursday 21 August 2008 03:18:33 pm Kay Sievers wrote:
> > > > Bjorn Helgaas wrote:
> > > > >Is there a "complete idiot's guide to modules
> > > > >and udev"?  There's precious little in Documentation/ other than a
> > > > > bunch of sample rules for various subsystems.
> > > >
> > > > I don't know of any specific documentation, but it's pretty easy:
> > > > ...
> > >
> > > Thanks for the tutorial.
> > >
> > > > >Could I fix this by implementing pnp_device_uevent()?
> > > >
> > > > Only if we change the format of the current pnp device aliases
> > > > to something like:
> > > >   pnp*:XYZ2324:*
> > > >   pnp*:ABC1234:*
> > > >
> > > > and create a "modalias" file at every pnp device, and add MODALIAS to
> > > > the uevent. The modalias must contains all ID's which belong to that
> > > > device in one single string, separated and terminated by a special
> > > > character, something like:
> > > >   pnp:ABC1234:XYZ2324:RST3445:
> > >
> > > This all sounds like good stuff that I'd like PNP to have.  Is there
> > > any reason I shouldn't implement pnp_device_uevent()?  Any backwards-
> > > compatibility issues?
> >
> > Yeah, people probably use the current aliases in modprobe.conf files,
> > I'm not sure, if we can change them.
> >
> > > I think that sounds like a better solution than doing this PNP ID
> > > mangling.
> >
> > Sure, that will go with the acpi aliases + acpi modalias, or if you
> > change pnp to have proper pnp aliases + pnp modalias, then with them,
> > yes.
> 
> Since PNP currently doesn't generate any uevents or modalias files,
> I expect that a non-ACPI system will be unable to autoload modules
> for ISAPNP or PNPBIOS devices.  Right?

They do create events, but without modalias. The shell script hack,
which udev runs, will make the event behave like it contained one.

Kay

