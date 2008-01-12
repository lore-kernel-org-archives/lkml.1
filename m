Return-Path: <linux-kernel-owner+w=401wt.eu-S1760569AbYALReP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760569AbYALReP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 12:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbYALReA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 12:34:00 -0500
Received: from keil-draco.com ([216.193.185.50]:50183 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbYALRd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 12:33:59 -0500
X-Greylist: delayed 1322 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Jan 2008 12:33:58 EST
From: Daniel Hazelton <dhazelton@enter.net>
To: Harald Dunkel <harald.dunkel@t-online.de>
Subject: Re: 2.6.24-rc7, intel audio: alsa doesn't say a beep
Date: Sat, 12 Jan 2008 12:11:20 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
References: <4782833D.3010600@t-online.de> <s5hprw8g8m7.wl%tiwai@suse.de> <47888B41.70803@t-online.de>
In-Reply-To: <47888B41.70803@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801121211.22280.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 January 2008 04:41:21 Harald Dunkel wrote:
> Takashi Iwai wrote:
> > At Thu, 10 Jan 2008 23:02:53 +0100,
> >
> > Harald Dunkel wrote:
> >> Takashi Iwai wrote:
> >>> Hm...  Just to be sure, try the patch below.  It's a clean up patch
> >>> that I'd like to apply later.
> >>
> >> Sorry, no sound.
> >
> > OK, but I'd like to know whether this makes no regression to rc6.
> > Could you check?
> >
> > Also, what exactly did you test?  "No sound" means that no sound from
> > the headphone / line-out or from the speaker?
> >
> > One interesting test would be to increase the value of udelay() in the
> > reverted patch.  What happens if it's set to 500?
>
> There is no udelay() in the reverted patch. If I replace "udelay(10)"
> by "udelay(500)" in the original rc7, then there is still no sound.
>
> This is like fishing in the dark. We've got a working version. Why not
> keep it?
>
>
> Regards
>
> Harri

Could this have anything to do with the following messages I've seen when 
trying -rc7 ?

[    7.760269] pnpacpi: exceeded the max number of mem resources: 12
[    7.760336] pnpacpi: exceeded the max number of mem resources: 12
[    7.760401] pnpacpi: exceeded the max number of mem resources: 12
[    7.760470] pnpacpi: exceeded the max number of mem resources: 12
[    7.760536] pnpacpi: exceeded the max number of mem resources: 12
[    7.760601] pnpacpi: exceeded the max number of mem resources: 12
[    7.760666] pnpacpi: exceeded the max number of mem resources: 12
[    7.760984] pnp: PnP ACPI: found 12 devices
[    7.761048] ACPI: ACPI bus type pnp unregistered
[    7.761345] PCI: Using ACPI for IRQ routing
[    7.761409] PCI: If a device doesn't work, try "pci=routeirq".  If it 
helps, post a report

And...
 [    7.784472] system 00:05: ioport range 0xc80-0xcff could not be reserved
[    7.784546] system 00:08: iomem range 0xfed00000-0xfed003ff has been 
reserved
[    7.784617] system 00:09: ioport range 0x900-0x97f has been reserved
[    7.784684] system 00:09: ioport range 0x4d0-0x4d1 has been reserved
[    7.784750] system 00:09: ioport range 0x1000-0x1005 has been reserved
[    7.784817] system 00:09: ioport range 0x1008-0x100f has been reserved
[    7.784887] system 00:0a: ioport range 0xf400-0xf4fe has been reserved
[    7.784954] system 00:0a: ioport range 0x1006-0x1007 has been reserved
[    7.785021] system 00:0a: ioport range 0x100a-0x1059 could not be reserved
[    7.785088] system 00:0a: ioport range 0x1060-0x107f has been reserved
[    7.785154] system 00:0a: ioport range 0x1080-0x10bf has been reserved
[    7.785221] system 00:0a: ioport range 0x10c0-0x10df has been reserved
[    7.785288] system 00:0a: ioport range 0x1010-0x102f has been reserved
[    7.785354] system 00:0a: ioport range 0x809-0x809 has been reserved
[    7.785425] system 00:0b: iomem range 0x0-0x9efff could not be reserved
[    7.785492] system 00:0b: iomem range 0x9f000-0x9ffff could not be reserved
[    7.785560] system 00:0b: iomem range 0xc0000-0xcffff has been reserved
[    7.785627] system 00:0b: iomem range 0xe0000-0xfffff has been reserved
[    7.785696] system 00:0b: iomem range 0x100000-0x3f6923ff could not be 
reserved
[    7.785775] system 00:0b: iomem range 0x3f692400-0x3f6fffff could not be 
reserved
[    7.785854] system 00:0b: iomem range 0x3f700000-0x3f7fffff could not be 
reserved
[    7.785932] system 00:0b: iomem range 0x3f700000-0x3fefffff could not be 
reserved
[    7.786011] system 00:0b: iomem range 0xfff00000-0xffffffff could not be 
reserved
[    7.786090] system 00:0b: iomem range 0xffa00000-0xffafffff has been 
reserved
[    7.786157] system 00:0b: iomem range 0xfec00000-0xfec0ffff could not be 
reserved
[    7.786236] system 00:0b: iomem range 0xfee00000-0xfee0ffff could not be 
reserved


That's almost the entirety of the differences between a dmesg from a 
2.6.24-rc7 boot and a 2.6.22 boot.

System itself is a Dell Inspiron 1420n laptop running a 64bit kernel and 
userland - there is a "pop" from the speakers when booting, but no sound at 
all. I'll pull a new tree from GIT, but I'm thinking that the above changes 
are probably related to the move from ACPI motherboard drivers to the PNP 
platform driver. What I don't understand is how, if there are only more mem 
resources than the new PNP platform driver can handle, why there are also 
ioport ranges that could not be reserved.

Additionally, with the same kernel, the iwlwifi driver appears to cause the 
new 802.11 code to crash. This doesn't stop the driver or cause any problems 
with the connection. I've been using the iwlwifi driver with 2.6.22 for a 
while and haven't seen anything like this. 

The message seen is:

[   30.504842] eth1: Initial auth_alg=0
[   30.504848] eth1: authenticate with AP 00:11:50:fa:d4:ba
[   30.506630] eth1: RX authentication from 00:11:50:fa:d4:ba (alg=0 
transaction
=2 status=0)
[   30.506633] eth1: authenticated
[   30.506636] eth1: associate with AP 00:11:50:fa:d4:ba
[   30.509261] eth1: RX AssocResp from 00:11:50:fa:d4:ba (capab=0x411 status=0 
a
id=2)
[   30.509264] eth1: associated
[   30.509269] eth1: switched to short barker preamble 
(BSSID=00:11:50:fa:d4:ba)
[   30.509297] eth1: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 
burst=0
[   30.509300] eth1: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 
burst=0
[   30.509303] eth1: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 burst=30
[   30.509306] eth1: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 burst=15
[   30.512840] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   30.894090] WARNING: at net/mac80211/rx.c:1486 __ieee80211_rx()
[   30.894097] Pid: 0, comm: swapper Not tainted 2.6.24-rc7 #1
[   30.894100]
[   30.894101] Call Trace:
[   30.894104]  <IRQ>  
[<ffffffff881c9e39>] :mac80211:__ieee80211_rx+0xc69/0xd30
[   30.894161]  [<ffffffff881ba87f>] :mac80211:ieee80211_tx_status+0x2af/0x4e0
[   30.894172]  [<ffffffff80458576>] _spin_unlock_irqrestore+0x16/0x40
[   30.894187]  [<ffffffff88209fb1>] :iwl3945:iwl_rx_queue_restock+0xd1/0x160
[   30.894207]  
[<ffffffff881bb53b>] :mac80211:ieee80211_tasklet_handler+0xbb/0x120
[   30.894218]  [<ffffffff802446c8>] tasklet_action+0x48/0xb0
[   30.894224]  [<ffffffff802445d9>] __do_softirq+0x59/0xd0
[   30.894231]  [<ffffffff8020d4fc>] call_softirq+0x1c/0x30
[   30.894236]  [<ffffffff8020ee85>] do_softirq+0x35/0x90
[   30.894241]  [<ffffffff80244505>] irq_exit+0x85/0x90
[   30.894246]  [<ffffffff8020ef60>] do_IRQ+0x80/0x100
[   30.894252]  [<ffffffff8020c851>] ret_from_intr+0x0/0xa
[   30.894254]  <EOI>  
[<ffffffff8801651b>] :processor:acpi_processor_idle+0x2ef/0x4d8
[   30.894279]  
[<ffffffff88016511>] :processor:acpi_processor_idle+0x2e5/0x4d8
[   30.894288]  [<ffffffff8801622c>] :processor:acpi_processor_idle+0x0/0x4d8
[   30.894295]  [<ffffffff8020afc2>] cpu_idle+0x72/0xe0
[   30.894302]  [<ffffffff805bdb6a>] start_kernel+0x27a/0x300
[   30.894309]  [<ffffffff805bd129>] _sinittext+0x129/0x130


DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
