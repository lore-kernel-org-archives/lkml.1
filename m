Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbZKJJxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbZKJJxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbZKJJxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:53:10 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:54542 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbZKJJxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:53:08 -0500
Date: Tue, 10 Nov 2009 11:52:55 +0200
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-omap@vger.kernel.org,
       Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 1/2] staging: iio: tsl2563 ambient light sensor driver
Message-ID: <20091110095255.GD1773@smtp.gmail.com>
Mail-Followup-To: Jonathan Cameron <jic23@cam.ac.uk>,
	List Linux Kernel <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-omap@vger.kernel.org,
	Zhang Rui <rui.zhang@intel.com>
References: <1257772468-4004-1-git-send-email-amit.kucheria@verdurent.com>
 <4AF81FE5.5080102@cam.ac.uk>
 <20091109142430.GZ1773@smtp.gmail.com>
 <4AF85ABB.7060406@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4AF85ABB.7060406@cam.ac.uk>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09 Nov 09, Jonathan Cameron wrote:
> Amit Kucheria wrote:
> > On 09 Nov 09, Jonathan Cameron wrote:
> >> Hi Amit,
> >>
> >> Normally I'd welcome this in IIO, except that all ambient light sensors are in the
> >> process of moving to the new ALS subsystem.  There are still some issues to resolve
> >> in that subsystem (mainly to do with naming conventions) but hopefully we will
> >> get them sorted out shortly.
> > 
> > Groan! :)
> You have my sympathies on this! Typical that the first other developer to put
> forward a patch for IIO picks the one type of device we are moving out.

Hehe :) Will accelerometers and leds move to IIO?

> If you do have any comments on IIO as a result of using it please send them
> on.

I guess the only major comment would be that the Documentation/device.txt
probably needs to be more focussed on driver writers. For example,

indio_dev->attrs
   general attributes such as polled access to device channels.

would become

indio_dev->attrs
	sysfs attribute control files. This contains a pointer to a struct
	attribute_group containing a list of all attributes that export a
	sysfs control.

followed by a sample driver stub. That is probably the only part where I got
stuck for a bit. The rest was straightforward after looking at the source for
the tsl2561.

> > Who will be the subsystem maintainer and is there already a public git
> > tree?
> No git tree as far as I know.  Maintainer is Zhang Rui (Cc'd)
> Zhang, what are your plans wrt to that?  I guess I can put one up with the current
> patches if it is helpful?  We really need to sort out the naming issue as the one
> thing that people have come out against. 

No plans. Just wanted to know if there was a tree where I could pull in
regularly to see changes without having to wade through LKML :)

> After that I'm guessing ping Andrew Morton to see if he is willing to handle the push
> to Linus? Or does Zhang want to try doing one directly?
> 
> >> I'll take a close look at this sometime over the next few days though.  On a quick
> >> glance at the data sheet, it looks very similar to the tsl2561.  Perhaps we can merge
> >> the drivers? Yours is certainly more complete than the tsl2561 version in IIO so it
> >> would make sense to lift the functional elements in to the code I have for an ALS
> >> driver. I hadn't posted that previously as I hadn't quite worked out how to handle
> >> the various gain related settings. What you have done seems to make sense (from a very
> >> quick look.)
> > 
> > I've got no problem merging the tsl2563 with 2561. I don't have any 2561
> > hardware to check a merged driver though.
> 
> On a reasonably thorough review of data sheets I think the only difference is the
> input voltage range and a few timing parameters.  These two chips even use the same
> addresses.  I'll actually test your driver against the tsl2561 sometime later in the
> week to be sure.  So the merge looks like adding a few more lines to the i2c_device_id
> table.  As a quick comment you would ideally have the tsl2563 and tsl2562 in there
> already.
> > 
> > 
> > Do you think the ALS framework will be finalised before the 2.6.33 merge
> > window (in a few weeks)? If not, I wonder if Greg would take this driver to
> > staging to begin with and I'll modify it to use the ALS subsystem when it
> > settles down.
> I'm certainly happy with that as an option if Greg is willing. In fact,
> adding this with tsl2560-> tsl2563 support and removing the current tsl2561 driver would
> be great (post any reviews over the next couple of days).
> 

I could certainly add support for tsl2560-2562 to my driver if you want, along
with incorporating comments from the review.

Regards,
Amit

-- 
-------------------------------------------------------------------------
Amit Kucheria,				 Kernel Developer, Verdurent
-------------------------------------------------------------------------
