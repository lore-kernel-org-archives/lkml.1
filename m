Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040Ab0AURcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0AURcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 12:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204Ab0AURcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 12:32:19 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:23130 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab0AURcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 12:32:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jQlIXCRWHaAk2j8UlCL0ZQdz3mb1rHeupEpNhmvkYCRJIuvnF7j9zPPblpdKq3io+7
         /VSXAdyAEadE0C830x0Eq0ezooHPT4NZR9YTOWy0ELGlbcJSPVErCTMq2ERR+oIaaO3d
         UcQC5npeMoL6iNj+WJZzTFtNbZfAgk5/UpijQ=
MIME-Version: 1.0
In-Reply-To: <20100121162437.GC3628@gandalf>
References: <48239d391001210326y25986d59hd10d390ef9c8ddea@mail.gmail.com>
	 <20100121122839.GB26015@nokia.com>
	 <48239d391001210523l5762775dm8382ad82e7b10e4a@mail.gmail.com>
	 <48239d391001210816n7dd469acr920be41e98129cb4@mail.gmail.com>
	 <20100121162437.GC3628@gandalf>
Date: Thu, 21 Jan 2010 20:32:15 +0300
Message-ID: <48239d391001210932w5523cc4ajc3b5459966ab395e@mail.gmail.com>
Subject: Re: MUSB crash on OMAP3 board with second load of gadget
From: Sergey Lapin <slapinid@gmail.com>
To: me@felipebalbi.com
Cc: felipe.balbi@nokia.com,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> [12034.366119] Code: c03a882b e92d4013 e5903004 e1a04000 (e593c000)
>> [12034.372406] ---[ end trace e93a9fc16bcba40b ]---
>> [12034.377075] Kernel panic - not syncing: Fatal exception in interrupt
>
> this is different from what I've seen. So it's a different problem. Can
> you get some debugging messages out of that ?
>
> enable debugging messages for musb on Kconfig and:
>
> echo 5 > /sys/modules/musb_hdrc/parameters/debug
>
> then:
>
> echo 8 > /proc/sysrq-trigger
>
> then reproduce the problem and get the messages that come before the
> oops.
>
> --
> balbi
>
I've executed the following script, and got the result:
#!/bin/sh

echo 5 > /sys/module/musb_hdrc/parameters/debug
echo 8 > /proc/sysrq-trigger

sleep 1
insmod /tmp/g_mass_storage.ko file=/etc/firmware/disk stall=0
sleep 15
rmmod g_mass_storage
sleep 3
insmod /tmp/g_mass_storage.ko file=/etc/firmware/disk stall=0


value 15 can be increased if that time is not enough to get mass
storage mounted.

[  559.954528] SysRq : Changing Loglevel
[  559.958251] Loglevel set to 8
[  560.986572] usb_gadget_register_driver 1706: registering driver
g_mass_storage
[  560.997863] g_mass_storage gadget: adding config #1 'Linux
File-Backed Storage'/bf00698c
[  561.008605] device: 'lun0': device_add
[  561.013427] PM: Adding info for No Bus:lun0
[  561.086700]  lun0: open backing file: /etc/firmware/disk
[  561.093292] g_mass_storage gadget: Mass Storage Function, version: 2009/09/11
[  561.101135] g_mass_storage gadget: Number of LUNs=1
[  561.107025]  lun0: LUN: removable file: /etc/firmware/disk
[  561.112548] g_mass_storage gadget: I/O thread pid: 1477
[  561.118988] g_mass_storage gadget: adding 'Mass Storage
Function'/c703ca40 to config 'Linux File-Backed Storc
[  561.130950] g_mass_storage gadget: cfg 1/bf00698c speeds: high full
[  561.137817] g_mass_storage gadget:   interface 0 = Mass Storage
Function/c703ca40
[  561.146240] g_mass_storage gadget: Mass Storage Gadget, version: 2009/09/11
[  561.153808] g_mass_storage gadget: g_mass_storage ready
[  561.159393] musb_start 865: <== devctl 98
[  561.218963] musb_interrupt 1516: ** IRQ peripheral usb0001 tx0000 rx0000
[  561.375976] musb_interrupt 1516: ** IRQ peripheral usb0004 tx0000 rx0000
[  561.382720] musb_stage0_irq 385: <== Power=f0, DevCtl=99, int_usb=0x4
[  561.389190] musb_stage0_irq 761: BUS RESET as b_idle
[  561.394195] musb_g_reset 2000: <== B-Device addr=0 driver 'g_mass_storage'
[  561.483642] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  561.490386] musb_g_ep0_irq 643: csr 0001, count 8, myaddr 0, ep0stage setup
[  561.497406] musb_read_fifo 202: RX ep0 fifo fa0ab020 count 8 buf c03f7e96
[  561.504241] musb_read_setup 577: SETUP req80.06 v0100 i0000 l64
[  561.510192] musb_g_ep0_irq 825: handled 0, csr 0001, ep0stage in
[  561.516265] musb_g_ep0_queue 931: queue to ep0 (OUT/RX), length=18
[  561.522491] musb_write_fifo 164: TX ep0 fifo fa0ab020 count 18 buf c72d1600
[  561.529479] musb_g_giveback 142: ep0 done request c712d600,  18/18
[  561.535766] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  561.542510] musb_g_ep0_irq 643: csr 0000, count 0, myaddr 0,
ep0stage out/status
[  561.549957] musb_interrupt 1516: ** IRQ peripheral usb000c tx0000 rx0000
[  561.556701] musb_stage0_irq 385: <== Power=f0, DevCtl=99, int_usb=0xc
[  561.563201] musb_stage0_irq 761: BUS RESET as b_peripheral
[  561.568725] musb_g_reset 2000: <== B-Device addr=0 driver 'g_mass_storage'
[  561.575622] musb_g_disconnect 1944: devctl 99
[  561.650573] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  561.657348] musb_g_ep0_irq 643: csr 0001, count 8, myaddr 0, ep0stage setup
[  561.664337] musb_read_fifo 202: RX ep0 fifo fa0ab020 count 8 buf c03f7e96
[  561.671173] musb_read_setup 577: SETUP req00.05 v0028 i0000 l0
[  561.677062] musb_g_ep0_irq 825: handled 1, csr 0001, ep0stage in/status
[  561.683807] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  561.690551] musb_g_ep0_irq 643: csr 0000, count 0, myaddr 0,
ep0stage in/status
[  561.706573] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  561.713348] musb_g_ep0_irq 643: csr 0001, count 8, myaddr 40, ep0stage idle
[  561.720336] musb_read_fifo 202: RX ep0 fifo fa0ab020 count 8 buf c03f7e96
[  561.727172] musb_read_setup 577: SETUP req80.06 v0100 i0000 l18
[  561.733154] musb_g_ep0_irq 825: handled 0, csr 0001, ep0stage in
[  561.739196] musb_g_ep0_queue 931: queue to ep0 (OUT/RX), length=18
[  561.745422] musb_write_fifo 164: TX ep0 fifo fa0ab020 count 18 buf c72d1600
[  561.752441] musb_g_giveback 142: ep0 done request c712d600,  18/18
[  561.758728] musb_interrupt 1516: ** IRQ peripheral usb000d tx0000 rx0000
[  561.765472] musb_stage0_irq 385: <== Power=f0, DevCtl=99, int_usb=0xd
[  561.771942] musb_stage0_irq 761: BUS RESET as b_peripheral
[  561.777465] musb_g_reset 2000: <== B-Device addr=0 driver 'g_mass_storage'
[  561.784393] musb_g_disconnect 1944: devctl 99
[  561.862762] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  561.869506] musb_g_ep0_irq 643: csr 0009, count 8, myaddr 0, ep0stage setup
[  561.876525] musb_read_fifo 202: RX ep0 fifo fa0ab020 count 8 buf c03f7e96
[  561.883361] musb_read_setup 577: SETUP req80.06 v0100 i0000 l64
[  561.889312] musb_g_ep0_irq 825: handled 0, csr 0009, ep0stage in
[  561.895385] musb_g_ep0_queue 931: queue to ep0 (OUT/RX), length=18
[  561.901611] musb_write_fifo 164: TX ep0 fifo fa0ab020 count 18 buf c72d1600
[  561.908599] musb_g_giveback 142: ep0 done request c712d600,  18/18
[  561.914886] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  561.921630] musb_g_ep0_irq 643: csr 0000, count 0, myaddr 0,
ep0stage out/status
[  561.929138] musb_interrupt 1516: ** IRQ peripheral usb000c tx0000 rx0000
[  561.935882] musb_stage0_irq 385: <== Power=f0, DevCtl=99, int_usb=0xc
[  561.942352] musb_stage0_irq 761: BUS RESET as b_peripheral
[  561.947875] musb_g_reset 2000: <== B-Device addr=0 driver 'g_mass_storage'
[  561.954803] musb_g_disconnect 1944: devctl 99
[  562.026611] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  562.033355] musb_g_ep0_irq 643: csr 0001, count 8, myaddr 0, ep0stage setup
[  562.040374] musb_read_fifo 202: RX ep0 fifo fa0ab020 count 8 buf c03f7e96
[  562.047210] musb_read_setup 577: SETUP req00.05 v0029 i0000 l0
[  562.053070] musb_g_ep0_irq 825: handled 1, csr 0001, ep0stage in/status
[  562.059814] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  562.066558] musb_g_ep0_irq 643: csr 0000, count 0, myaddr 0,
ep0stage in/status
[  562.083038] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  562.089782] musb_g_ep0_irq 643: csr 0011, count 8, myaddr 41, ep0stage idle
[  562.096801] musb_g_ep0_irq 668: SetupEnd came in a wrong ep0stage idle
[  562.103424] musb_interrupt 1516: ** IRQ peripheral usb000d tx0000 rx0000
[  562.110168] musb_stage0_irq 385: <== Power=f0, DevCtl=99, int_usb=0xd
[  562.116668] musb_stage0_irq 761: BUS RESET as b_peripheral
[  562.122192] musb_g_reset 2000: <== B-Device addr=0 driver 'g_mass_storage'
[  562.129089] musb_g_disconnect 1944: devctl 99
[  562.211120] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  562.217864] musb_g_ep0_irq 643: csr 0001, count 8, myaddr 0, ep0stage setup
[  562.224884] musb_read_fifo 202: RX ep0 fifo fa0ab020 count 8 buf c03f7e96
[  562.231719] musb_read_setup 577: SETUP req00.05 v002a i0000 l0
[  562.237579] musb_g_ep0_irq 825: handled 1, csr 0001, ep0stage in/status
[  562.244323] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  562.251068] musb_g_ep0_irq 643: csr 0000, count 0, myaddr 0,
ep0stage in/status
[  562.266601] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  562.273345] musb_g_ep0_irq 643: csr 0001, count 8, myaddr 42, ep0stage idle
[  562.280364] musb_read_fifo 202: RX ep0 fifo fa0ab020 count 8 buf c03f7e96
[  562.287200] musb_read_setup 577: SETUP req80.06 v0100 i0000 l8
[  562.293060] musb_g_ep0_irq 825: handled 0, csr 0001, ep0stage in
[  562.299133] musb_g_ep0_queue 931: queue to ep0 (OUT/RX), length=8
[  562.305267] musb_write_fifo 164: TX ep0 fifo fa0ab020 count 8 buf c72d1600
[  562.312194] musb_g_giveback 142: ep0 done request c712d600,  8/8
[  562.318298] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  562.325042] musb_g_ep0_irq 643: csr 0001, count 8, myaddr 42,
ep0stage out/status
[  562.332580] musb_read_fifo 202: RX ep0 fifo fa0ab020 count 8 buf c03f7dfe
[  562.339416] musb_read_setup 577: SETUP req80.06 v0100 i0000 l18
[  562.345367] musb_g_ep0_irq 825: handled 0, csr 0001, ep0stage in
[  562.351409] musb_g_ep0_queue 931: queue to ep0 (OUT/RX), length=18
[  562.357635] musb_write_fifo 164: TX ep0 fifo fa0ab020 count 18 buf c72d1600
[  562.364654] musb_g_giveback 142: ep0 done request c712d600,  18/18
[  562.370910] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  562.377655] musb_g_ep0_irq 643: csr 0001, count 8, myaddr 42,
ep0stage out/status
[  562.385192] musb_read_fifo 202: RX ep0 fifo fa0ab020 count 8 buf c03f7dfe
[  562.391998] musb_read_setup 577: SETUP req80.06 v0200 i0000 l9
[  562.397888] musb_g_ep0_irq 825: handled 0, csr 0001, ep0stage in
[  562.403930] musb_g_ep0_queue 931: queue to ep0 (OUT/RX), length=9
[  562.410064] musb_write_fifo 164: TX ep0 fifo fa0ab020 count 9 buf c72d1600
[  562.416992] musb_g_giveback 142: ep0 done request c712d600,  9/9
[  562.423065] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  562.429809] musb_g_ep0_irq 643: csr 0001, count 8, myaddr 42,
ep0stage out/status
[  562.437347] musb_read_fifo 202: RX ep0 fifo fa0ab020 count 8 buf c03f7dfe
[  562.444183] musb_read_setup 577: SETUP req80.06 v0200 i0000 l32
[  562.450134] musb_g_ep0_irq 825: handled 0, csr 0001, ep0stage in
[  562.456176] musb_g_ep0_queue 931: queue to ep0 (OUT/RX), length=32
[  562.462402] musb_write_fifo 164: TX ep0 fifo fa0ab020 count 32 buf c72d1600
[  562.469421] musb_g_giveback 142: ep0 done request c712d600,  32/32
[  562.475677] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  562.482421] musb_g_ep0_irq 643: csr 0001, count 8, myaddr 42,
ep0stage out/status
[  562.489959] musb_read_fifo 202: RX ep0 fifo fa0ab020 count 8 buf c03f7dfe
[  562.496765] musb_read_setup 577: SETUP req80.06 v0300 i0000 l255
[  562.502838] musb_g_ep0_irq 825: handled 0, csr 0001, ep0stage in
[  562.508880] musb_g_ep0_queue 931: queue to ep0 (OUT/RX), length=4
[  562.515014] musb_write_fifo 164: TX ep0 fifo fa0ab020 count 4 buf c72d1600
[  562.521911] musb_g_giveback 142: ep0 done request c712d600,  4/4
[  562.528015] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  562.534759] musb_g_ep0_irq 643: csr 0001, count 8, myaddr 42,
ep0stage out/status
[  562.542297] musb_read_fifo 202: RX ep0 fifo fa0ab020 count 8 buf c03f7dfe
[  562.549133] musb_read_setup 577: SETUP req80.06 v0302 i0409 l255
[  562.555175] musb_g_ep0_irq 825: handled 0, csr 0001, ep0stage in
[  562.561218] musb_g_ep0_queue 931: queue to ep0 (OUT/RX), length=40
[  562.567443] musb_write_fifo 164: TX ep0 fifo fa0ab020 count 40 buf c72d1600
[  562.574432] musb_g_giveback 142: ep0 done request c712d600,  40/40
[  562.580718] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  562.587463] musb_g_ep0_irq 643: csr 0001, count 8, myaddr 42,
ep0stage out/status
[  562.595001] musb_read_fifo 202: RX ep0 fifo fa0ab020 count 8 buf c03f7dfe
[  562.601837] musb_read_setup 577: SETUP req80.06 v0301 i0409 l255
[  562.607879] musb_g_ep0_irq 825: handled 0, csr 0001, ep0stage in
[  562.613922] musb_g_ep0_queue 931: queue to ep0 (OUT/RX), length=100
[  562.620239] musb_write_fifo 164: TX ep0 fifo fa0ab020 count 64 buf c72d1600
[  562.627288] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  562.634033] musb_g_ep0_irq 643: csr 0000, count 0, myaddr 42, ep0stage in
[  562.640869] musb_write_fifo 164: TX ep0 fifo fa0ab020 count 36 buf c72d1640
[  562.647888] musb_g_giveback 142: ep0 done request c712d600,  100/100
[  562.654296] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  562.661071] musb_g_ep0_irq 643: csr 0001, count 8, myaddr 42,
ep0stage out/status
[  562.668579] musb_read_fifo 202: RX ep0 fifo fa0ab020 count 8 buf c03f7dfe
[  562.675415] musb_read_setup 577: SETUP req00.09 v0001 i0000 l0
[  562.681304] musb_g_ep0_irq 825: handled 0, csr 0001, ep0stage wait
[  562.687500] g_mass_storage gadget: high speed config #1: Linux
File-Backed Storage
[  562.695159] musb_g_ep0_queue 931: queue to ep0 (OUT/RX), length=0
[  562.701293] musb_g_giveback 142: ep0 done request c712d600,  0/0
[  562.707366] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  562.714111] musb_g_ep0_irq 643: csr 0001, count 8, myaddr 42,
ep0stage in/status
[  562.721557] musb_read_fifo 202: RX ep0 fifo fa0ab020 count 8 buf c03f7dfe
[  562.728393] musb_read_setup 577: SETUP req80.06 v0303 i0409 l255
[  562.734436] musb_g_ep0_irq 825: handled 0, csr 0001, ep0stage in
[  562.740478] musb_g_ep0_queue 931: queue to ep0 (OUT/RX), length=26
[  562.746704] musb_write_fifo 164: TX ep0 fifo fa0ab020 count 26 buf c72d1600
[  562.753723] musb_g_giveback 142: ep0 done request c712d600,  26/26
[  562.759979] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  562.766723] musb_g_ep0_irq 643: csr 0001, count 8, myaddr 42,
ep0stage out/status
[  562.774261] musb_read_fifo 202: RX ep0 fifo fa0ab020 count 8 buf c03f7dfe
[  562.781097] musb_read_setup 577: SETUP req80.06 v0304 i0409 l255
[  562.787139] musb_g_ep0_irq 825: handled 0, csr 0001, ep0stage in
[  562.793182] musb_g_ep0_queue 931: queue to ep0 (OUT/RX), length=26
[  562.799407] musb_write_fifo 164: TX ep0 fifo fa0ab020 count 26 buf c72d1600
[  562.806396] musb_g_giveback 142: ep0 done request c712d600,  26/26
[  562.812652] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  562.819427] musb_g_ep0_irq 643: csr 0000, count 0, myaddr 42,
ep0stage out/status
[  562.827484] g_mass_storage gadget: set interface 0
[  562.835937] musb_hdrc periph: enabled ep1in for bulk IN, dma, maxpacket 512
[  562.855072] musb_hdrc periph: enabled ep1out for bulk OUT, dma, maxpacket 512
[  562.873718] musb_g_ep0_queue 921: ep0 request queued in state 0
[  562.885833] g_mass_storage gadget: error in submission: ep0 --> -22
[  562.892944] musb_gadget_queue 1106: <== to ep1out request=c712d5c0
[  562.899749] musb_ep_restart 1074: <== RX/OUT request c712d5c0 len
512 on hw_ep1
[  567.874847] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  567.881622] musb_g_ep0_irq 643: csr 0001, count 8, myaddr 42, ep0stage idle
[  567.888641] musb_read_fifo 202: RX ep0 fifo fa0ab020 count 8 buf c03f7e96
[  567.895477] musb_read_setup 577: SETUP reqa1.fe v0000 i0000 l1
[  567.901336] musb_g_ep0_irq 825: handled 0, csr 0001, ep0stage in
[  567.907379] g_mass_storage gadget: non-core control reqa1.fe v0000 i0000 l1
[  567.914398] g_mass_storage gadget: get max LUN
[  576.170623] musb_pullup 1488: gadget g_mass_storage D+ pullup off
[  576.176757] musb_stop 942: HDRC disabled
[  576.180725] musb_platform_try_idle 121: UNDEFINED active, deleting timer
[  576.187469] musb_g_giveback 147: ep1out request c712d5c0, 0/512 fault -108
[  576.194396] g_mass_storage gadget: bulk_out_complete --> -108, 0/31
[  576.200714] g_mass_storage gadget: reset config
[  576.205291] usb_gadget_unregister_driver 1850: unregistering driver
g_mass_storage
[  576.213104] g_mass_storage gadget: reset config
[  576.220764] g_mass_storage gadget: reset interface
[  576.226257] musb_gadget_disable 1024: ep1in
[  576.231445] musb_gadget_disable 1024: ep1out
[  576.235778] musb_g_ep0_queue 931: queue to ep0 (OUT/RX), length=512
[  576.242095] musb_write_fifo 164: TX ep0 fifo fa0ab020 count 64 buf c72d1600
[  576.250549] g_mass_storage gadget: unbind function 'Mass Storage
Function'/c703ca40
[  576.258850] g_mass_storage gadget: unbind
[  576.263793]  lun0: close backing file
[  576.267517] device: 'lun0': device_unregister
[  576.272796] PM: Removing info for No Bus:lun0
[  576.278350] musb_platform_try_idle 139: UNDEFINED inactive, for
idle timer for 7 ms
[  579.315490] usb_gadget_register_driver 1706: registering driver
g_mass_storage
[  579.326812] g_mass_storage gadget: adding config #1 'Linux
File-Backed Storage'/bf01698c
[  579.337371] device: 'lun0': device_add
[  579.341979] PM: Adding info for No Bus:lun0
[  579.346679]  lun0: open backing file: /etc/firmware/disk
[  579.353149] g_mass_storage gadget: Mass Storage Function, version: 2009/09/11
[  579.361267] g_mass_storage gadget: Number of LUNs=1
[  579.366790]  lun0: LUN: removable file: /etc/firmware/disk
[  579.373199] g_mass_storage gadget: I/O thread pid: 1484
[  579.378570] g_mass_storage gadget: adding 'Mass Storage
Function'/c703cac0 to config 'Linux File-Backed Storc
[  579.390777] g_mass_storage gadget: cfg 1/bf01698c speeds: high full
[  579.397644] g_mass_storage gadget:   interface 0 = Mass Storage
Function/c703cac0
[  579.406005] g_mass_storage gadget: Mass Storage Gadget, version: 2009/09/11
[  579.413543] g_mass_storage gadget: g_mass_storage ready
[  579.419647] musb_start 865: <== devctl 98
gnome5:~# [  579.479217] musb_interrupt 1516: ** IRQ peripheral
usb0001 tx0000 rx0000
[  579.632781] musb_interrupt 1516: ** IRQ peripheral usb0004 tx0000 rx0000
[  579.639556] musb_stage0_irq 385: <== Power=f0, DevCtl=99, int_usb=0x4
[  579.646026] musb_stage0_irq 761: BUS RESET as b_idle
[  579.651031] musb_g_reset 2000: <== B-Device addr=0 driver 'g_mass_storage'
[  579.743377] musb_interrupt 1516: ** IRQ peripheral usb0008 tx0001 rx0000
[  579.750152] musb_g_ep0_irq 643: csr 0001, count 8, myaddr 0, ep0stage setup
[  579.757171] musb_read_fifo 202: RX ep0 fifo fa0ab020 count 8 buf c03f7e96
[  579.764007] musb_read_setup 577: SETUP req80.06 v0100 i0000 l64
[  579.769958] Unable to handle kernel paging request at virtual
address 6b6b6b6b
[  579.777221] pgd = c0004000
[  579.779937] [6b6b6b6b] *pgd=00000000
[  579.783569] Internal error: Oops: 5 [#1] PREEMPT
[  579.788208] last sysfs file: /sys/module/musb_hdrc/parameters/debug
[  579.794494] Modules linked in: g_mass_storage [last unloaded: g_mass_storage]
[  579.801727] CPU: 0    Not tainted  (2.6.33-rc4-07149-ga29cd26-dirty #12)
[  579.808471] PC is at list_del+0xc/0x90
[  579.812255] LR is at musb_g_giveback+0x20/0x118
[  579.816833] pc : [<c01b70d0>]    lr : [<c021d8ec>]    psr: a00001d3
[  579.816833] sp : c03f7e48  ip : 000184a7  fp : c7832048
[  579.828369] r10: fa0ab000  r9 : fa0ab100  r8 : fa0ab100
[  579.833648] r7 : 00000001  r6 : c7832064  r5 : 00000000  r4 : c712d618
[  579.840209] r3 : 6b6b6b6b  r2 : 00000000  r1 : c712d600  r0 : c712d618
[  579.846771] Flags: NzCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM
Segment kernel
[  579.854309] Control: 10c5387d  Table: 87190019  DAC: 00000017
[  579.860076] Process swapper (pid: 0, stack limit = 0xc03f62e8)
[  579.865936] Stack: (0xc03f7e48 to 0xc03f8000)
[  579.870330] 7e40:                   c712d618 c712d600 c712d600
c021d8ec c7832048 c02f0ea8
[  579.878570] 7e60: c03afdf1 c03f7e74 00000241 00000100 00000000
c7832000 00000001 c021c210
[  579.886810] 7e80: 00000006 00000100 00000000 00000040 c03f6000
06800099 00000100 00000040
[  579.895050] 7ea0: 00000000 00000000 000000f0 c7832000 00000008
00000099 00000000 00000000
[  579.903289] 7ec0: 00000000 c021b388 00000008 00000001 00000000
00000000 c7832000 60000153
[  579.911529] 7ee0: 0000005c c03f6000 0000005c c021b4c0 c78b9d00
c78b9d00 0000005c c0090b80
[  579.919738] 7f00: c78b9d00 c04099cc 0000005c 00000002 00000001
c03f6000 0000001f c0092c44
[  579.927978] 7f20: 0000005c 00000000 00000003 c0030070 ffffffff
fa200000 00000003 c0030ac4
[  579.936218] 7f40: 00077359 00000000 00077359 00000000 c04316c0
00000003 00000003 c04316c0
[  579.944458] 7f60: 80027478 411fc082 0000001f 00000000 00000000
c03f7f88 c00420d0 c00420dc
[  579.952697] 7f80: 60000053 ffffffff 00000000 00077359 386da872
392017bd 386da872 3918a464
[  579.960937] 7fa0: c03fbd50 c03fbe80 c0430cdc c03fbd50 c0476b48
c022d708 c03f6000 c0430cdc
[  579.969146] 7fc0: c0029014 c03f9c10 80027478 c00324dc c045c9c0
c0008934 c000848c 00000000
[  579.977386] 7fe0: 00000000 c0029018 00000000 10c53c7d c0430df0
80008034 00000000 00000000
[  579.985656] [<c01b70d0>] (list_del+0xc/0x90) from [<c021d8ec>]
(musb_g_giveback+0x20/0x118)
[  579.994049] [<c021d8ec>] (musb_g_giveback+0x20/0x118) from
[<c021c210>] (musb_g_ep0_irq+0x32c/0x910)
[  580.003265] [<c021c210>] (musb_g_ep0_irq+0x32c/0x910) from
[<c021b388>] (musb_interrupt+0x2fc/0x3d4)
[  580.012451] [<c021b388>] (musb_interrupt+0x2fc/0x3d4) from
[<c021b4c0>] (generic_interrupt+0x60/0x94)
[  580.021759] [<c021b4c0>] (generic_interrupt+0x60/0x94) from
[<c0090b80>] (handle_IRQ_event+0xa4/0x1e0)
[  580.031127] [<c0090b80>] (handle_IRQ_event+0xa4/0x1e0) from
[<c0092c44>] (handle_level_irq+0xc0/0x150)
[  580.040527] [<c0092c44>] (handle_level_irq+0xc0/0x150) from
[<c0030070>] (asm_do_IRQ+0x70/0x90)
[  580.049285] [<c0030070>] (asm_do_IRQ+0x70/0x90) from [<c0030ac4>]
(__irq_svc+0x44/0xa8)
[  580.057342] Exception stack(0xc03f7f40 to 0xc03f7f88)
[  580.062408] 7f40: 00077359 00000000 00077359 00000000 c04316c0
00000003 00000003 c04316c0
[  580.070648] 7f60: 80027478 411fc082 0000001f 00000000 00000000
c03f7f88 c00420d0 c00420dc
[  580.078887] 7f80: 60000053 ffffffff
[  580.082427] [<c0030ac4>] (__irq_svc+0x44/0xa8) from [<c00420dc>]
(omap3_enter_idle+0x124/0x158)
[  580.091186] [<c00420dc>] (omap3_enter_idle+0x124/0x158) from
[<c022d708>] (cpuidle_idle_call+0xa4/0x180)
[  580.100738] [<c022d708>] (cpuidle_idle_call+0xa4/0x180) from
[<c00324dc>] (cpu_idle+0x48/0x98)
[  580.109436] [<c00324dc>] (cpu_idle+0x48/0x98) from [<c0008934>]
(start_kernel+0x268/0x2c8)
[  580.117767] [<c0008934>] (start_kernel+0x268/0x2c8) from
[<80008034>] (0x80008034)
[  580.125366] Code: c03a876b e92d4013 e5903004 e1a04000 (e593c000)
[  580.131652] ---[ end trace 42b8f4f7e396999c ]---
[  580.136291] Kernel panic - not syncing: Fatal exception in interrupt
