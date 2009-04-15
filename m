Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbZDOPt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbZDOPt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbZDOPtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:49:49 -0400
Received: from rtr.ca ([76.10.145.34]:33312 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbZDOPts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:49:48 -0400
Message-ID: <49E60219.9080103@rtr.ca>
Date: Wed, 15 Apr 2009 11:49:45 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Jeff Garzik <jeff@garzik.org>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: USB storage no-boot regression (bisected)
References: <Pine.LNX.4.44L0.0904151146210.3072-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0904151146210.3072-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Wed, 15 Apr 2009, Alan Cox wrote:
> 
>> Why should every user suffer a slower boot and a poorer resume time ?
>>
>> Instead make the root fs mounting look like this
>>
>>
>> 	while(my_rootfs_hasnt_appeared_and_i_am_sad()) {
>> 		wait_on(&new_disk_discovery);
>> 	}
>>
>> and poke the queue whenever we add a relevant device.
>>
>> That way if you are booting off an initrd you can finish the SATA probe
>> in parallel to getting userspace ticking over.
>>
>> On what is nowdays essentially a hot plug system it all needs turning
>> this way up - eg RAID volumes should assemble and come online as the
>> drives are discovered not at some fixed point later in userspace.
> 
> Indeed, something like this should also be used for 
> resume-from-hibernation, to wait for the swap device.
..

It just needs a way to set a finite timeout, so that server room
equipment can auto-panic-reboot and try again if a device has died.

-ml
