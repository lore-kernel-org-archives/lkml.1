Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839Ab0ATQk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab0ATQk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 11:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694Ab0ATQk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 11:40:26 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34564 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab0ATQkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 11:40:23 -0500
MIME-Version: 1.0
In-Reply-To: <20100120153748.GA29401@kroah.com>
References: <4B571DA4.6070603@cam.ac.uk> <20100120153748.GA29401@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 20 Jan 2010 17:40:06 +0100
Message-ID: <ac3eb2511001200840v185617ecm60b5282cb810a4fb@mail.gmail.com>
Subject: Re: [RFC] Staging:IIO: New ABI
To: Greg KH <greg@kroah.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
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

On Wed, Jan 20, 2010 at 16:37, Greg KH <greg@kroah.com> wrote:
> On Wed, Jan 20, 2010 at 03:13:40PM +0000, Jonathan Cameron wrote:
>> What:        /sys/class/iio/ring_buffer[m]
>> Description:
>>               Link to /sys/class/iio/device[n]/ring_buffer[m]. Ring buffer
>>               numbering may not match that of device as some devices do not
>>               have ring buffers.
>
> Why is this link needed?  Why can't you just look in the device
> directory for a ring buffer?  And wouldn't the ring buffer be 1..n for
> every device?  They shouldn't be "unique" for all iio devices, that
> would be wierd.

I think with the hidden class kobject we successfully prevent any
custom links from being created there. :) The class sysfs layout does
not allow custom links added to its single directory, it confuses
userspace.

Jonathan, if you need anything like this, please consider using a
"bus_type", which has the proper userspace interface. The "class"
interface can not be extended to make such things possible.

Thanks,
Kay
