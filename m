Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbZIOVwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbZIOVwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 17:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758714AbZIOVwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 17:52:07 -0400
Received: from www.sr71.net ([198.145.64.142]:43931 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbZIOVwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 17:52:06 -0400
Subject: Re: [RFC][PATCH] LED driver for Intel NAS SS4200 series
From: Dave Hansen <dave@sr71.net>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1253050704.30165.64.camel@dax.rpnet.com>
References: <1253047135.10449.11657.camel@nimitz>
	 <1253050704.30165.64.camel@dax.rpnet.com>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 14:52:08 -0700
Message-Id: <1253051528.10449.11884.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 22:38 +0100, Richard Purdie wrote:
> On Tue, 2009-09-15 at 13:38 -0700, Dave Hansen wrote:
> > This code is based on a driver that came in the "Open-source
> > and GPL components" download here:
> >     
> > http://downloadcenter.intel.com/SearchResult.aspx?lang=eng&ProductFamily=Server+Products&ProductLine=Intel%C2%AE+Storage+Systems&ProductProduct=Intel%C2%AE+Entry+Storage+System+SS4200-E&OSVersion=OS+Independent
> >     
> > It was in a file called nasgpio.c inside of a second zip file
> > called SS4200-E_Linux_SIO_Driver-v1.4.zip.
> > 
> > That code used an ioctl() call to operate the LEDs.  It also
> > created a new top-level /proc file just to let userspace locate
> > which dynamic major number had been allocated to the device.
> > I decided that the interface probably wasn't mergeable in that
> > form. :)
> >     
> > I ripped out all of the hardware monitor support from nasgpio.c
> > as well as the smbus code that controls the LED brightness.  I
> > then converted the code to use the existing LED interfaces
> > rather than the ioctl().  I don't have any need for brightness
> > control, and its code is *completely* separate from the on/off
> > controls implemented here.  If anyone else wants it, I'd be
> > happy to look into adding it, but I don't care enough for now.
> 
> At a quick review this looks good. One question: These LEDs appear to be
> attached to generic GPIOs on a southbridge that is probably in other
> devices? If so, how do we know they're connected to LEDs? Do we need to
> add some further check of what kind of device we're running on?

Good question.  I assumed that the PCI ids were a sufficient enough
check.  But, you're right, those PCI ids look like they're for all ICH7
boards.

Any suggestions on what kinds of checks we might add?  This thing acts
like a pretty generic normal PC.  Do any of the other LED drivers have a
similar problem?

-- Dave

