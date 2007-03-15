Return-Path: <linux-kernel-owner+w=401wt.eu-S933454AbXCOL1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454AbXCOL1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 07:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933465AbXCOL1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 07:27:11 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:56373 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933454AbXCOL1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 07:27:09 -0400
From: CIJOML <cijoml@volny.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kernel OOPSes when changing DVB-T adapter in 2.6.21-rc3
Date: Thu, 15 Mar 2007 12:26:41 +0100
User-Agent: KMail/1.9.5
Cc: linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org
References: <200703091641.54249.cijoml@volny.cz> <20070315000332.72b5f709.akpm@linux-foundation.org>
In-Reply-To: <20070315000332.72b5f709.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703151226.42316.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dne ètvrtek 15 bøezen 2007 09:03 Andrew Morton napsal(a):
> > On Fri, 9 Mar 2007 16:41:53 +0100 CIJOML <cijoml@volny.cz> wrote:
> > Hi,
> >
> > I am trying change Freecom DVB-T dongle with Leadtek DVB-T dongle and I
> > got this OOPS:
> >
> > ----------------------------------
> >
> > usb 2-3: new high speed USB device using ehci_hcd and address 2
> > usb 2-3: configuration #1 chosen from 1 choice
> > dvb-usb: found a 'WideView WT-220U PenType Receiver (Typhoon/Freecom)' in
> > cold state, will try to load a firmware
> > dvb-usb: downloading firmware from file 'dvb-usb-wt220u-02.fw'
> > usbcore: registered new interface driver dvb_usb_dtt200u
> > usb 2-3: USB disconnect, address 2
> > dvb-usb: generic DVB-USB module successfully deinitialized and
> > disconnected. usb 2-3: new high speed USB device using ehci_hcd and
> > address 3
> > usb 2-3: configuration #1 chosen from 1 choice
> > dvb-usb: found a 'WideView WT-220U PenType Receiver (Typhoon/Freecom)' in
> > warm state.
> > dvb-usb: will use the device's hardware PID filter (table count: 15).
> > DVB: registering new adapter (WideView WT-220U PenType Receiver
> > (Typhoon/Freecom)).
> > DVB: registering frontend 0 (WideView USB DVB-T)...
> > input: IR-receiver inside an USB DVB receiver as /class/input/input18
> > dvb-usb: schedule remote query interval to 300 msecs.
> > dvb-usb: WideView WT-220U PenType Receiver (Typhoon/Freecom) successfully
> > initialized and connected.
> > dvb-usb: recv bulk message failed: -110
> > usb 2-3: USB disconnect, address 3
> > BUG: unable to handle kernel paging request at virtual address 00100100
> >  printing eip:
> > c027552d
> > *pde = 36209067
> > *pte = 00000000
> > Oops: 0000 [#1]
> > PREEMPT
> > Modules linked in: dvb_usb_dtt200u dvb_usb dvb_core dvb_pll ppp_deflate
> > zlib_deflate bsd_comp ppp_async ppp_generic slhc bnep rfcomm hidp l2cap
> > lp fuse eeprom hci_usb bluetooth eth1394 usbhid 8250_pci 8250 serial_core
> > nsc_ircc snd_intel8x0m snd_intel8x0 snd_ac97_codCT 24ec irda ide_cd
> > ac97_bus snd_pcm snd_timer snd parport_pc cdrom crc_ccitt ohci1394
> > ieee1394 8139too mii snd_page_alloc parport ohci_hcd i2c_i801 psmouse
> > pcspkr iTCO_wdt iTCO_vendor_support rtc uhci_hcd ehci_hcd
> > CPU:    0
> > EIP:    0060:[<c027552d>]    Not tainted VLICT 24
> > EFLAGS: 00010206   (2.6.21-rc3 #2)
> > EIP is at evdev_disconnect+0x87/0xae
> > eax: 00000000   ebx: 000ffcf0   ecx: c1916000   edx: f616e000
> > esi: e7520dc0   edi: f697d800   ebp: f697dec4   esp: c1917e78
> > ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
> > Process khubd (pid: 130, ti=c1916000 task=c18fea70 task.ti=c1916000)
> > Stack: 00000000 c037b488 e7520df0 c0273983 00000000 e33ba000 f6f7fc18
> > fcc2a420 f1673800 fcc1319f e33ba000 fcc122da fcc29502 f6f7fc18 fcc2a420
> > f1673800 fcc12386 f6f7fc18 fcc2a420 f6f7fc00 c0266522 ffffffed f6f7fc18
> > fcc2a44c Call Trace:
> >  [<c0273983>] input_unregister_device+0x89/0x111
> >  [<fcc1319f>] dvb_usb_remote_exit+0x27/0x32 [dvb_usb]
> >  [<fcc122da>] dvb_usb_exit+0xb/0x87 [dvb_usb]
> >  [<fcc12386>] dvb_usb_device_exit+0x30/0x44 [dvb_usb]
> >  [<c0266522>] usb_unbind_interface+0x3e/0x7c
> >  [<c023e037>] __device_release_driver+0x6e/0x8b
> >  [<c023e421>] device_release_driver+0x1d/0x32
> >  [<c023dadb>] bus_remove_device+0x5b/0x69
>
> Are you able identify a previosu kernel which didn't have this bug? 
> 2.6.20?
>
> Thanks.

Hi,

2.6.20 is fine

Michal

>
> >  [<c023c612>] device_del+0xfa/0x152
> >  [<c0264128>] usb_disable_device+0x5c/0xbb
> >  [<c0260e2c>] usb_disconnect+0x82/0x114
> >  [<c02618e9>] hub_thread+0x375/0xa76
> >  [<c02d3061>] __sched_text_start+0x4a9/0x54c
> >  [<c0115301>] __wake_up_common+0x31/0x4f
> >  [<c012880b>] autoremove_wake_function+0x0/0x35
> >  [<c0261574>] hub_thread+0x0/0xa76
> >  [<c0128750>] kthread+0xa0/0xc8
> >  [<c01286b0>] kthread+0x0/0xc8
> >  [<c0104823>] kernel_thread_helper+0x7/0x10
> >  =======================
> > Code: e8 fc 0e ea ff 8b 5e 4c eb 1b 8d 83 08 04 00 00 b9 06 00 02 00 ba
> > 1d 00 00 00 e8 b5 df ee ff 8b 9b 10 04 00 00 81 eb 10 04 00 00 <8b> 83 10
> > 04 00 00 0f 18 00 90 8d 93 10 04 00 00 8d 46 4c 39 c2
> > EIP: [<c027552d>] evdev_disconnect+0x87/0xae SS:ESP 0068:c1917e78
