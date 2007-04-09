Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbXDIFfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbXDIFfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 01:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbXDIFfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 01:35:53 -0400
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:37261 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752945AbXDIFfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 01:35:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=34bHMKMjSg4ct5/l8uvZgyUaZ6rOjDgYNg+I/rl9fUPtA/2xkq3otF0sPI4aXp0BcThWoiLFKPnROfcgqQYeTpjsjceBsW3FkTzQ+VDh2bcBh4gq4YfVSUpejexNDaPSi7vN1yf7/hcCJinD2yf/2U0cCzpX5t/1ipD7y97di58=  ;
X-YMail-OSG: TJn1mEoVM1nJ3_wHUvdmdx.ao1uAu3TE31XKWdYYM26Ak56EuD_JTfjcdubHOLkDC6370eV4Pw--
Date: Sun, 08 Apr 2007 22:35:49 -0700
From: David Brownell <david-b@pacbell.net>
To: rui.zhang@intel.com, greg@kroah.com
Subject: Re: [patch 2.6.21-rc5-git] make /proc/acpi/wakeup more useful
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
       akpm@linux-foundation.org
References: <200704031741.42273.david-b@pacbell.net>
 <200704060843.30723.david-b@pacbell.net>
 <20070407050131.GB25511@kroah.com>
 <200704071308.07571.david-b@pacbell.net>
 <1176086185.2650.28.camel@localhost.localdomain>
In-Reply-To: <1176086185.2650.28.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070409053549.C7C64229527@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 2007-04-07 at 13:08 -0700, David Brownell wrote:
> > On Friday 06 April 2007 10:01 pm, Greg KH wrote:
> > 
> > > Are you _sure_ you have a 1-to-1 relationship here?  No multiple devices
> > > pointing to the same acpi node?  Or the other way around?  If so, you
> > > are going to have to change the name to be something more unique.
> > 
> > I've wondered that too.  The short answer:  APCI only supports 1-1
> > here.
>
> Right.
>
> >   It will emit warnings if it tries to bind more than one ACPI
> > device to a given "real" device ... but errors the other way are
> > silently ignored.
>
> My understanding is different.
> First, one "real" device can only have one device.archdata.acpi_handle,
> which means it can only be bound to one ACPI device.
> Second, AE_ALREADY_EXISTS will be returned when ACPI tries to bind more
> than one "real" devices to the same ACPI device.

Exactly.  The "first" case emits a warning, the "second" case doesn't;
no matter what it is (though I only saw ALREADY_EXISTS).


When I added a warning to that case:

> > By adding a warning over this create-links patch, I found that the
> > system in the $SUBJECT patch (and likely every ACPI system) has
> > two different nodes that correspond to one ACPI node:
> > 
> > 	/sys/devices/pci0000:00 ... pci root node
> > 	/sys/devices/pnp0/00:00 ... id PNP0a03
> > 	/sys/devices/acpi_system:00/device:00/PNP0A03:00 ... ditto
> > 
> > Arguably that's too many sysfs nodes for one device...

Presumably you've noticed this same thing (not necessarily pnp0/00:00)
on other systems ...


> > Plus, there's the issue of flakey ACPI tables; in the $SUBJECT patch
> > both MDM and AUD nodes exist in the ACPI namespace, but they could
> > only refer to one PCI device (with MDM as the wakeup source, not AUD
> > as listed in the table).  Or maybe that's another case where the ACPI
> > code isn't handling the tables as sensibly as it might...
>
> Could you attach this acpidump please? :)

Off-list; yes.

- Dave

