Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbYH3RLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbYH3RLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 13:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYH3RLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 13:11:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57108 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbYH3RLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 13:11:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Date: Sat, 30 Aug 2008 19:14:59 +0200
User-Agent: KMail/1.9.9
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org> <200808301532.57307.rjw@sisk.pl> <86802c440808300905v5056fe0apdc6e328d99dff090@mail.gmail.com>
In-Reply-To: <86802c440808300905v5056fe0apdc6e328d99dff090@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808301915.00381.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 30 of August 2008, Yinghai Lu wrote:
> On Sat, Aug 30, 2008 at 6:32 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday, 30 of August 2008, Yinghai Lu wrote:
> >> On Fri, Aug 29, 2008 at 5:20 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >> > On Fri, Aug 29, 2008 at 5:08 PM, Linus Torvalds
> >> > <torvalds@linux-foundation.org> wrote:
> >> >>
> >> >>
> >> >> On Fri, 29 Aug 2008, Yinghai Lu wrote:
> >> >>> >
> >> >>> > http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/broken.log
> >> >>>
> >> >>> pci 0000:00:00.0: BAR has MMCONFIG at e0000000-ffffffff
> >> >>
> >> >> And that seems utter crap to begin with.
> >> >>
> >> >>        PCI: Using MMCONFIG at e0000000 - efffffff
> >> >>
> >> >> Where did it get that bogus "ffffffff" end address?
> >> >>
> >> >> Anyway, that whole MMCONFIG/BAR thing was totally broken to begin with,
> >> >> and it's reverted now in my tree, so I guess it doesn't much matter.
> >> >
> >> > we need to handle it. otherwise if the BAR go first, and it will stop
> >> > other BARs to be registered...
> >> >
> >> > a quirk should do the work....
> >> >
> >> > Rafael, can you send out lspci -tv and lspci --vvxxx too.
> >>
> >> cat /proc/iomem please.
> >
> > http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/lspci-tv.txt
> > http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/lspci-vvxxx.txt
> > http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/proc_iomem.txt
> >
> 
> 00:00.0 Host bridge: ATI Technologies Inc RD790 Northbridge only dual
> slot PCI-e_GFX and HT3 K8 part
> 	Subsystem: ATI Technologies Inc RD790 Northbridge only dual slot
> PCI-e_GFX and HT3 K8 part
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort+ >SERR- <PERR-
> 	Latency: 0
> 	Region 3: Memory at <ignored> (64-bit, non-prefetchable)
> 	Capabilities: [c4] HyperTransport: Slave or Primary Interface
> 		Command: BaseUnitID=0 UnitCnt=12 MastHost- DefDir- DUL-
> 		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
> IsocEn- LSEn- ExtCTL- 64b-
> 		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
> DwFcInEn- LWO=16bit DwFcOutEn-
> 		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
> IsocEn- LSEn- ExtCTL- 64b-
> 		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit
> DwFcInEn- LWO=8bit DwFcOutEn-
> 		Revision ID: 3.00
> 		Link Frequency 0: [b]
> 		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
> 		Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+
> 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
> 		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
> 		Link Frequency 1: 200MHz
> 		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
> 		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz-
> 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
> 		Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF-
> RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
> 		Prefetchable memory behind bridge Upper: 00-00
> 		Bus Number: 00
> 	Capabilities: [40] HyperTransport: Retry Mode
> 	Capabilities: [54] HyperTransport: UnitID Clumping
> 	Capabilities: [9c] HyperTransport: #1a
> 00: 02 10 56 59 06 00 30 22 00 00 00 06 00 00 00 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 04 00 00 e0
> 
> so bar3 of 00:00.0 has oxe0000000 - 0xffffffff
> and request_resource failed, so
> 	Region 3: Memory at <ignored> (64-bit, non-prefetchable)
> 
> BIOS should hide that region, and because AMD quad core has MMCONFIG
> set in NB MSR already.
> 
> please try to apply attached patches, and boot with "debug initcall_debug"
> 
> applying sequence:
> 
> split_e820_reserve=.patch
> pci_res_print_out.patch
> split_e820_reserve_xx1.patch

The above one doesn't apply.

> insert_resource_debug.patch
> pci_mmconf.patch

Could you please rebase them on top of current -git?

Rafael
