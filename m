Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbZJCQyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbZJCQyz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 12:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbZJCQyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 12:54:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:24526 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbZJCQyx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 12:54:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AJwIzQV40VNbSuDu1H8QitxalTXeRiBDctFPR6DTLANb52QriKB8xTPkMAZ3zMuafV
         BdnbdrnUsxUsPpg633oPoFPXwrrzzcFKH8ephsjBpBdRpIjeEhzwIqmSVISGdva/9B4s
         xdKF/XeWyXDXGBx10qCOANsQyvnv3x9x4cvF4=
MIME-Version: 1.0
In-Reply-To: <20091003154844.GA24819@xanatos>
References: <94a0d4530910030335p2eae17a6wddf6d87b7f60b712@mail.gmail.com>
	 <20091003154844.GA24819@xanatos>
Date: Sat, 3 Oct 2009 19:53:05 +0300
Message-ID: <94a0d4530910030953l1dfcde46qac56f02b1290faa2@mail.gmail.com>
Subject: Re: Annoying problems with lacie external hd (JMicron 0x2339?)
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 3, 2009 at 6:48 PM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
> On Sat, Oct 03, 2009 at 01:35:58PM +0300, Felipe Contreras wrote:
>> Hi,
>>
>> This is with 2.6.31.1.
>>
>> I'm having a lot of problems with a lacie external hd[1]. It seems the
>> actual disk is a seagate ST375064, and the bridge is a JMicron 2339.
>>
>> In normal usage what I see is that if I don't use the disk after a
>> while hear a loud click (as if something got stuck) and then I cannot
>> use it any more; I have to turn it off and on again.
>>
>> But then I started to see some problems on one fs, so I ran badblocks
>> and I noticed a lot of strange behavior. It seems once I get a
>> read/write error then I get more of them in a row, and after a while I
>> hear another loud click, and then I only get read/write errors
>> constantly.
>>
>> I noticed in 'unusual_devs.h' there's already a quirk for another
>> JMicron product, so I tried to do the same:
>>
>> +UNUSUAL_DEV(  0x152d, 0x2339, 0x0000, 0xffff,
>> +               "JMicron",
>> +               "USB to ATA/ATAPI Bridge",
>> +               US_SC_DEVICE, US_PR_DEVICE, NULL,
>> +               US_FL_IGNORE_RESIDUE | US_FL_SANE_SENSE ),
>>
>> This seemed to help with the consecutive errors, but not with the loud click.
>>
>> This is what I get when this click happens:
>>
>> Oct  3 13:14:54 annwn kernel: [  351.099096] usb 1-1: reset high speed
>> USB device using ehci_hcd and address 3
>> Oct  3 13:14:54 annwn kernel: [  351.213541] usb 1-1: device firmware changed
>> Oct  3 13:14:54 annwn kernel: [  351.213588] usb 1-1: USB disconnect, address 3
>> Oct  3 13:14:54 annwn kernel: [  351.213633] sd 4:0:0:0: Device
>> offlined - not ready after error recovery
>> Oct  3 13:14:54 annwn kernel: [  351.213650] sd 4:0:0:0: [sdb]
>> Unhandled error code
>> Oct  3 13:14:54 annwn kernel: [  351.213655] sd 4:0:0:0: [sdb] Result:
>> hostbyte=DID_ABORT driverbyte=DRIVER_OK
>> Oct  3 13:14:54 annwn kernel: [  351.213663] end_request: I/O error,
>> dev sdb, sector 8596352
>> Oct  3 13:14:54 annwn kernel: [  351.213774] sd 4:0:0:0: rejecting I/O
>> to offline device
>> Oct  3 13:14:54 annwn kernel: [  351.213816] sd 4:0:0:0: rejecting I/O
>> to offline device
>> Oct  3 13:14:54 annwn kernel: [  351.213852] sd 4:0:0:0: rejecting I/O
>> to offline device
>> Oct  3 13:14:54 annwn kernel: [  351.213891] sd 4:0:0:0: rejecting I/O
>> to offline device
>> Oct  3 13:14:54 annwn kernel: [  351.213927] sd 4:0:0:0: rejecting I/O
>> to offline device
>> Oct  3 13:14:54 annwn kernel: [  351.213962] sd 4:0:0:0: rejecting I/O
>> to offline device
>> Oct  3 13:14:54 annwn kernel: [  351.213997] sd 4:0:0:0: rejecting I/O
>> to offline device
>> Oct  3 13:14:54 annwn kernel: [  351.214202] sd 4:0:0:0: rejecting I/O
>> to offline device
>> Oct  3 13:14:55 annwn kernel: [  351.317278] usb 1-1: new high speed
>> USB device using ehci_hcd and address 4
>> Oct  3 13:14:55 annwn kernel: [  351.432192] usb 1-1: New USB device
>> found, idVendor=152d, idProduct=2339
>> Oct  3 13:14:55 annwn kernel: [  351.432196] usb 1-1: New USB device
>> strings: Mfr=1, Product=2, SerialNumber=5
>> Oct  3 13:14:55 annwn kernel: [  351.432199] usb 1-1: Product: USB to
>> ATA/ATAPI Bridge
>> Oct  3 13:14:55 annwn kernel: [  351.432202] usb 1-1: Manufacturer: JMicron
>> Oct  3 13:14:55 annwn kernel: [  351.432204] usb 1-1: SerialNumber: 5D27FFFFFFFF
>> Oct  3 13:14:55 annwn kernel: [  351.432321] usb 1-1: configuration #1
>> chosen from 1 choice
>> Oct  3 13:14:55 annwn kernel: [  351.432791] scsi5 : SCSI emulation
>> for USB Mass Storage devices
>>
>> Can anyone help? This disk is important for me =/
>
> The log shows the device just disconnected from the system.  You should
> post more of the logfile before the disconnect so we can see if it's an
> issue with the USB core.  Did it work with a previous kernel?

There was nothing special in the log. I think it was completely silent
for a while. I'll grab more logs and post them.

I'm not sure if it was working properly on previous kernels. If it
did, it was probably a long time ago. I least I can remember this
behavior since .28.

> It could be that your disk is just dying, and occasionally
> disconnecting.  Or you could have a bad cable or a hub that's
> introducing noise.  Can you try a different USB cable?

I already tried with a different cable. Another external drive I have,
worked perfectly (badblocks didn't return a single bad one) with both
cables.

Cheers.

-- 
Felipe Contreras
