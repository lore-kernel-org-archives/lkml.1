Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbZF1UXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbZF1UXj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 16:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZF1UXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 16:23:30 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:35846 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbZF1UX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 16:23:29 -0400
Date: Sun, 28 Jun 2009 21:23:29 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090628202329.GB1546@sucs.org>
References: <20090313095213.GA14250@silver.sucs.org> <20090320131437.GA30120@hash.localnet> <20090329142432.GA15578@sucs.org> <20090329151401.GA26510@hash.localnet> <20090331083041.GA19657@sucs.org> <20090513214416.GA4492@sucs.org> <20090515040904.GA32357@hash.localnet> <20090518100540.GB21150@sucs.org> <20090522093930.GA15375@sucs.org> <20090526211029.GA2011@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526211029.GA2011@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 10:10:30PM +0100, Sitsofe Wheeler wrote:
> On Fri, May 22, 2009 at 10:39:31AM +0100, Sitsofe Wheeler wrote:
> > On Mon, May 18, 2009 at 11:05:40AM +0100, Sitsofe Wheeler wrote:
> > > On Fri, May 15, 2009 at 12:09:04AM -0400, Bob Copeland wrote:
> > > > 
> > > > This is too ugly to live, but I'd like to know if you can reproduce
> > > > with this patch.  If it still happens, then I guess it's back to
> > 
> > The poison message has not reappeared but this morning there was a
> 
> Yet again, I spoke too soon. This evening the following was in dmesg:
> 
> I'm pretty certain this kernel had your previous patch (although the
> directory that held the kernel has since been cleaned away on the server
> on which it was compiled).

OK I'm still trying to follow this. I forwarded your patch to 2.6.31-rc1
but this time I have kmemleak enabled. I left it streaming radio for the
past few hours and the following appeared in the logs:

Jun 28 17:01:34 eeepc kernel: [  744.083787] kmemleak: unreferenced object 0xf5845770 (size 64):
Jun 28 17:01:34 eeepc kernel: [  744.083795] kmemleak:   comm "swapper", pid 1, jiffies 4294673468
Jun 28 17:01:34 eeepc kernel: [  744.083799] kmemleak:   backtrace:
Jun 28 17:01:34 eeepc kernel: [  744.083811] kmemleak:     [<c01a749d>] kmemleak_alloc+0x11d/0x2a0
Jun 28 17:01:34 eeepc kernel: [  744.083818] kmemleak:     [<c01a4376>] __kmalloc+0x136/0x210
Jun 28 17:01:34 eeepc kernel: [  744.083828] kmemleak:     [<c043f923>] ieee80211_register_hw+0x83/0x4b0
Jun 28 17:01:34 eeepc kernel: [  744.083837] kmemleak:     [<c04630d5>] ath5k_pci_probe+0xee5/0x1100
Jun 28 17:01:34 eeepc kernel: [  744.083849] kmemleak:     [<c0279ab3>] local_pci_probe+0x13/0x20
Jun 28 17:01:34 eeepc kernel: [  744.083856] kmemleak:     [<c027a608>] pci_device_probe+0x68/0x90
Jun 28 17:01:34 eeepc kernel: [  744.083864] kmemleak:     [<c0312670>] driver_probe_device+0x70/0x140
Jun 28 17:01:34 eeepc kernel: [  744.083872] kmemleak:     [<c031293a>] __driver_attach+0x7a/0x80
Jun 28 17:01:34 eeepc kernel: [  744.083881] kmemleak:     [<c0311af9>] bus_for_each_dev+0x49/0x70
Jun 28 17:01:34 eeepc kernel: [  744.083888] kmemleak:     [<c031250e>] driver_attach+0x1e/0x20
Jun 28 17:01:34 eeepc kernel: [  744.083896] kmemleak:     [<c0312188>] bus_add_driver+0xd8/0x290
Jun 28 17:01:34 eeepc kernel: [  744.083904] kmemleak:     [<c0312a6f>] driver_register+0x5f/0x120
Jun 28 17:01:34 eeepc kernel: [  744.083911] kmemleak:     [<c027a443>] __pci_register_driver+0x53/0xc0
Jun 28 17:01:34 eeepc kernel: [  744.083922] kmemleak:     [<c061d82d>] init_ath5k_pci+0x1d/0x40
Jun 28 17:01:34 eeepc kernel: [  744.083929] kmemleak:     [<c0101122>] do_one_initcall+0x32/0x1d0
Jun 28 17:01:34 eeepc kernel: [  744.083939] kmemleak:     [<c05fe8aa>] kernel_init+0xba/0x110
Jun 28 17:01:34 eeepc kernel: [  744.084074] kmemleak: unreferenced object 0xf5845b60 (size 64):
Jun 28 17:01:34 eeepc kernel: [  744.084080] kmemleak:   comm "swapper", pid 1, jiffies 4294683694
Jun 28 17:01:34 eeepc kernel: [  744.084085] kmemleak:   backtrace:
Jun 28 17:01:34 eeepc kernel: [  744.084093] kmemleak:     [<c01a749d>] kmemleak_alloc+0x11d/0x2a0
Jun 28 17:01:34 eeepc kernel: [  744.084100] kmemleak:     [<c01a4376>] __kmalloc+0x136/0x210
Jun 28 17:01:34 eeepc kernel: [  744.084111] kmemleak:     [<c0239880>] __crypto_alloc_tfm+0x40/0x170
Jun 28 17:01:34 eeepc kernel: [  744.084120] kmemleak:     [<c0239cbc>] crypto_alloc_base+0x3c/0x80
Jun 28 17:01:34 eeepc kernel: [  744.084128] kmemleak:     [<c04420ff>] ieee80211_wep_init+0x2f/0x80
Jun 28 17:01:34 eeepc kernel: [  744.084136] kmemleak:     [<c043fa9d>] ieee80211_register_hw+0x1fd/0x4b0
Jun 28 17:01:34 eeepc kernel: [  744.084144] kmemleak:     [<c04630d5>] ath5k_pci_probe+0xee5/0x1100
Jun 28 17:01:34 eeepc kernel: [  744.084153] kmemleak:     [<c0279ab3>] local_pci_probe+0x13/0x20
Jun 28 17:01:34 eeepc kernel: [  744.084160] kmemleak:     [<c027a608>] pci_device_probe+0x68/0x90
Jun 28 17:01:34 eeepc kernel: [  744.084168] kmemleak:     [<c0312670>] driver_probe_device+0x70/0x140
Jun 28 17:01:34 eeepc kernel: [  744.084175] kmemleak:     [<c031293a>] __driver_attach+0x7a/0x80
Jun 28 17:01:34 eeepc kernel: [  744.084184] kmemleak:     [<c0311af9>] bus_for_each_dev+0x49/0x70
Jun 28 17:01:34 eeepc kernel: [  744.084191] kmemleak:     [<c031250e>] driver_attach+0x1e/0x20
Jun 28 17:01:34 eeepc kernel: [  744.084199] kmemleak:     [<c0312188>] bus_add_driver+0xd8/0x290
Jun 28 17:01:34 eeepc kernel: [  744.084207] kmemleak:     [<c0312a6f>] driver_register+0x5f/0x120
Jun 28 17:01:34 eeepc kernel: [  744.084214] kmemleak:     [<c027a443>] __pci_register_driver+0x53/0xc0

There were quite a few leaks before this. I dunno if kmemleak is
spurious or not. As always, any ideas?

-- 
Sitsofe | http://sucs.org/~sits/
