Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbZBWVao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbZBWVao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 16:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbZBWVag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 16:30:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41873 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbZBWVaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 16:30:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Eric Anholt <eric@anholt.net>
Subject: Re: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not ioremap  virtual address for G33 hw status page
Date: Mon, 23 Feb 2009 22:30:28 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lenb@kernel.org" <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       mjg@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       rui.zhang@intel.com
References: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com> <1235419343.4816.27.camel@gaiman>
In-Reply-To: <1235419343.4816.27.camel@gaiman>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902232230.29501.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009, Eric Anholt wrote:
> On Mon, 2009-02-23 at 15:46 +0100, Maciej Rutecki wrote:
> > 2.6.29-rc5 and 2.6.29-rc5-git6 work OK. In 2.6.29-rc6 XWindow (KDM)
> > doesn't start, from dmesg:
> > 
> > [   18.170614] [drm] Initialized drm 1.1.0 20060810
> > [   18.247445] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> > [   18.247455] pci 0000:00:02.0: setting latency timer to 64
> > [   18.249610] mtrr: type mismatch for d0000000,10000000 old:
> > write-back new: write-combining
> > [   18.249621] [drm] MTRR allocation failed
> > [   18.249622] .  Graphics performance may suffer.
> > [   18.249658] pci 0000:00:02.0: irq 27 for MSI/MSI-X
> > [   18.249691] [drm] Initialized i915 1.6.0 20080730 on minor 0
> > [   18.290152] mtrr: type mismatch for d0000000,10000000 old:
> > write-back new: write-combining
> > [   18.567435] set status page addr 0x00043000
> > [   18.567463] [drm:i915_set_status_page] *ERROR* can not ioremap
> > virtual address for G33 hw status page
> 
> The non-GEM G33 HWS support is wrong, and has been more or less broken
> since inception (only now it's failing at startup instead of just being
> slow).  It's doing a mapping of the framebuffer when it should be using
> a cached mapping of the page backing the framebuffer address.
> 
> For a quick fix, converting to ioremap_wc will shut the kernel up and
> get us the old ioremap behavior (whatever the MTRR said, which happens
> to be WC).

This is a serious regression on this particular hardware, though.  We need it
fixed before 2.6.29-final, this way or another.

Thanks,
Rafael
