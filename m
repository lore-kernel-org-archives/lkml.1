Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbZIONFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbZIONFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 09:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbZIONFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 09:05:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbZIONFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 09:05:02 -0400
Date: Tue, 15 Sep 2009 18:33:57 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Alan Cox <alan@linux.intel.com>, rusty@rustcorp.com.au,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
	generic guest and host communication
Message-ID: <20090915130357.GC5247@amit-x200.redhat.com>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <1252678386-17404-2-git-send-email-amit.shah@redhat.com> <20090911170010.34c80f2d@linux.intel.com> <20090915123752.GB5247@amit-x200.redhat.com> <4AAF8F26.8030503@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAF8F26.8030503@codemonkey.ws>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) Sep 15 2009 [07:57:10], Anthony Liguori wrote:
> Amit Shah wrote:
>> Hey Greg,
>>
>> Can you tell me how this could work out -- each console port could have
>> a "role" string associated with it (obtainable from the invoking qemu
>> process in case of qemu/kvm). Something that I have in mind currently
>> is:
>>
>> $ qemu-kvm ... -virtioconsole role=org/qemu/clipboard
>>
>> and then the guest kernel sees the string, and puts the
>> "org/qemu/clipboard" in some file in sysfs. Guest userspace should then
>> be able to open and read/write to
>>
>> /dev/virtio_console/org/qemu/clipboard
>>   
>
> That's probably not what we want.  I imagine what we want is:
>
> /dev/ttyV0
> /dev/ttyV1
> /dev/ttyVN
>
> And then we want:
>
> /sys/class/virtio-console/ttyV0/name -> "org.qemu.clipboard"
>
> Userspace can detect when new virtio-consoles appear via udev events.   
> When it sees a new ttyVN, it can then look in sysfs to discover it's 
> name.

OK; but that's kind of roundabout isn't it? An application, instead of
watching for the console port it's interested in, has to instead monitor
all the ports.

So in effect there has to be one app monitoring for new ports and then
that app exec'ing the corresponding app meant for that port.

		Amit
