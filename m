Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbZIBVpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbZIBVpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 17:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZIBVpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 17:45:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35144 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971AbZIBVpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 17:45:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH V6 1/2] introduce ALS sysfs class
Date: Wed, 2 Sep 2009 23:46:11 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-rjw; KDE/4.3.0; x86_64; ; )
Cc: Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <1251789947.3483.215.camel@rzhang-dt> <200909022312.58494.rjw@sisk.pl> <20090902211414.GA2789@elf.ucw.cz>
In-Reply-To: <20090902211414.GA2789@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909022346.11475.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 September 2009, Pavel Machek wrote:
> On Wed 2009-09-02 23:12:58, Rafael J. Wysocki wrote:
> > On Tuesday 01 September 2009, Pavel Machek wrote:
> > > 
> > > > > > IMO, 0 and -1 are not errors. they just suggest that the Ambient Light
> > > > > > illuminance is beyond the device support range, while the device is
> > > > > > still working normally.
> > > > > > what about exporting these values (0 and -1) to user space directly?
> > > > > 
> > > > > Returning 0 for "below" range and 99999999 for "above" range would be
> > > > > nice, yes. 
> > > > 
> > > > Why not 0 and "all ones" or 0 and -1.
> > > > 
> > > > Is there anything wrong with -1 in particular?
> > > 
> > > Normal people expect -1 to be less than 123, and output is in ascii. If
> > > you make it ((unsigned) ~0) I guess that becomes acceptable.
> > 
> > Well, "-1" is a perfectly valid alphanumerical representation of an int.
> > I don't really see the problem with the "-", unless we're talking about some
> > broken user space, that is.
> 
> No. But if you see illumination value of -1 lumen, do you really
> expect a *lot* of light?

Not really.  I'd rather intrepret it as "the number is not to be trusted",
which is what it means.

The problem with "all ones" is that it depends on the size of the underlying
data type, which is not nice.  Also, if you want that to be a "big number",
there's no clear rule to tell what the number should actually be.

Anyway, this really is a matter of definition.  If we document the attribute
to read as "-1" in specific circumstances, the user space will have to take
that into account.

Thanks,
Rafael
