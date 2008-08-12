Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbYHLOb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbYHLOb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYHLObQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:31:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33028 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbYHLObP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:31:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.27-rc1: critical thermal shutdown on thinkpad x60
Date: Tue, 12 Aug 2008 16:34:33 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Milan Broz <mbroz@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <20080806090246.GA1572@elf.ucw.cz> <48A1779B.5020303@redhat.com> <20080812115530.GB8806@elf.ucw.cz>
In-Reply-To: <20080812115530.GB8806@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808121634.34634.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 12 of August 2008, Pavel Machek wrote:
> On Tue 2008-08-12 13:44:27, Milan Broz wrote:
> > Pavel Machek wrote:
> > > Hi!
> > >>> On Tue, Aug 12, 2008 at 11:41:35AM +0200, Pavel Machek wrote:
> > >>>>>> Aug  6 11:00:10 amd kernel: ACPI: Critical trip point
> > >>>>>> Aug  6 11:00:10 amd kernel: Critical temperature reached (128 C),
> > >>>>>> shutting down.
> > >>>>>> Aug  6 11:00:10 amd shutdown[24414]: shutting down for system halt
> > >>>>>>
> > >>>>>> ...and machine went down at that point :-(.
> > >>>>> I hope you can easily reproduce it?
> > >>>>>
> > >>>>> So it's new in 2.6.27rc1 and wasn't in 2.6.26? Can you please
> > >>>> Yes, I'm very sure. It makes machine basically unusable.
> > >>> Does this mean you can easily reproduce it?  
> > >>> Please do a bisect then. 
> > >>>
> > >>>> Not that one :-(. Thinkpad does not even have fan device: it is
> > >>>> controlled by hardware.
> > >> Hi,
> > >> I see exactly the same on my x60s, but during upgrade to 2.6.26.2.
> > > 
> > > Are you sure?
> > 
> > yes. maybe some userspace tool controlling frequency is involved, no idea yet.
> > But it is 2.6.26 tree for sure.
> 
> So it definitely is in 2.6.26.2, and it definitely is in 2.6.26?
> 
> ...because I'm using 2.6.26, and see nothing..
> 
> > >> Now, the CPU cores remains on 1.67GHz and fan is unable to cool them properly
> > >> under heavy load (even if I set "level disengaged" through thinkpad fan control,
> > >> temperature sensor shows after a while 128 C (probably not real temp,
> > >> I expect some critical flag => and it properly switch off the
> > >> system...)
> > > 
> > > How do you control fans? I could not get anything but -EINVAL from IBM
> > > ACPI driver :-(.
> > 
> > you need add fan_control=1 to thinkpad_acpi module
> > 
> > http://www.thinkwiki.org/wiki/How_to_control_fan_speed
> > http://www.thinkwiki.org/wiki/ACPI_fan_control_script
> 
> Thanks for pointers!

Pavel, can you check if the state of the fan(s) change while the thermal trip
points are being passed?

As I said in http://bugzilla.kernel.org/show_bug.cgi?id=11281, I suspect that
this mechanism may be broken.

Thanks,
Rafael
