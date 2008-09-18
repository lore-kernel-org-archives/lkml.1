Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbYIRAOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbYIRAOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 20:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbYIRAOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 20:14:10 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:45092 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbYIRAOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 20:14:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Z0gYzkXApY8ZGTuvsIWoaXbsn+r8bO9SnFVR6nbF/O0E3vyXF8NpxDNoWgSnqRcPLP
         59RVAf41pk6hBPQL22waChFBfakY6wYdUCbtUlZbqMq77cBNcAyzPE1n+9c3kDDSoN4Z
         JZ7Ev3TcB8Bfxk4gSAUB2W4Vvw1em/9LqdwkA=
Message-ID: <dd18b0c30809171714h23ba6c5wcba2146a9de088f@mail.gmail.com>
Date: Wed, 17 Sep 2008 17:14:07 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: [19.666764] Disabling IRQ #23
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Chris Snook" <csnook@redhat.com>,
       "April Tsui" <aprilla@gmail.com>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       Linux-usb <linux-usb@vger.kernel.org>
In-Reply-To: <6FACEDE1-72B7-45DE-ADDF-5FCD4F6E90B8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30809101206j3892e3dbpac9c48cfcaf2982f@mail.gmail.com>
	 <200809170904.20535.bjorn.helgaas@hp.com>
	 <dd18b0c30809171013w3afea64bw9c49e94afe72306a@mail.gmail.com>
	 <200809171548.04857.bjorn.helgaas@hp.com>
	 <6FACEDE1-72B7-45DE-ADDF-5FCD4F6E90B8@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 3:18 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> From what I remember this started around 2.6.27-rc1(I.g. Seeing this message
> during bootup), with having issues With ift-load probably around
> 2.6.26-rc1(should of done an upgrade then,but never got around to it), as
> for this being a regression? I guess; if this was happening with 2.6.26 and
> other previous kernels.
>  As for my situation I've rebooted again a few times with
> Not receiving this message. As for the issue being fixed? Not sure, one side
> of me says yes it is due to not having the kernel report any problems, but
> then there's the side that agrees with what you had said. maybe the problem
> doesn't happen with different user-space tools, doesn't mean the kernels
> problem is fixed.
>
> justin P. Mattock
>
>
>
> On Sep 17, 2008, at 2:48 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>
>> On Wednesday 17 September 2008 11:13:55 am Justin Mattock wrote:
>>>
>>> I've seeing something interesting at the moment
>>> with this. I've upgraded isight-firmware-tools to the latest,
>>> and instead of using udev I'm using hal. I've done numerous
>>> reboots, and am not receiving this message. I think it might have been
>>> something to do with ift-load. If I don't see this message after a few
>>> more days
>>> of rebooting, and cold starts I think we can close this.
>>
>> Maybe the problem doesn't happen with different user-space
>> tools, but that doesn't mean the kernel problem is fixed.
>>
>> And we still don't know whether this is really a regression
>> or not.
>>
>> Bjorn
>

Well it sure is nice not having any issues with ift-load, but
Bjorn you're right, So I reverted back to udev were the issue seems
to be happening. FWIW here is what I see in dmesg after loading the system
without ehci_hcd and then modprobing ehci_hcd:

[  136.764390] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  136.764429] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  136.764436] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[  136.764666] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 5
[  136.768610] ehci_hcd 0000:00:1d.7: debug port 1
[  136.768631] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[  136.768650] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50405400
[  136.792024] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00,
driver 10 Dec 2004
[  136.792464] usb usb5: configuration #1 chosen from 1 choice
[  136.792613] hub 5-0:1.0: USB hub found
[  136.792638] hub 5-0:1.0: 8 ports detected
[  136.794750] uvcvideo: Non-zero status (-84) in status completion handler.
[  136.950399] usb 1-2: USB disconnect, address 2
[  136.998597] input: appletouch disconnected
[  137.180146] usb 2-2: USB disconnect, address 2
[  137.350104] usb 3-2: USB disconnect, address 2
[  137.510109] usb 4-1: USB disconnect, address 3
[  137.511079] btusb_intr_complete: hci0 urb f5574580 failed to resubmit (19)
[  137.511103] btusb_bulk_complete: hci0 urb f5574420 failed to resubmit (19)
[  137.512077] btusb_bulk_complete: hci0 urb f5574e70 failed to resubmit (19)
[  137.512618] btusb_send_frame: hci0 urb f5574e70 submission failed
[  137.513381] __set_isoc_interface: hci0 setting interface failed (19)
[  138.000112] usb 5-4: new high speed USB device using ehci_hcd and address 3
[  138.151670] usb 5-4: configuration #1 chosen from 1 choice
[  138.152237] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
[  138.154675] uvcvideo: Failed to query (135) UVC control 1 (unit 0)
: -32 (exp. 26).
[  138.158357] input: Built-in iSight as /class/input/input12
[  138.440120] hub 5-0:1.0: unable to enumerate USB device on port 7
[  138.900086] usb 1-2: new full speed USB device using uhci_hcd and address 3
[  139.094710] usb 1-2: configuration #1 chosen from 1 choice
[  139.102116] input: Apple Computer Apple Internal Keyboard /
Trackpad as /class/input/input13
[  139.170237] input: USB HID v1.11 Keyboard [Apple Computer Apple
Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[  139.174435] appletouch: Geyser mode initialized.
[  139.174613] input: appletouch as /class/input/input14
[  139.181642] input: Apple Computer Apple Internal Keyboard /
Trackpad as /class/input/input15
[  139.183555] input: USB HID v1.11 Device [Apple Computer Apple
Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[  139.281404] appletouch: 17" model detected.
[  139.460073] usb 3-2: new full speed USB device using uhci_hcd and address 3
[  139.652430] usb 3-2: configuration #1 chosen from 1 choice
[  139.660250] hiddev0: USB HID v1.11 Device [Apple Computer, Inc. IR
Receiver] on usb-0000:00:1d.2-2
[  139.940097] usb 4-1: new full speed USB device using uhci_hcd and address 4
[  140.129395] usb 4-1: configuration #1 chosen from 1 choice
[  140.152842] input: HID 05ac:1000 as /class/input/input16
[  140.170237] input: USB HID v1.11 Keyboard [HID 05ac:1000] on
usb-0000:00:1d.3-1
[  140.185848] input: HID 05ac:1000 as /class/input/input17
[  140.200175] input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
[  140.970076] usb 5-4: USB disconnect, address 3
[  142.610082] usb 5-4: new high speed USB device using ehci_hcd and address 6
[  142.761807] usb 5-4: configuration #1 chosen from 1 choice
[  142.762339] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
[  142.764800] uvcvideo: Failed to query (135) UVC control 1 (unit 0)
: -32 (exp. 26).
[  142.767112] input: Built-in iSight as /class/input/input18

The first time I did this the shell's cursor moves as if I've pressed
"return" five times,
bluetooth stops working for a while then reconnects, typing on my keyboard
was printing double characters(only noticed this the first time doing this,
the second reboot typing seemed to be o.k.).


-- 
Justin P. Mattock
