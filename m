Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab0BPC4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 21:56:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756087Ab0BPC43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 21:56:29 -0500
Date: Mon, 15 Feb 2010 18:49:24 -0800
From: Greg KH <gregkh@suse.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       Ira Snyder <iws@ovro.caltech.edu>, Jean Delvare <khali@linux-fr.org>,
       Samu Onkalo <samu.p.onkalo@nokia.com>,
       Stefani Seibold <stefani@seibold.net>
Subject: Re: [RFC] Staging: IIO: New ABI V2
Message-ID: <20100216024924.GA29008@suse.de>
References: <4B6C619C.3000302@cam.ac.uk> <201002151526.53539.rgetz@blackfin.uclinux.org> <8bd0f97a1002151658l742444cg18b2a38846cbfe37@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a1002151658l742444cg18b2a38846cbfe37@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 07:58:12PM -0500, Mike Frysinger wrote:
> On Mon, Feb 15, 2010 at 15:26, Robin Getz wrote:
> > On Fri 5 Feb 2010 13:21, Jonathan Cameron pondered:
> >> Here is another iteration of the ABI spec for IIO with changes made
> >> in response to http://lkml.org/lkml/2010/1/20/195 and
> >> http://marc.info/?l=lm-sensors&m=126496271320649&w=2 along with a few
> >> other general tidy ups.
> >>
> >> If there are no major issues raised, we may begin working on the move
> >> to this ABI shortly on the basis any minor changes can always get
> >> cleaned up before those patches merge. ??I'll also be doing a formal
> >> version of this file for in kernel documentation once things are
> >> fairly stable with all of the information not relevant to this
> >> discussion.
> >>
> >> Changes since v1:
> >>
> >> * iio is now a bus with directory changes resulting in this document.
> >> * moved to in0_raw etc for voltage sensors to avoid confusion with
> >> ?? a completely different ABI from hwmon. ??Jean made the point that
> >> ?? we shouldn't take this to far, but as things currently stand there
> >> ?? is no disadvantage in this name change.
> >> * dropped freefall event for now. More discussions need to be had on this
> >> ?? and in a straight IIO world we normally won't care about this one anyway.
> >> * 'device' naming changed for the various subsidiary devices so as make
> >> ?? the interconnections more obvious. ??I haven't tried implementing this
> >> ?? yet, but I think the small amount of pain involved is worth it for
> >> ?? increased clarity. The only exception is triggers where the connections
> >> ?? are not specified as a given trigger may not have and IIO device
> >> ?? associated with it. ??Anyone suggest a scheme for this? (see about 10
> >> ?? lines below to clarify what I mean here!)
> >> * As conversion of the max1363 driver over to a consistent scan_element
> >> ?? interface will mean that these will only apply to the ring buffer
> >> ?? (rather than direct capture), scan_elements is moved into the ring
> >> ?? buffer device directory.
> >> * Switch ring for simply buffer as it might be a fifo or other buffer
> >> ?? form instead.
> >>
> >> At times I may have suppressed links that would be created by the tree of
> >> devices. In the flat base directory a given driver can now create the
> >> following:
> >>
> >> device[n]
> >> device[n]:ring
> >> device[n]:ring:access
> >> device[n]:ring:event
> >> device[n]:event[m]
> >> trigger[o]
> >>
> >
> > What exists today still requires a copy_[to|from]_user when using the ring
> > buffer (and then another cache_flush if you are dma'ing things). These seems
> > pretty expensive and will consume extra cycles that will limit throughput.
> >
> > Any thoughts to a mmaped interface directly to the IIO ring buffer, so the
> > system could avoid some of the above overhead? (This is what we had to do for
> > some other drivers - which were able to handle a 40 MSample/second data
> > processed by userspace for a soft radio).
> 
> does sysfs currently support mmap-ing of files in there ?

For binary files, yes.  If you are going to use mmap, use a character
device node instead please, that's not what sysfs is for.

thanks,

greg k-h
