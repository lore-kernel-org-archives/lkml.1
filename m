Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZHYUMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZHYUMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 16:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbZHYUMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 16:12:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550AbZHYUMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 16:12:31 -0400
Subject: Re: [Bug #13947] Libertas: Association request to the driver failed
From: Dan Williams <dcbw@redhat.com>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, roel kluin <roel.kluin@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Daniel Mack <daniel@caiaq.de>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200908211209.30493.gene.heskett@verizon.net>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
	 <200908201117.45678.gene.heskett@verizon.net>
	 <1250868816.2505.44.camel@localhost.localdomain>
	 <200908211209.30493.gene.heskett@verizon.net>
Content-Type: text/plain
Date: Tue, 25 Aug 2009 15:12:11 -0500
Message-Id: <1251231131.28331.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 12:09 -0400, Gene Heskett wrote:
> On Friday 21 August 2009, Dan Williams wrote:
> >On Thu, 2009-08-20 at 11:17 -0400, Gene Heskett wrote:
> >> On Thursday 20 August 2009, Rafael J. Wysocki wrote:
> >> >On Thursday 20 August 2009, roel kluin wrote:
> >> >> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13947
> >> >> > Subject         : Libertas: Association request to the driver failed
> >> >> > Submitter       : Daniel Mack <daniel@caiaq.de>
> >> >> > Date            : 2009-08-07 19:11 (13 days old)
> >> >> > First-Bad-Commit:
> >> >> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=c
> >> >> >omm it;h=57921c312e8cef72ba35a4cfe870b376da0b1b87 References      :
> >> >> > http://marc.info/?l=linux-kernel&m=124967234311481&w=4 Handled-By
> >> >> >
> >> >> > : Roel Kluin <roel.kluin@gmail.com>
> >> >>
> >> >> I think this should be fixed with patch of Dan Williams found here:
> >> >>
> >> >> http://lkml.org/lkml/2009/8/12/299
> >> >
> >> >Thanks, bug entry updated.
> >>
> >> Has this made it into 2.6.31-rc6?  I have one of these pci cards, and it
> >> is still a no-show even after modprobing the mwl* and libertas modules.
> >
> >You're still looking for the softmac stuff, which the 'libertas' driver
> >doesn't support.  You want to keep track of mwl8k where any new support
> >for softmac Marvell cards would end up.
> >
> >Dan
> 
> I am also loading that mwl8k module, Dan, and that isn't doing any notable 
> good either.  These are NetGears latest pci 802-11bg cards.  And the only pci 
> or pci-e cards widely available (Staples stocks them) unless wallmart might 
> have some (spitui) Belkin cards.  I have not noted them at my local wally's.

Right, because mwl8k supports only the softmac 8687 PCI-E parts right
now.  It doesn't yet support the 8335 or 8310 or 86xx TopDog parts yet.
There hasn't been any movement on those for a while and I haven't gotten
around to abstracting mwl8k's hardware support to handle the older
parts.  But mwl8k is the only driver that could possibly be relevant for
you, since libertas will always be for the fullmac-only parts (8385,
8388, 8686, 8688).

Dan

> modprobing mwl8k, then libertas, gets this in an lsmod:
> Module                  Size  Used by
> libertas              166456  0
> lib80211                5664  1 libertas
> mwl8k                  27740  0
> mac80211              149932  1 mwl8k
> cfg80211               88988  2 mwl8k,mac80211
> 
> removing them and reversing the order of loading:
> Module                  Size  Used by
> mwl8k                  27740  0
> libertas              166456  0
> lib80211                5664  1 libertas
> mac80211              149932  1 mwl8k
> cfg80211               88988  2 mwl8k,mac80211
> 
> really doesn't change anything.  And of those two loads, only one shows in 
> the messages file as:
> 
> Aug 21 11:55:35 coyote kernel: [436464.036670] cfg80211: Using static regulatory domain info
> Aug 21 11:55:35 coyote kernel: [436464.036673] cfg80211: Regulatory domain: US
> Aug 21 11:55:35 coyote kernel: [436464.036675]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> Aug 21 11:55:35 coyote kernel: [436464.036678]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
> Aug 21 11:55:35 coyote kernel: [436464.036681]  (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> Aug 21 11:55:35 coyote kernel: [436464.036684]  (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> Aug 21 11:55:35 coyote kernel: [436464.036686]  (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> Aug 21 11:55:35 coyote kernel: [436464.036689]  (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> Aug 21 11:55:35 coyote kernel: [436464.036692]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
> Aug 21 11:55:35 coyote kernel: [436464.036697] cfg80211: Calling CRDA for country: US
> Aug 21 11:55:59 coyote kernel: [436488.563723] lib80211: common routines for IEEE802.11 drivers
> 
> And no usable interface is created.
> [root@coyote etc]# iwconfig
> lo        no wireless extensions.
> eth0      no wireless extensions.
> eth1      no wireless extensions.
> 
> eth1 is the 2nd MCP55 (nvidia) port on this motherboard, unrelated to anything wireless.
> 
> Fedora 10 system, ASUS M2N SLI Deluxe mobo, slow 2.2ghz phenom 9550 cpu.
> Running 2.6.31-rc6.
> 
> Am I doing anything wrong?
> 

