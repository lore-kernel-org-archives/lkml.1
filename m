Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733Ab0AYSus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab0AYSus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 13:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391Ab0AYSur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 13:50:47 -0500
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:56727 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab0AYSur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 13:50:47 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B5DE85D.7050806@jic23.retrosnub.co.uk>
Date: Mon, 25 Jan 2010 18:52:13 +0000
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg KH <greg@kroah.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       "Frysinger, Michael" <Michael.Frysinger@analog.com>,
       "Getz, Robin" <Robin.Getz@analog.com>,
       Jean Delvare <khali@linux-fr.org>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [RFC] Staging:IIO: New ABI
References: <4B571DA4.6070603@cam.ac.uk> <20100120153748.GA29401@kroah.com> 	<4B573501.9090001@jic23.retrosnub.co.uk> <ac3eb2511001200914g601422bfm52f4fc1bdfe66c27@mail.gmail.com>
In-Reply-To: <ac3eb2511001200914g601422bfm52f4fc1bdfe66c27@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

On 01/20/10 17:14, Kay Sievers wrote:
> On Wed, Jan 20, 2010 at 17:53, Jonathan Cameron
> <kernel@jic23.retrosnub.co.uk> wrote:
>>>> What:                /sys/.../ring_buffer[m]/ring_event[o]/dev
>>>> Description:
>>>>              Ring buffer m event character device o major:minor numbers.
>>>
>>> Again, don't bury devices.  Or if you are, use a bus, not a class,
>>> that's the wrong classification.
>> Cool, I'll look into making the change.  What we really have here
>> is a single conceptual device using a pair or character interfaces.  Is a bus
>> the right way to handle that?
> 
> "bus" and "class" are almost the same regarding the driver core, it
> should not make any difference for you. The "class" implementation is
> only a very simple case of a "bus" -- just with a pretty much broken
> userspace interface. :)
> 
> Today, if we would start from scratch, there would be only something
> like /sys/subsystem in the layout of today's /sys/bus, and /sys/class,
> /sys/bus and /sys/block would not event exist. Tools like udev
> intentionally make no difference between them, and do not allow to
> distinguish between "class" or "bus". It's just called "susbsystem"
> there from the early days on.
> 
> The "class" has only a single flat directory in  /sys so it can never
> be extended with anything custom. No new subsystem should use the
> class interface anymore, all should use a "bus". I guess it's time to
> document that somewhere. :)
> 
Thanks for clearing that up.  IIO is now a bus, as you said the changes
needed were very minor.  I'll post the patch in a series with the ABI
changes once the rest have settled down.

The move to a bus has, in a sense (by looking at how others, particularly
usb handle things), suggested that the 'bus element' naming could usefully
provide more information about where things have come from. 

Perhaps the contents of /sys/bus/iio should be something like

dev0
dev0:event0
[dev0:event1 etc]
dev0:ring
dev0:ring:access
dev0:ring:event

Note that dev0:ring only exists as a device to allow it to be used as a common
parent for dev0:ring:access and dev0:ring:event, making the internal navigation
a little more obvious along with providing a site for attributes that aren't
specific to the ring access or event devices.

This does lead to some slightly clunky naming inside directories, complicating
user space access marginally

dev0/dev0:ring/dev0:ring:access etc

Is this added clarity something people feel is worth doing?

Jonathan
