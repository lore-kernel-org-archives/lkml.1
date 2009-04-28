Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbZD1W4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbZD1W4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 18:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZD1Wzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 18:55:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:28153 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbZD1Wzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 18:55:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,262,1239001200"; 
   d="scan'208";a="407769928"
Subject: Re: regression IWl3945 - doesn't work with recent 2.6.30-rcX
From: reinette chatre <reinette.chatre@intel.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <c4e36d110904270059m3e43d6ccl18cc2ec6954e5649@mail.gmail.com>
References: <c4e36d110904220333u37304c79k6ab528f92b5f3718@mail.gmail.com>
	 <20090422140107.GD3288@tuxdriver.com>
	 <c4e36d110904241218x209a4b76kf271f7288f1a33da@mail.gmail.com>
	 <c4e36d110904270059m3e43d6ccl18cc2ec6954e5649@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 16:02:03 -0700
Message-Id: <1240959723.1207.104.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-27 at 00:59 -0700, Zdenek Kabelac wrote:
> 2009/4/24 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> > 2009/4/22 John W. Linville <linville@tuxdriver.com>:
> >> On Wed, Apr 22, 2009 at 12:33:03PM +0200, Zdenek Kabelac wrote:
> >>> Hi
> >>>
> >>> I'm checking whether -rcX kernel could be usable on my
> >>> T61/4GB/C2D/x86_64 - but wireless seems to be still out of
> >>> functionality:
> >>> I'm getting lots of weird trace-back messages and it looks like
> >>> iwl3945 is not working at all.
> >>> (attached messages from fresh build of -rc3 - but it never worked even in -rc1)
> >>
> >> Looks like this one did _not_ make -rc3:
> >>
> >> commit df833b1d73680f9f9dc72cbc3215edbbc6ab740d
> >> Author: Reinette Chatre <reinette.chatre@intel.com>
> >> Date:   Tue Apr 21 10:55:48 2009 -0700
> >>
> >>    iwlwifi: DMA fixes
> >>
> >>    A few issues wrt DMA were uncovered when using the driver with swiotlb.
> >> ...
> >>
> >> It is in wireless-2.6 and should be in net-2.6 -- please try one of those kernels.
> >
> >
> > I can confirm that current upstream linux commit
> > 9f5a691253924fd033a58c6b1fed57bb0a4eccf4 works again with iwlwifi.
> > and it already contains the patch you suggested to check.
> >
> 
> 
> While Wifi seems to be working well - I've noticed once attached long
> INFO message during suspend.
> 
> Zdenek
> 
> -----------
> 
> Linux version 2.6.30-rc3-00324-g8087eae (gcc version 4.4.0 20090414
> (Red Hat 4.4.0-0.34) (GCC) ) #55 SMP Fri Apr 24 20:22:26 CEST 2009
> Command line: ro root=/dev/sda5 selinux=0 no_console_suspend
> ...
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> virbr0: no IPv6 routers present
> wlan0: authenticate with AP 00:11:d8:da:65:40
> wlan0: authenticated
> wlan0: associate with AP 00:11:d8:da:65:40
> wlan0: RX AssocResp from 00:11:d8:da:65:40 (capab=0x401 status=0 aid=4)
> wlan0: associated
> ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> wlan0: disassociating by local choice (reason=3)
> audit(1240599276.009:18266): audit_enabled=0 old=1 auid=4294967295
> ses=4294967295 res=1
> wlan0: no IPv6 routers present
> fuse init (API version 7.11)
> wlan0: authenticate with AP 00:11:d8:da:65:40
> wlan0: authenticated
> wlan0: associate with AP 00:11:d8:da:65:40
> wlan0: RX AssocResp from 00:11:d8:da:65:40 (capab=0x401 status=0 aid=4)
> wlan0: associated
> wlan0: no probe response from AP 00:11:d8:da:65:40 - disassociating
> wlan0: deauthenticated (Reason: 7)
> wlan0: authenticate with AP 00:11:d8:da:65:40
> wlan0: authenticate with AP 00:11:d8:da:65:40
> wlan0: authenticate with AP 00:11:d8:da:65:40
> wlan0: authenticated
> wlan0: associate with AP 00:11:d8:da:65:40
> wlan0: RX ReassocResp from 00:11:d8:da:65:40 (capab=0x401 status=0 aid=4)
> wlan0: associated
> 
> ..........
> 
> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.30-rc3-00324-g8087eae #55
> ---------------------------------------------------------
> swapper/0 just changed the state of lock:
>  (&(&priv->scan_check)->timer){+.-...}, at: [<ffffffff80250d90>]
> run_timer_softirq+0x120/0x2e0
> but this lock was taken by another, HARDIRQ-safe lock in the past:
>  (&priv->lock){-.-...}
> 
> and interrupts could create inverse lock ordering between them.
> 
> 

The locking used to protect scan_check is not consistent and is so
because we overusing the priv->lock spinlock. scan_check is used in
three places (iwl_rx_scan_complete_notif, iwl3945_bg_request_scan, and
iwl3945_set_mode). In iwl_rx_scan_complete_notif the access is protected
with priv->lock, while the other two use priv->mutex. The protection in
iwl_rx_scan_complete_notif with priv->lock is not necessary ... but a
significant effort is required to change this. We are starting to move
in this direction. A workaround will be to acquire priv->lock in
iwl3945_bg_request_scan and iwl3945_set_mode, but that will be ugly. 

We can leave this code as is in 2.6.30 because inverse lock ordering is
not possible here as priv->mutex cannot be obtained in
iwl_rx_scan_complete_notif path as it (the mutex) sleeps and this code
path doesn't (it is run in a tasklet).

Reinette


