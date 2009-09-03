Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbZICVMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbZICVMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 17:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932301AbZICVMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 17:12:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39117 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932333AbZICVMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 17:12:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH V6 1/2] introduce ALS sysfs class
Date: Thu, 3 Sep 2009 23:13:19 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-rjw; KDE/4.3.0; x86_64; ; )
Cc: Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <1251789947.3483.215.camel@rzhang-dt> <1251945339.3483.260.camel@rzhang-dt> <20090903084543.GC3793@elf.ucw.cz>
In-Reply-To: <20090903084543.GC3793@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909032313.19893.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 September 2009, Pavel Machek wrote:
> On Thu 2009-09-03 10:35:39, Zhang Rui wrote:
> > On Thu, 2009-09-03 at 08:16 +0800, Rafael J. Wysocki wrote:
> > > On Wednesday 02 September 2009, Pavel Machek wrote:
> > > > On Wed 2009-09-02 23:46:11, Rafael J. Wysocki wrote:
> > > > > On Wednesday 02 September 2009, Pavel Machek wrote:
> > > > > > On Wed 2009-09-02 23:12:58, Rafael J. Wysocki wrote:
> > > > > > > On Tuesday 01 September 2009, Pavel Machek wrote:
> > > > > > > > 
> > > > > > > > > > > IMO, 0 and -1 are not errors. they just suggest that the Ambient Light
> > > > > > > > > > > illuminance is beyond the device support range, while the device is
> > > > > > > > > > > still working normally.
> > > > > > > > > > > what about exporting these values (0 and -1) to user space directly?
> > > > > > > > > > 
> > > > > > > > > > Returning 0 for "below" range and 99999999 for "above" range would be
> > > > > > > > > > nice, yes. 
> > > > > > > > > 
> > > > > > > > > Why not 0 and "all ones" or 0 and -1.
> > > > > > > > > 
> > > > > > > > > Is there anything wrong with -1 in particular?
> > > > > > > > 
> > > > > > > > Normal people expect -1 to be less than 123, and output is in ascii. If
> > > > > > > > you make it ((unsigned) ~0) I guess that becomes acceptable.
> > > > > > > 
> > > > > > > Well, "-1" is a perfectly valid alphanumerical representation of an int.
> > > > > > > I don't really see the problem with the "-", unless we're talking about some
> > > > > > > broken user space, that is.
> > > > > > 
> > > > > > No. But if you see illumination value of -1 lumen, do you really
> > > > > > expect a *lot* of light?
> > > > > 
> > > > > Not really.  I'd rather intrepret it as "the number is not to be trusted",
> > > > > which is what it means.
> > > > > 
> > > > > The problem with "all ones" is that it depends on the size of the underlying
> > > > > data type, which is not nice.  Also, if you want that to be a "big number",
> > > > > there's no clear rule to tell what the number should actually be.
> > > > > 
> > > > > Anyway, this really is a matter of definition.  If we document the attribute
> > > > > to read as "-1" in specific circumstances, the user space will have to take
> > > > > that into account.
> > > > 
> > > > Well, I'd prefer to specify -1 as "underflow" and 1000000000 as
> > > > "overflow". Any numbers should work, but ... lets make the interface
> > > > logical if we can.
> > > 
> > > The interface is already defined, isn't it?  And we're now considering whether
> > > or not to pass the values defined by the interface directly to the user space,
> > > which I think is the right thing to do, because we have no reason _whatsoever_
> > > to change them to anything else.
> > > 
> > I agree.
> > For environment illuminance, "-1" is surely an invalid value.
> > IMO, users would rather look for what it actually means than interpret
> > it to a value lower than 0.
> 
> Yes, you'd have to look that up. With 1000000000 for overflow, you
> would not have to do any lookups...
> 
> (Plus, if you use -1 for overflow... you need 0 for underflow, but 0
> lumen is pretty valid value. Actually I'm thinking if this should
> maybe not on the log scale or something).

Let's make the "-1 corresponds to all ones" rule and stop losing time for
discussing that any more.  I don't think it's worth it. :-)

Thanks,
Rafael
