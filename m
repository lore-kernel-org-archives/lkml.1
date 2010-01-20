Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453Ab0ATRPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab0ATRPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 12:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300Ab0ATRPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 12:15:13 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45182 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab0ATRPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 12:15:11 -0500
MIME-Version: 1.0
In-Reply-To: <4B573501.9090001@jic23.retrosnub.co.uk>
References: <4B571DA4.6070603@cam.ac.uk> <20100120153748.GA29401@kroah.com> 
	<4B573501.9090001@jic23.retrosnub.co.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 20 Jan 2010 18:14:54 +0100
Message-ID: <ac3eb2511001200914g601422bfm52f4fc1bdfe66c27@mail.gmail.com>
Subject: Re: [RFC] Staging:IIO: New ABI
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
Cc: Greg KH <greg@kroah.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       "Frysinger, Michael" <Michael.Frysinger@analog.com>,
       "Getz, Robin" <Robin.Getz@analog.com>,
       Jean Delvare <khali@linux-fr.org>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       Ira Snyder <iws@ovro.caltech.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 17:53, Jonathan Cameron
<kernel@jic23.retrosnub.co.uk> wrote:
>>> What:                /sys/.../ring_buffer[m]/ring_event[o]/dev
>>> Description:
>>>              Ring buffer m event character device o major:minor numbers.
>>
>> Again, don't bury devices.  Or if you are, use a bus, not a class,
>> that's the wrong classification.
> Cool, I'll look into making the change.  What we really have here
> is a single conceptual device using a pair or character interfaces.  Is a bus
> the right way to handle that?

"bus" and "class" are almost the same regarding the driver core, it
should not make any difference for you. The "class" implementation is
only a very simple case of a "bus" -- just with a pretty much broken
userspace interface. :)

Today, if we would start from scratch, there would be only something
like /sys/subsystem in the layout of today's /sys/bus, and /sys/class,
/sys/bus and /sys/block would not event exist. Tools like udev
intentionally make no difference between them, and do not allow to
distinguish between "class" or "bus". It's just called "susbsystem"
there from the early days on.

The "class" has only a single flat directory in  /sys so it can never
be extended with anything custom. No new subsystem should use the
class interface anymore, all should use a "bus". I guess it's time to
document that somewhere. :)

Thanks,
Kay
