Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab0BOU1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 15:27:00 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:11497 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab0BOU06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 15:26:58 -0500
X-IronPort-AV: E=Sophos;i="4.49,479,1262581200"; 
   d="scan'208";a="12920261"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Analog Devices, Inc.
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [RFC] Staging: IIO: New ABI V2
Date: Mon, 15 Feb 2010 15:26:53 -0500
User-Agent: KMail/1.9.5
CC: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, Dmitry Torokhov <dtor@mail.ru>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
       "Frysinger, Michael" <Michael.Frysinger@analog.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       Ira Snyder <iws@ovro.caltech.edu>, Jean Delvare <khali@linux-fr.org>,
       Samu Onkalo <samu.p.onkalo@nokia.com>,
       Stefani Seibold <stefani@seibold.net>
References: <4B6C619C.3000302@cam.ac.uk>
In-Reply-To: <4B6C619C.3000302@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201002151526.53539.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 5 Feb 2010 13:21, Jonathan Cameron pondered:
> Dear All,
> 
> Here is another iteration of the ABI spec for IIO with changes made
> in response to http://lkml.org/lkml/2010/1/20/195 and
> http://marc.info/?l=lm-sensors&m=126496271320649&w=2 along with a few
> other general tidy ups.
> 
> If there are no major issues raised, we may begin working on the move 
> to this ABI shortly on the basis any minor changes can always get
> cleaned up before those patches merge.  I'll also be doing a formal
> version of this file for in kernel documentation once things are
> fairly stable with all of the information not relevant to this
> discussion. 
> 
> Changes since v1:
> 
> * iio is now a bus with directory changes resulting in this document.
> * moved to in0_raw etc for voltage sensors to avoid confusion with
>   a completely different ABI from hwmon.  Jean made the point that
>   we shouldn't take this to far, but as things currently stand there
>   is no disadvantage in this name change. 
> * dropped freefall event for now. More discussions need to be had on this
>   and in a straight IIO world we normally won't care about this one anyway.
> * 'device' naming changed for the various subsidiary devices so as make
>   the interconnections more obvious.  I haven't tried implementing this
>   yet, but I think the small amount of pain involved is worth it for
>   increased clarity. The only exception is triggers where the connections
>   are not specified as a given trigger may not have and IIO device
>   associated with it.  Anyone suggest a scheme for this? (see about 10
>   lines below to clarify what I mean here!) 
> * As conversion of the max1363 driver over to a consistent scan_element
>   interface will mean that these will only apply to the ring buffer
>   (rather than direct capture), scan_elements is moved into the ring
>   buffer device directory.
> * Switch ring for simply buffer as it might be a fifo or other buffer
>   form instead. 
> 
> At times I may have suppressed links that would be created by the tree of
> devices. In the flat base directory a given driver can now create the
> following: 
> 
> device[n]
> device[n]:ring
> device[n]:ring:access
> device[n]:ring:event
> device[n]:event[m]
> trigger[o]
> 

What exists today still requires a copy_[to|from]_user when using the ring 
buffer (and then another cache_flush if you are dma'ing things). These seems 
pretty expensive and will consume extra cycles that will limit throughput.

Any thoughts to a mmaped interface directly to the IIO ring buffer, so the 
system could avoid some of the above overhead? (This is what we had to do for 
some other drivers - which were able to handle a 40 MSample/second data 
processed by userspace for a soft radio).

?

