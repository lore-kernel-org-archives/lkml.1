Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbZICCh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbZICCh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 22:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbZICCh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 22:37:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:35232 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbZICCh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 22:37:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,322,1249282800"; 
   d="scan'208";a="723428582"
Subject: Re: [PATCH V6 1/2] introduce ALS sysfs class
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Greg KH <greg@kroah.com>
In-Reply-To: <200909030216.04896.rjw@sisk.pl>
References: <1251789947.3483.215.camel@rzhang-dt>
	 <200909022346.11475.rjw@sisk.pl> <20090902215148.GA3429@elf.ucw.cz>
	 <200909030216.04896.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 03 Sep 2009 10:35:39 +0800
Message-Id: <1251945339.3483.260.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-03 at 08:16 +0800, Rafael J. Wysocki wrote:
> On Wednesday 02 September 2009, Pavel Machek wrote:
> > On Wed 2009-09-02 23:46:11, Rafael J. Wysocki wrote:
> > > On Wednesday 02 September 2009, Pavel Machek wrote:
> > > > On Wed 2009-09-02 23:12:58, Rafael J. Wysocki wrote:
> > > > > On Tuesday 01 September 2009, Pavel Machek wrote:
> > > > > > 
> > > > > > > > > IMO, 0 and -1 are not errors. they just suggest that the Ambient Light
> > > > > > > > > illuminance is beyond the device support range, while the device is
> > > > > > > > > still working normally.
> > > > > > > > > what about exporting these values (0 and -1) to user space directly?
> > > > > > > > 
> > > > > > > > Returning 0 for "below" range and 99999999 for "above" range would be
> > > > > > > > nice, yes. 
> > > > > > > 
> > > > > > > Why not 0 and "all ones" or 0 and -1.
> > > > > > > 
> > > > > > > Is there anything wrong with -1 in particular?
> > > > > > 
> > > > > > Normal people expect -1 to be less than 123, and output is in ascii. If
> > > > > > you make it ((unsigned) ~0) I guess that becomes acceptable.
> > > > > 
> > > > > Well, "-1" is a perfectly valid alphanumerical representation of an int.
> > > > > I don't really see the problem with the "-", unless we're talking about some
> > > > > broken user space, that is.
> > > > 
> > > > No. But if you see illumination value of -1 lumen, do you really
> > > > expect a *lot* of light?
> > > 
> > > Not really.  I'd rather intrepret it as "the number is not to be trusted",
> > > which is what it means.
> > > 
> > > The problem with "all ones" is that it depends on the size of the underlying
> > > data type, which is not nice.  Also, if you want that to be a "big number",
> > > there's no clear rule to tell what the number should actually be.
> > > 
> > > Anyway, this really is a matter of definition.  If we document the attribute
> > > to read as "-1" in specific circumstances, the user space will have to take
> > > that into account.
> > 
> > Well, I'd prefer to specify -1 as "underflow" and 1000000000 as
> > "overflow". Any numbers should work, but ... lets make the interface
> > logical if we can.
> 
> The interface is already defined, isn't it?  And we're now considering whether
> or not to pass the values defined by the interface directly to the user space,
> which I think is the right thing to do, because we have no reason _whatsoever_
> to change them to anything else.
> 
I agree.
For environment illuminance, "-1" is surely an invalid value.
IMO, users would rather look for what it actually means than interpret
it to a value lower than 0.

thanks,
rui


