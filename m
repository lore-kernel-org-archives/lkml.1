Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbZIONhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbZIONhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 09:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbZIONhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 09:37:48 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:62946 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbZIONhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 09:37:47 -0400
Message-ID: <4AAF98A3.7080404@codemonkey.ws>
Date: Tue, 15 Sep 2009 08:37:39 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Amit Shah <amit.shah@redhat.com>
CC: Alan Cox <alan@linux.intel.com>, rusty@rustcorp.com.au,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic
 guest and host communication
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <1252678386-17404-2-git-send-email-amit.shah@redhat.com> <20090911170010.34c80f2d@linux.intel.com> <20090915123752.GB5247@amit-x200.redhat.com> <4AAF8F26.8030503@codemonkey.ws> <20090915130357.GC5247@amit-x200.redhat.com>
In-Reply-To: <20090915130357.GC5247@amit-x200.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah wrote:
> On (Tue) Sep 15 2009 [07:57:10], Anthony Liguori wrote:
>   
>> Amit Shah wrote:
>>     
>>> Hey Greg,
>>>
>>> Can you tell me how this could work out -- each console port could have
>>> a "role" string associated with it (obtainable from the invoking qemu
>>> process in case of qemu/kvm). Something that I have in mind currently
>>> is:
>>>
>>> $ qemu-kvm ... -virtioconsole role=org/qemu/clipboard
>>>
>>> and then the guest kernel sees the string, and puts the
>>> "org/qemu/clipboard" in some file in sysfs. Guest userspace should then
>>> be able to open and read/write to
>>>
>>> /dev/virtio_console/org/qemu/clipboard
>>>   
>>>       
>> That's probably not what we want.  I imagine what we want is:
>>
>> /dev/ttyV0
>> /dev/ttyV1
>> /dev/ttyVN
>>
>> And then we want:
>>
>> /sys/class/virtio-console/ttyV0/name -> "org.qemu.clipboard"
>>
>> Userspace can detect when new virtio-consoles appear via udev events.   
>> When it sees a new ttyVN, it can then look in sysfs to discover it's 
>> name.
>>     
>
> OK; but that's kind of roundabout isn't it? An application, instead of
> watching for the console port it's interested in, has to instead monitor
> all the ports.
>   

If you wanted to use /dev/virtio/org/qemu/clipboard you still have the 
same problem.  You have to use udev or inotify to listen for a new file 
in a directory.

The /dev/ path may look nicer from a high level, but the code ends up 
being roughly the same for either approach.  What I propose has the 
advantage of looking like existing subsystems.  It also avoids encoding 
device information in the device name.

> So in effect there has to be one app monitoring for new ports and then
> that app exec'ing the corresponding app meant for that port.
>   

I think if you think through both models, they end up looking the same.

Regards,

Anthony Liguroi
