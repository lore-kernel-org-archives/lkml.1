Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbZBXD4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbZBXD4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 22:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZBXD4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 22:56:45 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:46254 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbZBXD4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 22:56:45 -0500
Date: Mon, 23 Feb 2009 19:56:43 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lenb@kernel.org" <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       mjg@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       rui.zhang@intel.com, airlied@redhat.com
Subject: Re: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not ioremap virtual address for G33 hw status page
Message-ID: <20090224035643.GA13066@hexapodia.org>
References: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com> <1235419343.4816.27.camel@gaiman> <200902232230.29501.rjw@sisk.pl> <8db1092f0902231340k7c7d0fd1me49302f2efd03491@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8db1092f0902231340k7c7d0fd1me49302f2efd03491@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 10:40:36PM +0100, Maciej Rutecki wrote:
> 2009/2/23 Rafael J. Wysocki <rjw@sisk.pl>:
> > This is a serious regression on this particular hardware, though.
> > We need it fixed before 2.6.29-final, this way or another.
> 
> root@zlom:/usr/src/git/linux-2.6# git bisect bad
> 6fb88588555a18792a27f483887fe1f2af5f9c9b is first bad commit
> commit 6fb88588555a18792a27f483887fe1f2af5f9c9b
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Mon Feb 23 10:08:21 2009 +1000
> 
>     drm/i915: fix WC mapping in non-GEM i915 code.
> 
>     [airlied - taken from mailing list posting]
> 
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> :040000 040000 94fbea685d2937dbe9f3ef861283724262d8443f
> 451872e14d914a3457adf9c144a705b646d887b4 M      drivers
> 
> Revert this commit helps, and Xwindow works, still (like in previous
> -rc*) I have this message:
> [   16.897361] mtrr: type mismatch for d0000000,10000000 old:
> write-back new: write-combining
> [   16.897369] [drm] MTRR allocation failed
> [   16.897371] .  Graphics performance may suffer.
> [   16.897401] pci 0000:00:02.0: irq 27 for MSI/MSI-X
> [   16.897432] [drm] Initialized i915 1.6.0 20080730 on minor 0
> [   16.931100] mtrr: type mismatch for d0000000,10000000 old:
> write-back new: write-combining
> [   17.397378] set status page addr 0x00043000
> 
> but I don't notice any problems.

Same here (Dell E6400).  Reverting 6fb885 gets X working again; I have
"MTRR allocation failed" in dmesg, but performance seems OK.

Oddly, though, 2.6.29-rc6 works just fine on Dell E4300 which appears to
have the same chipset, same PCI id, etc.  On E4300 with -rc6 I see

[    0.895956] Linux agpgart interface v0.103
[    0.896076] agpgart-intel 0000:00:00.0: Intel Mobile Intel® GM45 Express Chipset
[    0.898082] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    0.901880] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.902083] [drm] Initialized drm 1.1.0 20060810
[    0.902247] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.902357] pci 0000:00:02.0: setting latency timer to 64
[    0.917157] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[    0.917327] [drm] MTRR allocation failed
[    0.917328] .  Graphics performance may suffer.
[    0.917551] pci 0000:00:02.0: irq 27 for MSI/MSI-X
[    0.917564] [drm] Initialized i915 1.6.0 20080730 on minor 0

and X works just fine.

-andy
