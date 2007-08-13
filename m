Return-Path: <linux-kernel-owner+w=401wt.eu-S944542AbXHMQLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944542AbXHMQLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947376AbXHMOuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:50:35 -0400
Received: from main.gmane.org ([80.91.229.2]:54637 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759875AbXHMOub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:50:31 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Niels <zorglub_olsen@hotmail.com>
Subject: Re: Problems with USB disk [solved]
Date: Mon, 13 Aug 2007 16:50:08 +0200
Message-ID: <f9pr31$rdq$1@sea.gmane.org>
References: <f9akh8$ori$1@sea.gmane.org> <20070807211847.GA25391@kroah.com> <f9c71t$r60$1@sea.gmane.org> <200708081357.03238.ismail@pardus.org.tr> <f9hmia$dol$1@sea.gmane.org> <f9mlcc$njk$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 62.79.44.136.adsl.gl.tiscali.dk
User-Agent: KNode/0.10.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 August 2007 11:54, Niels wrote:

> On Friday 10 August 2007 14:43, Niels wrote:
> 
>> On Wednesday 08 August 2007 12:57, Ismail Dönmez wrote:
>> 
>>> On Wednesday 08 August 2007 13:48:29 you wrote:
>>>> On Tuesday 07 August 2007 23:18, Greg KH wrote:
>>>> > On Tue, Aug 07, 2007 at 10:26:15PM +0200, Niels wrote:
>>>> >> Hi,
>>>> >>
>>>> >> I'm having problems with a new 500 GB USB disk. It works, but
>>>> >> sometimes I get these in dmesg:
>>>> >>
>>>> >>
>>>> >> usb 1-3: reset high speed USB device using ehci_hcd and address 2
>>>> >> usb 5-1: USB disconnect, address 2
>>>> >> drivers/usb/class/usblp.c: usblp0: removed
>>>> >> sd 0:0:0:0: Device not ready: <6>: Sense Key : 0x2 [current]
>>>> >>
>>>> >> : ASC=0x4 ASCQ=0x2
>>>> >>
>>>> >> end_request: I/O error, dev sda, sector 254148215
>>>> >> sd 0:0:0:0: Device not ready: <6>: Sense Key : 0x2 [current]
>>>> >>
>>>> >> : ASC=0x4 ASCQ=0x2
>>>> >>
>>>> >> end_request: I/O error, dev sda, sector 252434023
>>>> >> EXT3-fs error (device sda1): ext3_find_entry: reading directory
>>>> >> #15761836 offset 0
>>>> >>
>>>> >>
>>>> >> There's also a printer connected. This is on a pci/usb2 card. When
>>>> >> the above happens, I get I/O errors. When I mount the drive next,
>>>> >> there are errors and often missing files. Quite annoying!
>>>> >>
>>>> >> Kernel is 2.6.21
>>>> >>
>>>> >> What's going on?
>>>> >
>>>> > You have a low voltage issue, or a bad cable.  The device is
>>>> > electronically disconnecting itself.  Try using a externally-powered
>>>> > hub, or a new cable.
>>> 
>>> I am seeing a similar problem with 2.6.22 and 2.6.23-* kernels with my
>>> 60G iPod Video, works fine with 2.6.18 kernel though.
>>> 
>>> Rehards,
>>> ismail
>>> 
>> 
>> (no need to CC me)
>> 
>> So far I'm seeing this:
>> 
>> - On 2.6.21 I mount the drive. After a while it spins down, and when I
>> then unmount it, an error pops up in dmesg.
>> 
>> - On 2.6.18 I can't provoke the same error. The drive doesn't appear to
>> spin down. I don't know if the data corruption from 2.6.21 occurs with
>> regular use.
>> 
>> There are a number of other factor I need to eliminate on my system, but
>> that's it so far. CONFIG_USB_SUSPEND is not set on either kernel.
>> 
>> 
>> //Niels
> 
> 
> OK, on a vanilla 2.6.18.8 I also have this problem, with both the pci/usb2
> card, and the usb1 on the board. I listen to music from the drive, and
> after some time (10-20 minutes or so), it freaks out:
> 
> =========
> sd 1:0:0:0: Device not ready: <6>: Current: sense key=0x2
>     ASC=0x4 ASCQ=0x2
> end_request: I/O error, dev sda, sector 126693711
> sd 1:0:0:0: Device not ready: <6>: Current: sense key=0x2
>     ASC=0x4 ASCQ=0x2
> end_request: I/O error, dev sda, sector 126693711
> sd 1:0:0:0: Device not ready: <6>: Current: sense key=0x2
>     ASC=0x4 ASCQ=0x2
> end_request: I/O error, dev sda, sector 126693711
> =========
> 
> Will updating to 2.6.23 and turning off autosuspend explicitly help? Will
> putting the disk on a powered hub help?
> 
> 
> //Niels


Using a new PSU and a powered hub made no difference. But I found a solution
here:

http://alienghic.livejournal.com/382903.html

Basically, the problem is, as suspected, that the drive spins down / goes to
suspend. This can be disabled with "sdparm --clear STANDBY -6 /dev/sda".

It seems to me to be an error that the kernel reports this as something like
a hardware failure. Or at least very misleading.


//Niels

