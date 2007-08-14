Return-Path: <linux-kernel-owner+w=401wt.eu-S1761796AbXHNPIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761796AbXHNPIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759142AbXHNPI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:08:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232AbXHNPI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:08:27 -0400
Message-ID: <46C1C560.80801@redhat.com>
Date: Tue, 14 Aug 2007 11:08:16 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Niels <zorglub_olsen@hotmail.com>
CC: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: Problems with USB disk [solved]
References: <f9akh8$ori$1@sea.gmane.org> <20070807211847.GA25391@kroah.com> <f9c71t$r60$1@sea.gmane.org> <200708081357.03238.ismail@pardus.org.tr> <f9hmia$dol$1@sea.gmane.org> <f9mlcc$njk$1@sea.gmane.org> <f9pr31$rdq$1@sea.gmane.org>
In-Reply-To: <f9pr31$rdq$1@sea.gmane.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2007 10:50 AM, Niels wrote:
> On Sunday 12 August 2007 11:54, Niels wrote:
> 
>> On Friday 10 August 2007 14:43, Niels wrote:
>>
>>> On Wednesday 08 August 2007 12:57, Ismail Dönmez wrote:
>>>
>>>> On Wednesday 08 August 2007 13:48:29 you wrote:
>>>>> On Tuesday 07 August 2007 23:18, Greg KH wrote:
>>>>>> On Tue, Aug 07, 2007 at 10:26:15PM +0200, Niels wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> I'm having problems with a new 500 GB USB disk. It works, but
>>>>>>> sometimes I get these in dmesg:
>>>>>>>
>>>>>>>
>>>>>>> usb 1-3: reset high speed USB device using ehci_hcd and address 2
>>>>>>> usb 5-1: USB disconnect, address 2
>>>>>>> drivers/usb/class/usblp.c: usblp0: removed
>>>>>>> sd 0:0:0:0: Device not ready: <6>: Sense Key : 0x2 [current]
>>>>>>>
>>>>>>> : ASC=0x4 ASCQ=0x2
>>>>>>>
>>>>>>> end_request: I/O error, dev sda, sector 254148215
>>>>>>> sd 0:0:0:0: Device not ready: <6>: Sense Key : 0x2 [current]
>>>>>>>
>>>>>>> : ASC=0x4 ASCQ=0x2
>>>>>>>
>>>>>>> end_request: I/O error, dev sda, sector 252434023
>>>>>>> EXT3-fs error (device sda1): ext3_find_entry: reading directory
>>>>>>> #15761836 offset 0
>>>>>>>
>>>>>>>
>>>>>>> There's also a printer connected. This is on a pci/usb2 card. When
>>>>>>> the above happens, I get I/O errors. When I mount the drive next,
>>>>>>> there are errors and often missing files. Quite annoying!
>>>>>>>
>>>>>>> Kernel is 2.6.21
>>>>>>>
>>>>>>> What's going on?
>>>>>> You have a low voltage issue, or a bad cable.  The device is
>>>>>> electronically disconnecting itself.  Try using a externally-powered
>>>>>> hub, or a new cable.
>>>> I am seeing a similar problem with 2.6.22 and 2.6.23-* kernels with my
>>>> 60G iPod Video, works fine with 2.6.18 kernel though.
>>>>
>>>
>>> So far I'm seeing this:
>>>
>>> - On 2.6.21 I mount the drive. After a while it spins down, and when I
>>> then unmount it, an error pops up in dmesg.
>>>
>>> - On 2.6.18 I can't provoke the same error. The drive doesn't appear to
>>> spin down. I don't know if the data corruption from 2.6.21 occurs with
>>> regular use.
>>>
>>> There are a number of other factor I need to eliminate on my system, but
>>> that's it so far. CONFIG_USB_SUSPEND is not set on either kernel.
>>
>> OK, on a vanilla 2.6.18.8 I also have this problem, with both the pci/usb2
>> card, and the usb1 on the board. I listen to music from the drive, and
>> after some time (10-20 minutes or so), it freaks out:
>>
>> =========
>> sd 1:0:0:0: Device not ready: <6>: Current: sense key=0x2
>>     ASC=0x4 ASCQ=0x2
>> end_request: I/O error, dev sda, sector 126693711
>> sd 1:0:0:0: Device not ready: <6>: Current: sense key=0x2
>>     ASC=0x4 ASCQ=0x2
>> end_request: I/O error, dev sda, sector 126693711
>> sd 1:0:0:0: Device not ready: <6>: Current: sense key=0x2
>>     ASC=0x4 ASCQ=0x2
>> end_request: I/O error, dev sda, sector 126693711
>> =========
>>
> 
> Using a new PSU and a powered hub made no difference. But I found a solution
> here:
> 
> http://alienghic.livejournal.com/382903.html
> 
> Basically, the problem is, as suspected, that the drive spins down / goes to
> suspend. This can be disabled with "sdparm --clear STANDBY -6 /dev/sda".
> 
> It seems to me to be an error that the kernel reports this as something like
> a hardware failure. Or at least very misleading.
> 

Oh, nice. The usb-storage (SCSI) disk spins itself down and we can't handle that.
Should we be disabling auto-spindown when we connect the device, or be able to
handle this by sending the start command when needed?

