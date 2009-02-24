Return-Path: <linux-kernel-owner+w=401wt.eu-S1761057AbZBXWzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761057AbZBXWzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbZBXWyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:54:54 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:17794 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbZBXWyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:54:49 -0500
Date: Tue, 24 Feb 2009 14:54:24 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lenb@kernel.org" <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       mjg@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       rui.zhang@intel.com, airlied@redhat.com
Subject: Re: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not ioremap virtual address for G33 hw status page
Message-ID: <20090224225424.GB12600@hexapodia.org>
References: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com> <1235419343.4816.27.camel@gaiman> <200902232230.29501.rjw@sisk.pl> <8db1092f0902231340k7c7d0fd1me49302f2efd03491@mail.gmail.com> <86802c440902231701q1e169a67oa12bd84ac0e4c7aa@mail.gmail.com> <20090224032304.GA26344@hexapodia.org> <86802c440902232150m2b22e3cfg8993193f8867dfbf@mail.gmail.com> <20090224064830.GA12600@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090224064830.GA12600@hexapodia.org>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 10:48:30PM -0800, Andy Isaacson wrote:
> On Mon, Feb 23, 2009 at 09:50:03PM -0800, Yinghai Lu wrote:
> > > reg 0, base: 0GB, range: 32GB, type WB
> > > reg 1, base: 3584MB, range: 512MB, type UC
> > > reg 2, base: 2012MB, range: 4MB, type UC
> > > reg 3, base: 2016MB, range: 32MB, type UC
> > 
> > the BIOS is so sick
> > according to MTRR, it said:
> > [0,2012M) is WB
> > [2048M, 3.5G) is WB too
> > [4G, 32G) is WB
> > 
> > but according to e820: about [0,2g) is RAM...
> > 
> > really not how to workaround in BIOS.
> > 
> > please check if you have some new BIOS?
> 
> That was with bios A11.  There is an A12 available on dell.com, I'll try
> installing it tomorrow...

With BIOS A12 2.6.29-rc6 still fails to initialize Xorg, but I think the
failure is different -- Xorg.0.log says:

(II) intel(0): Initializing HW Cursor
(II) intel(0): [DRI] installation complete
(II) intel(0): xf86BindGARTMemory: bind key 0 at 0x01fff000 (pgoffset 8191)
(II) intel(0): xf86BindGARTMemory: bind key 1 at 0x02000000 (pgoffset 8192)
(II) intel(0): xf86BindGARTMemory: bind key 2 at 0x02640000 (pgoffset 9792)
(II) intel(0): xf86BindGARTMemory: bind key 3 at 0x02c80000 (pgoffset 11392)
(II) intel(0): Fixed memory allocation layout:
(II) intel(0): 0x00000000-0x0001ffff: ring buffer (128 kB)
(II) intel(0): 0x00020000-0x00083fff: compressed frame buffer (400 kB, 0x000000007e020000 physical
)
(II) intel(0): 0x00084000-0x0008dfff: HW cursors (40 kB)
(II) intel(0): 0x0008e000-0x00095fff: logical 3D context (32 kB)
(II) intel(0): 0x00096000-0x000a7fff: exa G965 state buffer (72 kB)
(II) intel(0): 0x000a8000-0x000a8fff: power context (4 kB)
(II) intel(0): 0x00100000-0x0073ffff: front buffer (6400 kB) X tiled
(II) intel(0): 0x00740000-0x019fffff: exa offscreen (19200 kB)
(II) intel(0): 0x01fff000:            end of stolen memory
(II) intel(0): 0x01fff000-0x01ffffff: HW status (4 kB)
(II) intel(0): 0x02000000-0x0263ffff: back buffer (6400 kB) X tiled
(II) intel(0): 0x02640000-0x02c7ffff: depth buffer (6400 kB) Y tiled
(II) intel(0): 0x02c80000-0x04c7ffff: classic textures (32768 kB)
(II) intel(0): 0x10000000:            end of aperture
(WW) intel(0): ESR is 0x00000010, page table error
(WW) intel(0): PGTBL_ER is 0x00100000, CS instruction GTT PTE
(WW) intel(0): Existing errors found in hardware state.
(II) intel(0): using SSC reference clock of 100 MHz
(II) intel(0): Selecting standard 18 bit TMDS pixel format.
(II) intel(0): Output configuration:
(II) intel(0):   Pipe A is off
(II) intel(0):   Display plane A is now disabled and connected to pipe A.
(II) intel(0):   Pipe B is on
(II) intel(0):   Display plane B is now enabled and connected to pipe B.
(II) intel(0):   Output VGA is connected to pipe none
(II) intel(0):   Output LVDS is connected to pipe B
(II) intel(0):   Output HDMI-1 is connected to pipe none
(II) intel(0):   Output HDMI-2 is connected to pipe none
(II) intel(0):   Output TV is connected to pipe none
(EE) intel(0): hw status page initialization Failed
(EE) intel(0): Fail to setup hardware status page.
(II) intel(0): [drm] removed 1 reserved context for kernel
(II) intel(0): [drm] unmapping 8192 bytes of SAREA 0x2efff000 at 0x7f0e1aebd000
(II) intel(0): [drm] Closed DRM master.

dmesg says:

[    0.000000] Linux version 2.6.29-rc6-00000-rc6-dirty (adi@cvp-loaner-01) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu12) ) #17 SMP Tue Feb 24 14:26:22 PST 2009
[    0.000000] Command line: root=/dev/sda1 ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007d04d400 (usable)
[    0.000000]  BIOS-e820: 000000007d04d400 - 000000007d04f400 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007d04f400 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe60000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x7d04d max_arch_pfn = 0x100000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] total RAM coverred: 32220M
[    0.000000]  gran_size: 64K ^Ichunk_size: 64K ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 64K ^Ichunk_size: 128K ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 64K ^Ichunk_size: 256K ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 64K ^Ichunk_size: 512K ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 64K ^Ichunk_size: 1M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 64K ^Ichunk_size: 2M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 64K ^Ichunk_size: 4M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 64K ^Ichunk_size: 8M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 64K ^Ichunk_size: 16M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 64K ^Ichunk_size: 32M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 64K ^Ichunk_size: 64M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 64K ^Ichunk_size: 128M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 64K ^Ichunk_size: 256M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 64K ^Ichunk_size: 512M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 64K ^Ichunk_size: 1G ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 64K ^Ichunk_size: 2G ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 128K ^Ichunk_size: 128K ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 128K ^Ichunk_size: 256K ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 128K ^Ichunk_size: 512K ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 128K ^Ichunk_size: 1M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 128K ^Ichunk_size: 2M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 128K ^Ichunk_size: 4M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 128K ^Ichunk_size: 8M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 128K ^Ichunk_size: 16M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 128K ^Ichunk_size: 32M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 128K ^Ichunk_size: 64M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 128K ^Ichunk_size: 128M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 128K ^Ichunk_size: 256M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 128K ^Ichunk_size: 512M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 128K ^Ichunk_size: 1G ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 128K ^Ichunk_size: 2G ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 256K ^Ichunk_size: 256K ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 256K ^Ichunk_size: 512K ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 256K ^Ichunk_size: 1M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 256K ^Ichunk_size: 2M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 256K ^Ichunk_size: 4M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 256K ^Ichunk_size: 8M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 256K ^Ichunk_size: 16M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 256K ^Ichunk_size: 32M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 256K ^Ichunk_size: 64M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 256K ^Ichunk_size: 128M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 256K ^Ichunk_size: 256M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 256K ^Ichunk_size: 512M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 256K ^Ichunk_size: 1G ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 256K ^Ichunk_size: 2G ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 512K ^Ichunk_size: 512K ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 512K ^Ichunk_size: 1M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 512K ^Ichunk_size: 2M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 512K ^Ichunk_size: 4M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 512K ^Ichunk_size: 8M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 512K ^Ichunk_size: 16M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 512K ^Ichunk_size: 32M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 512K ^Ichunk_size: 64M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 512K ^Ichunk_size: 128M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 512K ^Ichunk_size: 256M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 512K ^Ichunk_size: 512M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 512K ^Ichunk_size: 1G ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 512K ^Ichunk_size: 2G ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 1M ^Ichunk_size: 1M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 1M ^Ichunk_size: 2M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 1M ^Ichunk_size: 4M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 1M ^Ichunk_size: 8M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 1M ^Ichunk_size: 16M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 1M ^Ichunk_size: 32M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 1M ^Ichunk_size: 64M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 1M ^Ichunk_size: 128M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 1M ^Ichunk_size: 256M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 1M ^Ichunk_size: 512M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 1M ^Ichunk_size: 1G ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 1M ^Ichunk_size: 2G ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 2M ^Ichunk_size: 2M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 2M ^Ichunk_size: 4M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 2M ^Ichunk_size: 8M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 2M ^Ichunk_size: 16M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 2M ^Ichunk_size: 32M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 2M ^Ichunk_size: 64M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 2M ^Ichunk_size: 128M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 2M ^Ichunk_size: 256M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 2M ^Ichunk_size: 512M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 2M ^Ichunk_size: 1G ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 2M ^Ichunk_size: 2G ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 4M ^Ichunk_size: 4M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 4M ^Ichunk_size: 8M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 4M ^Ichunk_size: 16M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 4M ^Ichunk_size: 32M ^Inum_reg: 7  ^Ilose cover RAM: 30208M
[    0.000000]  gran_size: 4M ^Ichunk_size: 64M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 4M ^Ichunk_size: 128M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 4M ^Ichunk_size: 256M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 4M ^Ichunk_size: 512M ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 4M ^Ichunk_size: 1G ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 4M ^Ichunk_size: 2G ^Inum_reg: 7  ^Ilose cover RAM: 16G
[    0.000000]  gran_size: 8M ^Ichunk_size: 8M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 8M ^Ichunk_size: 16M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 8M ^Ichunk_size: 32M ^Inum_reg: 7  ^Ilose cover RAM: 30212M
[    0.000000]  gran_size: 8M ^Ichunk_size: 64M ^Inum_reg: 7  ^Ilose cover RAM: 16388M
[    0.000000]  gran_size: 8M ^Ichunk_size: 128M ^Inum_reg: 7  ^Ilose cover RAM: 16388M
[    0.000000]  gran_size: 8M ^Ichunk_size: 256M ^Inum_reg: 7  ^Ilose cover RAM: 16388M
[    0.000000]  gran_size: 8M ^Ichunk_size: 512M ^Inum_reg: 7  ^Ilose cover RAM: 16388M
[    0.000000]  gran_size: 8M ^Ichunk_size: 1G ^Inum_reg: 7  ^Ilose cover RAM: 16388M
[    0.000000]  gran_size: 8M ^Ichunk_size: 2G ^Inum_reg: 7  ^Ilose cover RAM: 16388M
[    0.000000]  gran_size: 16M ^Ichunk_size: 16M ^Inum_reg: 7  ^Ilose cover RAM: 29196M
[    0.000000]  gran_size: 16M ^Ichunk_size: 32M ^Inum_reg: 7  ^Ilose cover RAM: 30220M
[    0.000000]  gran_size: 16M ^Ichunk_size: 64M ^Inum_reg: 7  ^Ilose cover RAM: 16396M
[    0.000000]  gran_size: 16M ^Ichunk_size: 128M ^Inum_reg: 7  ^Ilose cover RAM: 16396M
[    0.000000]  gran_size: 16M ^Ichunk_size: 256M ^Inum_reg: 7  ^Ilose cover RAM: 16396M
[    0.000000]  gran_size: 16M ^Ichunk_size: 512M ^Inum_reg: 7  ^Ilose cover RAM: 16396M
[    0.000000]  gran_size: 16M ^Ichunk_size: 1G ^Inum_reg: 7  ^Ilose cover RAM: 16396M
[    0.000000]  gran_size: 16M ^Ichunk_size: 2G ^Inum_reg: 7  ^Ilose cover RAM: 16396M
[    0.000000]  gran_size: 32M ^Ichunk_size: 32M ^Inum_reg: 7  ^Ilose cover RAM: 28700M
[    0.000000]  gran_size: 32M ^Ichunk_size: 64M ^Inum_reg: 7  ^Ilose cover RAM: 28700M
[    0.000000]  gran_size: 32M ^Ichunk_size: 128M ^Inum_reg: 7  ^Ilose cover RAM: 28M
[    0.000000]  gran_size: 32M ^Ichunk_size: 256M ^Inum_reg: 7  ^Ilose cover RAM: 28M
[    0.000000]  gran_size: 32M ^Ichunk_size: 512M ^Inum_reg: 7  ^Ilose cover RAM: 28M
[    0.000000]  gran_size: 32M ^Ichunk_size: 1G ^Inum_reg: 7  ^Ilose cover RAM: 28M
[    0.000000]  gran_size: 32M ^Ichunk_size: 2G ^Inum_reg: 7  ^Ilose cover RAM: 28M
[    0.000000]  gran_size: 64M ^Ichunk_size: 64M ^Inum_reg: 7  ^Ilose cover RAM: 28700M
[    0.000000]  gran_size: 64M ^Ichunk_size: 128M ^Inum_reg: 7  ^Ilose cover RAM: 28M
[    0.000000]  gran_size: 64M ^Ichunk_size: 256M ^Inum_reg: 7  ^Ilose cover RAM: 28M
[    0.000000]  gran_size: 64M ^Ichunk_size: 512M ^Inum_reg: 7  ^Ilose cover RAM: 28M
[    0.000000]  gran_size: 64M ^Ichunk_size: 1G ^Inum_reg: 7  ^Ilose cover RAM: 28M
[    0.000000]  gran_size: 64M ^Ichunk_size: 2G ^Inum_reg: 7  ^Ilose cover RAM: 28M
[    0.000000]  gran_size: 128M ^Ichunk_size: 128M ^Inum_reg: 7  ^Ilose cover RAM: 24668M
[    0.000000]  gran_size: 128M ^Ichunk_size: 256M ^Inum_reg: 7  ^Ilose cover RAM: 92M
[    0.000000]  gran_size: 128M ^Ichunk_size: 512M ^Inum_reg: 7  ^Ilose cover RAM: 92M
[    0.000000]  gran_size: 128M ^Ichunk_size: 1G ^Inum_reg: 7  ^Ilose cover RAM: 92M
[    0.000000]  gran_size: 128M ^Ichunk_size: 2G ^Inum_reg: 7  ^Ilose cover RAM: 92M
[    0.000000]  gran_size: 256M ^Ichunk_size: 256M ^Inum_reg: 7  ^Ilose cover RAM: 16604M
[    0.000000]  gran_size: 256M ^Ichunk_size: 512M ^Inum_reg: 7  ^Ilose cover RAM: 220M
[    0.000000]  gran_size: 256M ^Ichunk_size: 1G ^Inum_reg: 7  ^Ilose cover RAM: 220M
[    0.000000]  gran_size: 256M ^Ichunk_size: 2G ^Inum_reg: 7  ^Ilose cover RAM: 220M
[    0.000000]  gran_size: 512M ^Ichunk_size: 512M ^Inum_reg: 7  ^Ilose cover RAM: 476M
[    0.000000]  gran_size: 512M ^Ichunk_size: 1G ^Inum_reg: 7  ^Ilose cover RAM: 476M
[    0.000000]  gran_size: 512M ^Ichunk_size: 2G ^Inum_reg: 7  ^Ilose cover RAM: 476M
[    0.000000]  gran_size: 1G ^Ichunk_size: 1G ^Inum_reg: 5  ^Ilose cover RAM: 1500M
[    0.000000]  gran_size: 1G ^Ichunk_size: 2G ^Inum_reg: 5  ^Ilose cover RAM: 1500M
[    0.000000]  gran_size: 2G ^Ichunk_size: 2G ^Inum_reg: 3  ^Ilose cover RAM: 3548M
[    0.000000] mtrr_cleanup: can not find optimal value
[    0.000000] please specify mtrr_gran_size/mtrr_chunk_size
[    0.000000] init_memory_mapping: 0000000000000000-000000007d04d000
[    0.000000] last_map_addr: 7d04d000 end: 7d04d000
[    0.000000] RAMDISK: 37c4b000 - 37fefdc2
[    0.000000] ACPI: RSDP 000FB9C0, 0024 (r2 DELL  )
[    0.000000] ACPI: XSDT 7D051E00, 006C (r1 DELL    M09     27D9020D ASL        61)
[    0.000000] ACPI: FACP 7D051C9C, 00F4 (r4 DELL    M09     27D9020D ASL        61)
[    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in Gpe0Block: 128/64 
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT 7D052400, 6A2B (r2 INT430 SYSFexxx     1001 INTL 20050624)
[    0.000000] ACPI: FACS 7D060C00, 0040
[    0.000000] ACPI: HPET 7D051F00, 0038 (r1 DELL    M09            1 ASL        61)
[    0.000000] ACPI: ____ 7D060400, 0030 (r1 DELL    M09     27D9020D ASL        61)
[    0.000000] ACPI: APIC 7D052000, 0068 (r1 DELL    M09     27D9020D ASL        47)
[    0.000000] ACPI: ASF! 7D051C00, 006A (r32 DELL    M09     27D9020D ASL        61)
[    0.000000] ACPI: MCFG 7D051FC0, 003E (r16 DELL    M09     27D9020D ASL        61)
[    0.000000] ACPI: TCPA 7D052300, 0032 (r1                        0 ASL         0)
[    0.000000] ACPI: SLIC 7D05209C, 0176 (r1 DELL    M09     27D9020D ASL        61)
[    0.000000] ACPI: SSDT 7D05032D, 066C (r1  PmRef    CpuPm     3000 INTL 20050624)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007d04d000
[    0.000000] Bootmem setup node 0 0000000000000000-000000007d04d000
[    0.000000]   NODE_DATA 
[    0.000000]   bootmap 
[    0.000000] (6 early reservations) ==> bootmem 
[    0.000000]   #0 
[    0.000000]   #1 
[    0.000000]   #2 
[    0.000000]   #3 
[    0.000000]   #4 
[    0.000000]   #5 
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007d04d
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: LAPIC (acpi_id
[    0.000000] ACPI: LAPIC (acpi_id
[    0.000000] ACPI: LAPIC_NMI (acpi_id
[    0.000000] ACPI: LAPIC_NMI (acpi_id
[    0.000000] ACPI: IOAPIC (id
[    0.000000] IOAPIC
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:78000000)
[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Allocating 69632 bytes of per cpu data
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 502367
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda1 ro
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2526.754 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console 
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Memory: 2005104k/2048308k available (4740k kernel code, 388k absent, 42816k reserved, 3111k data, 640k init)
[    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 5053.50 BogoMIPS (lpj=10107016)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Initializing.
[    0.004000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004176] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.004926] Mount-cache hash table entries: 256
[    0.005190] Initializing cgroup subsys ns
[    0.005303] Initializing cgroup subsys cpuacct
[    0.005434] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.005586] CPU: L2 cache: 6144K
[    0.005696] 
[    0.005808] CPU 0/0x0 -> Node 0
[    0.005917] CPU: Physical Processor ID: 0
[    0.006027] CPU: Processor Core ID: 0
[    0.006139] using mwait in idle threads.
[    0.008748] ACPI: Core revision 20081204
[    0.020057] Setting APIC routing to flat
[    0.020718] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.061037] CPU0: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 06
[    0.064001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5053.96 BogoMIPS (lpj=10107927)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] 
[    0.004000] CPU 1/0x1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.149663] CPU1: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 06
[    0.150907] checking TSC synchronization 
[    0.152088] Brought up 2 CPUs
[    0.152196] Total of 2 processors activated (10107.47 BogoMIPS).
[    0.152392] khelper used greatest stack depth: 5976 bytes left
[    0.152392] net_namespace: 1784 bytes
[    0.152392] Booting paravirtualized kernel on bare hardware
[    0.156132] Time: 22:39:36  Date: 02/24/09
[    0.156263] NET: Registered protocol family 16
[    0.156389] ACPI: bus type pci registered
[    0.156389] PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
[    0.156389] PCI: MCFG area at f8000000 reserved in E820
[    0.160009] PCI: Using MMCONFIG at f8000000 - fbffffff
[    0.160119] PCI: Using configuration type 1 for base access
[    0.164029] bio: create slab <bio-0> at 0
[    0.164938] ACPI: BIOS _OSI(Linux) query ignored
[    0.224020] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.228208] ACPI: Interpreter enabled
[    0.228316] ACPI: (supports S0 S3 S4 S5)
[    0.228599] ACPI: Using IOAPIC for interrupt routing
[    0.336224] ACPI: EC: GPE = 0x11, I/O: command/status = 0x934, data = 0x930
[    0.336224] ACPI: EC: driver started in interrupt mode
[    0.340018] ACPI: No dock devices found.
[    0.340134] ACPI: PCI Root Bridge 
[    0.340266] DMAR: Forcing write-buffer flush capability
[    0.340382] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.340495] pci 0000:00:19.0: PME# disabled
[    0.340992] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.341105] pci 0000:00:1a.7: PME# disabled
[    0.341321] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.341433] pci 0000:00:1b.0: PME# disabled
[    0.341617] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.341730] pci 0000:00:1c.0: PME# disabled
[    0.341916] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.342028] pci 0000:00:1c.1: PME# disabled
[    0.342215] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.342328] pci 0000:00:1c.2: PME# disabled
[    0.342516] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.342628] pci 0000:00:1c.3: PME# disabled
[    0.343135] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.343248] pci 0000:00:1d.7: PME# disabled
[    0.343677] pci 0000:00:1f.2: PME# supported from D3hot
[    0.344007] pci 0000:00:1f.2: PME# disabled
[    0.344484] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    0.344621] pci 0000:0c:00.0: PME# disabled
[    0.345054] pci 0000:03:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.345167] pci 0000:03:01.0: PME# disabled
[    0.345372] pci 0000:03:01.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.345486] pci 0000:03:01.1: PME# disabled
[    0.345690] pci 0000:03:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.345804] pci 0000:03:01.2: PME# disabled
[    0.345975] pci 0000:00:1e.0: transparent bridge
[    0.360650] ACPI: PCI Interrupt Link 
[    0.360650] ACPI: PCI Interrupt Link 
[    0.360929] ACPI: PCI Interrupt Link 
[    0.361322] ACPI: PCI Interrupt Link 
[    0.361798] ACPI: PCI Interrupt Link 
[    0.362518] ACPI: PCI Interrupt Link 
[    0.364556] ACPI: PCI Interrupt Link 
[    0.365264] ACPI: PCI Interrupt Link 
[    0.366060] SCSI subsystem initialized
[    0.366060] usbcore: registered new interface driver usbfs
[    0.366060] usbcore: registered new interface driver hub
[    0.366060] usbcore: registered new device driver usb
[    0.366060] PCI: Using ACPI for IRQ routing
[    0.380007] Bluetooth: Core ver 2.14
[    0.380122] NET: Registered protocol family 31
[    0.380122] Bluetooth: HCI device and connection manager initialized
[    0.380233] Bluetooth: HCI socket layer initialized
[    0.396026] cfg80211: Using static regulatory domain info
[    0.396124] cfg80211: Regulatory domain: US
[    0.396232] ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.396403] ^I(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.396514] ^I(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.396625] ^I(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.396735] ^I(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.396844] ^I(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.396954] ^I(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.397065] cfg80211: Calling CRDA for country: US
[    0.397178] NetLabel: Initializing
[    0.397178] NetLabel:  domain hash size = 128
[    0.397178] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.397178] NetLabel:  unlabeled traffic allowed by default
[    0.397178] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.397178] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.420008] pnp: PnP ACPI init
[    0.420118] ACPI: bus type pnp registered
[    0.501305] pnp: PnP ACPI: found 14 devices
[    0.501412] ACPI: ACPI bus type pnp unregistered
[    0.501525] system 00:05: ioport range 0xc80-0xcaf has been reserved
[    0.501636] system 00:05: ioport range 0xcc0-0xcff could not be reserved
[    0.501751] system 00:08: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.501864] system 00:0a: ioport range 0xcb0-0xcbb has been reserved
[    0.501973] system 00:0a: iomem range 0xfed40000-0xfed44fff has been reserved
[    0.502088] system 00:0b: ioport range 0x900-0x92f has been reserved
[    0.502199] system 00:0b: ioport range 0x931-0x933 has been reserved
[    0.502310] system 00:0b: ioport range 0x935-0x97f has been reserved
[    0.502421] system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
[    0.502531] system 00:0b: ioport range 0x1000-0x1005 has been reserved
[    0.502642] system 00:0b: ioport range 0x1008-0x100f has been reserved
[    0.502754] system 00:0c: ioport range 0xf400-0xf4fe has been reserved
[    0.502865] system 00:0c: ioport range 0x1006-0x1007 has been reserved
[    0.502976] system 00:0c: ioport range 0x100a-0x1059 could not be reserved
[    0.503087] system 00:0c: ioport range 0x1060-0x107f has been reserved
[    0.503199] system 00:0c: ioport range 0x1080-0x10bf has been reserved
[    0.503310] system 00:0c: ioport range 0x1100-0x111f has been reserved
[    0.503421] system 00:0c: ioport range 0x1010-0x102f has been reserved
[    0.503532] system 00:0c: ioport range 0x809-0x809 has been reserved
[    0.503645] system 00:0d: iomem range 0x0-0x9efff could not be reserved
[    0.503757] system 00:0d: iomem range 0x9f000-0x9ffff could not be reserved
[    0.503868] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
[    0.503980] system 00:0d: iomem range 0xe0000-0xfffff has been reserved
[    0.504098] system 00:0d: iomem range 0x100000-0x7d04d3ff could not be reserved
[    0.504270] system 00:0d: iomem range 0x7d04d400-0x7dafffff could not be reserved
[    0.504443] system 00:0d: iomem range 0x7db00000-0x7dbfffff has been reserved
[    0.504554] system 00:0d: iomem range 0xffe00000-0xffffffff could not be reserved
[    0.504726] system 00:0d: iomem range 0xffa00000-0xffbfffff has been reserved
[    0.504839] system 00:0d: iomem range 0xfec00000-0xfec0ffff has been reserved
[    0.504950] system 00:0d: iomem range 0xfee00000-0xfee0ffff has been reserved
[    0.505063] system 00:0d: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.505174] system 00:0d: iomem range 0xfed45000-0xfed8ffff has been reserved
[    0.505285] system 00:0d: iomem range 0xfeda0000-0xfeda3fff has been reserved
[    0.505397] system 00:0d: iomem range 0xfeda4000-0xfeda4fff has been reserved
[    0.505508] system 00:0d: iomem range 0xfeda5000-0xfeda5fff has been reserved
[    0.505620] system 00:0d: iomem range 0xfeda6000-0xfeda6fff has been reserved
[    0.505731] system 00:0d: iomem range 0xfed1c800-0xfed1cfff has been reserved
[    0.505843] system 00:0d: iomem range 0xfed18000-0xfed1bfff has been reserved
[    0.505955] system 00:0d: iomem range 0xf8000000-0xfbffffff has been reserved
[    0.510997] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0b
[    0.511106] pci 0000:00:1c.0:   IO window: disabled
[    0.511219] pci 0000:00:1c.0:   MEM window: disabled
[    0.511330] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.511444] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:0c
[    0.511554] pci 0000:00:1c.1:   IO window: disabled
[    0.511666] pci 0000:00:1c.1:   MEM window: 0xf6900000-0xf69fffff
[    0.511778] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.511891] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:0d
[    0.512005] pci 0000:00:1c.2:   IO window: disabled
[    0.512117] pci 0000:00:1c.2:   MEM window: disabled
[    0.512227] pci 0000:00:1c.2:   PREFETCH window: disabled
[    0.512341] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:0e
[    0.512451] pci 0000:00:1c.3:   IO window: 0xd000-0xdfff
[    0.512564] pci 0000:00:1c.3:   MEM window: 0xf6600000-0xf68fffff
[    0.512676] pci 0000:00:1c.3:   PREFETCH window: 0x000000f0000000-0x000000f01fffff
[    0.514626] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
[    0.514735] pci 0000:00:1e.0:   IO window: disabled
[    0.514846] pci 0000:00:1e.0:   MEM window: 0xf6500000-0xf65fffff
[    0.514957] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.515079] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.515201] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.515322] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.515443] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.515622] NET: Registered protocol family 2
[    0.560083] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.560760] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.562421] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.562990] TCP: Hash tables configured (established 262144 bind 65536)
[    0.563102] TCP reno registered
[    0.572077] NET: Registered protocol family 1
[    0.572288] checking if image is initramfs... it is
[    0.832962] Freeing initrd memory: 3731k freed
[    0.834470] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.834880] audit: initializing netlink socket (disabled)
[    0.835005] type=2000 audit(1235515176.832:1): initialized
[    0.842439] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.844791] VFS: Disk quotas dquot_6.5.2
[    0.844973] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.845874] msgmni has been set to 3923
[    0.846388] alg: No test for stdrng (krng)
[    0.846588] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.846758] io scheduler noop registered
[    0.846864] io scheduler anticipatory registered
[    0.846970] io scheduler deadline registered
[    0.847178] io scheduler cfq registered (default)
[    0.848687] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.849408] ACPI: SSDT 7D050999, 0281 (r1  PmRef   BspIst     3000 INTL 20050624)
[    0.850043] ACPI: SSDT 7D050DF1, 05C6 (r1  PmRef   BspCst     3001 INTL 20050624)
[    0.850659] ACPI: CPU0 (power states: C1
[    0.850974] processor ACPI_CPU:00: registered as cooling_device0
[    0.851084] ACPI: Processor 
[    0.851699] ACPI: SSDT 7D050C1A, 01D7 (r1  PmRef    ApIst     3000 INTL 20050624)
[    0.852300] ACPI: SSDT 7D0513B7, 008D (r1  PmRef    ApCst     3000 INTL 20050624)
[    0.852962] ACPI: CPU1 (power states: C1
[    0.853271] processor ACPI_CPU:01: registered as cooling_device1
[    0.853381] ACPI: Processor 
[    0.876908] XENFS: not registering filesystem on non-xen platform
[    0.879478] Non-volatile memory driver v1.3
[    0.879585] Linux agpgart interface v0.103
[    0.879704] agpgart-intel 0000:00:00.0: Intel Mobile Intel® GM45 Express Chipset
[    0.881754] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    0.885571] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.885782] 
[    0.885947] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.898806] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[    0.898980] 
[    0.898981] .  Graphics performance may suffer.
[    0.899221] 
[    0.899343] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.156284] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.156783] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.158371] brd: module loaded
[    1.158536] console 
[    1.158642] netconsole: network logging started
[    1.158806] Loading iSCSI transport class v2.0-870.
[    1.159111] Driver 'sd' needs updating - please use bus_type methods
[    1.159251] Driver 'sr' needs updating - please use bus_type methods
[    1.159457] ahci 0000:00:1f.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.159654] ahci: SSS flag set, parallel bus scan disabled
[    1.159794] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[    1.159967] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems 
[    1.160453] scsi0 : ahci
[    1.160686] scsi1 : ahci
[    1.160889] scsi2 : ahci
[    1.161084] scsi3 : ahci
[    1.161285] scsi4 : ahci
[    1.161482] scsi5 : ahci
[    1.162105] ata1: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1c900 irq 29
[    1.162277] ata2: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1c980 irq 29
[    1.162448] ata3: DUMMY
[    1.162551] ata4: DUMMY
[    1.162656] ata5: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1cb00 irq 29
[    1.162828] ata6: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1cb80 irq 29
[    1.644016] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.646368] ata1.00: ATA-8: ST9160414ASG, DEC5, max UDMA/133
[    1.646477] ata1.00: 312581808 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    1.649387] ata1.00: configured for UDMA/133
[    1.664089] scsi 0:0:0:0: Direct-Access     ATA      ST9160414ASG     DEC5 PQ: 0 ANSI: 5
[    1.664400] sd 0:0:0:0: 
[    1.664583] sd 0:0:0:0: 
[    1.664711] sd 0:0:0:0: 
[    1.664927] sd 0:0:0:0: 
[    1.665110] sd 0:0:0:0: 
[    1.665239] sd 0:0:0:0: 
[    1.665413]  sda: sda1 sda2 < sda5 >
[    1.723007] sd 0:0:0:0: 
[    1.723185] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.204015] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.208163] ata2.00: ATAPI: HL-DT-ST DVD+/-RW GSA-U20N, A101, max UDMA/133
[    2.212972] ata2.00: configured for UDMA/133
[    2.230942] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GSA-U20N A101 PQ: 0 ANSI: 5
[    2.242181] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.242355] Uniform CD-ROM driver Revision: 3.20
[    2.242643] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.560014] ata5: SATA link down (SStatus 0 SControl 300)
[    2.896014] ata6: SATA link down (SStatus 0 SControl 300)
[    2.912158] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.912291] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.912414] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.912619] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    2.916698] ehci_hcd 0000:00:1a.7: debug port 1
[    2.916822] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    2.928006] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.928153] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.928264] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.928435] usb usb1: Product: EHCI Host Controller
[    2.928543] usb usb1: Manufacturer: Linux 2.6.29-rc6-00000-rc6-dirty ehci_hcd
[    2.928654] usb usb1: SerialNumber: 0000:00:1a.7
[    2.928821] usb usb1: configuration #1 chosen from 1 choice
[    2.928978] hub 1-0:1.0: USB hub found
[    2.929089] hub 1-0:1.0: 6 ports detected
[    2.929355] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.929477] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.929659] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    2.933728] ehci_hcd 0000:00:1d.7: debug port 1
[    2.933851] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    2.952005] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.952138] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.952249] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.952421] usb usb2: Product: EHCI Host Controller
[    2.952529] usb usb2: Manufacturer: Linux 2.6.29-rc6-00000-rc6-dirty ehci_hcd
[    2.952640] usb usb2: SerialNumber: 0000:00:1d.7
[    2.952804] usb usb2: configuration #1 chosen from 1 choice
[    2.952961] hub 2-0:1.0: USB hub found
[    2.953070] hub 2-0:1.0: 6 ports detected
[    2.953325] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.953470] uhci_hcd: USB Universal Host Controller Interface driver
[    2.953647] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.953766] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.953950] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    2.954126] uhci_hcd 0000:00:1a.0: detected 2 ports
[    2.954257] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f60
[    2.954397] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.954507] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.954679] usb usb3: Product: UHCI Host Controller
[    2.954786] usb usb3: Manufacturer: Linux 2.6.29-rc6-00000-rc6-dirty uhci_hcd
[    2.954898] usb usb3: SerialNumber: 0000:00:1a.0
[    2.955061] usb usb3: configuration #1 chosen from 1 choice
[    2.955221] hub 3-0:1.0: USB hub found
[    2.955332] hub 3-0:1.0: 2 ports detected
[    2.955558] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.955676] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    2.955859] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    2.956039] uhci_hcd 0000:00:1a.1: detected 2 ports
[    2.956176] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f80
[    2.956320] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.958208] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.958380] usb usb4: Product: UHCI Host Controller
[    2.958488] usb usb4: Manufacturer: Linux 2.6.29-rc6-00000-rc6-dirty uhci_hcd
[    2.958598] usb usb4: SerialNumber: 0000:00:1a.1
[    2.958767] usb usb4: configuration #1 chosen from 1 choice
[    2.958923] hub 4-0:1.0: USB hub found
[    2.959032] hub 4-0:1.0: 2 ports detected
[    2.959261] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.959378] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    2.959567] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    2.959743] uhci_hcd 0000:00:1a.2: detected 2 ports
[    2.959873] uhci_hcd 0000:00:1a.2: irq 22, io base 0x00006fa0
[    2.960016] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.960127] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.960299] usb usb5: Product: UHCI Host Controller
[    2.960406] usb usb5: Manufacturer: Linux 2.6.29-rc6-00000-rc6-dirty uhci_hcd
[    2.960517] usb usb5: SerialNumber: 0000:00:1a.2
[    2.960682] usb usb5: configuration #1 chosen from 1 choice
[    2.960839] hub 5-0:1.0: USB hub found
[    2.960948] hub 5-0:1.0: 2 ports detected
[    2.961177] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.961295] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.961491] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    2.961668] uhci_hcd 0000:00:1d.0: detected 2 ports
[    2.961799] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f00
[    2.961939] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.962050] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.962221] usb usb6: Product: UHCI Host Controller
[    2.962329] usb usb6: Manufacturer: Linux 2.6.29-rc6-00000-rc6-dirty uhci_hcd
[    2.962440] usb usb6: SerialNumber: 0000:00:1d.0
[    2.962607] usb usb6: configuration #1 chosen from 1 choice
[    2.962761] hub 6-0:1.0: USB hub found
[    2.962871] hub 6-0:1.0: 2 ports detected
[    2.963101] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.963219] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.963412] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    2.963588] uhci_hcd 0000:00:1d.1: detected 2 ports
[    2.963718] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f20
[    2.963861] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    2.963972] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.964146] usb usb7: Product: UHCI Host Controller
[    2.964254] usb usb7: Manufacturer: Linux 2.6.29-rc6-00000-rc6-dirty uhci_hcd
[    2.964364] usb usb7: SerialNumber: 0000:00:1d.1
[    2.964532] usb usb7: configuration #1 chosen from 1 choice
[    2.964689] hub 7-0:1.0: USB hub found
[    2.964799] hub 7-0:1.0: 2 ports detected
[    2.965054] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.965172] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.965356] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    2.965532] uhci_hcd 0000:00:1d.2: detected 2 ports
[    2.965663] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    2.965805] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    2.965915] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.966086] usb usb8: Product: UHCI Host Controller
[    2.966193] usb usb8: Manufacturer: Linux 2.6.29-rc6-00000-rc6-dirty uhci_hcd
[    2.966302] usb usb8: SerialNumber: 0000:00:1d.2
[    2.966468] usb usb8: configuration #1 chosen from 1 choice
[    2.966622] hub 8-0:1.0: USB hub found
[    2.966732] hub 8-0:1.0: 2 ports detected
[    2.967017] usbcore: registered new interface driver usblp
[    2.967126] Initializing USB Mass Storage driver...
[    2.967284] usbcore: registered new interface driver usb-storage
[    2.967394] USB Mass Storage support registered.
[    2.967550] usbcore: registered new interface driver libusual
[    2.967749] PNP: PS/2 Controller 
[    2.968780] i8042.c: Warning: Keylock active.
[    2.972675] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.972785] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.972937] mice: PS/2 mouse device common for all mice
[    2.973248] rtc_cmos 00:03: RTC can wake from S4
[    2.973406] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.973541] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.973696] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.974128] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    2.974581] cpuidle: using governor ladder
[    2.975149] cpuidle: using governor menu
[    2.975257] No iBFT detected.
[    2.975430] Marking TSC unstable due to TSC halts in idle
[    2.977675] modprobe used greatest stack depth: 5312 bytes left
[    2.978863] usbcore: registered new interface driver hiddev
[    2.979031] usbcore: registered new interface driver usbhid
[    2.979140] usbhid: v2.6:USB HID core driver
[    2.979317] Advanced Linux Sound Architecture Driver Version 1.0.18a.
[    2.981614] modprobe used greatest stack depth: 5184 bytes left
[    2.981864] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    3.092426] input: HDA Intel Mic at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/input/input0
[    3.104247] input: HDA Intel Mic at Ext Right Jack as /devices/pci0000:00/0000:00:1b.0/input/input1
[    3.120247] input: HDA Intel Line Out at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/input/input2
[    3.136258] input: HDA Intel HP Out at Ext Right Jack as /devices/pci0000:00/0000:00:1b.0/input/input3
[    3.153141] ALSA device list:
[    3.153253]   #0: HDA Intel at 0xf6adc000 irq 21
[    3.153405] Netfilter messages via NETLINK v0.30.
[    3.153522] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.153901] ctnetlink v0.93: registering with nfnetlink.
[    3.154506] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.154635] TCP cubic registered
[    3.154740] Initializing XFRM netlink socket
[    3.155197] NET: Registered protocol family 10
[    3.155975] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    3.156142] IPv6 over IPv4 tunneling driver
[    3.156793] NET: Registered protocol family 17
[    3.157172] RPC: Registered udp transport module.
[    3.157292] RPC: Registered tcp transport module.
[    3.157414] lib80211: common routines for IEEE802.11 drivers
[    3.158621] registered taskstats version 1
[    3.158839]   Magic number: 13:246:705
[    3.159044] Freeing unused kernel memory: 640k freed
[    3.159394] Write protecting the kernel read-only data: 7016k
[    3.235861] thermal LNXTHERM:01: registered as thermal_zone0
[    3.241553] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    3.242723] ACPI: Thermal Zone 
[    3.367040] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    3.367153] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    3.367342] e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    3.373701] usb 1-1: New USB device found, idVendor=0424, idProduct=2512
[    3.373814] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.373984] usb 1-1: configuration #1 chosen from 1 choice
[    3.374356] hub 1-1:1.0: USB hub found
[    3.374631] hub 1-1:1.0: 2 ports detected
[    3.466806] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:21:70:d1:b7:92
[    3.466982] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.467119] 0000:00:19.0: eth0: MAC: 6, PHY: 8, PBA No: 1004ff-0ff
[    3.467249] ohci1394 0000:03:01.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.479476] scsi_id used greatest stack depth: 5024 bytes left
[    3.504016] Clocksource tsc unstable (delta = -116313321 ns)
[    3.526073] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=
[    3.604052] usb 1-6: new high speed USB device using ehci_hcd and address 4
[    3.639546] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input4
[    3.686748] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input5
[    3.720236] PM: Starting manual resume from disk
[    3.724174] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input6
[    3.773756] usb 1-6: New USB device found, idVendor=0c45, idProduct=63f8
[    3.773876] usb 1-6: New USB device strings: Mfr=2, Product=1, SerialNumber=0
[    3.775762] usb 1-6: Product: Laptop_Integrated_Webcam_0.3M
[    3.775869] usb 1-6: Manufacturer: CN0TX593724878C2013V
[    3.776040] usb 1-6: configuration #1 chosen from 1 choice
[    3.776997] kjournald starting.  Commit interval 5 seconds
[    3.777147] EXT3-fs: mounted filesystem with ordered data mode.
[    3.788256] udevd used greatest stack depth: 4912 bytes left
[    4.016068] usb 5-1: new full speed USB device using uhci_hcd and address 2
[    4.194053] usb 5-1: New USB device found, idVendor=0a5c, idProduct=5800
[    4.194171] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.194302] usb 5-1: Product: 5880
[    4.194420] usb 5-1: Manufacturer: Broadcom Corp
[    4.194530] usb 5-1: SerialNumber: 0123456789ABCD
[    4.194689] usb 5-1: configuration #0 chosen from 1 choice
[    4.194807] usb 5-1: config 0 descriptor??
[    4.288142] usb 1-1.1: new high speed USB device using ehci_hcd and address 5
[    4.336614] runlevel used greatest stack depth: 3608 bytes left
[    4.381379] usb 1-1.1: New USB device found, idVendor=413c, idProduct=8149
[    4.381504] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.381716] usb 1-1.1: configuration #1 chosen from 1 choice
[    4.469135] usb 1-1.2: new full speed USB device using ehci_hcd and address 6
[    4.578990] usb 1-1.2: New USB device found, idVendor=0a5c, idProduct=4500
[    4.579107] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.579283] usb 1-1.2: Product: BCM2046B1
[    4.579388] usb 1-1.2: Manufacturer: Broadcom
[    4.579535] usb 1-1.2: configuration #1 chosen from 1 choice
[    4.579784] hub 1-1.2:1.0: USB hub found
[    4.579991] hub 1-1.2:1.0: 3 ports detected
[    4.849258] usb 1-1.2.1: new full speed USB device using ehci_hcd and address 7
[    4.943997] usb 1-1.2.1: New USB device found, idVendor=413c, idProduct=8153
[    4.944136] usb 1-1.2.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.944361] usb 1-1.2.1: configuration #1 chosen from 1 choice
[    4.946263] input: HID 413c:8153 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2.1/1-1.2.1:1.0/input/input7
[    4.981091] generic-usb 0003:413C:8153.0001: input,hidraw0: USB HID v1.11 Keyboard 
[    5.052261] usb 1-1.2.2: new full speed USB device using ehci_hcd and address 8
[    5.147647] usb 1-1.2.2: New USB device found, idVendor=413c, idProduct=8154
[    5.147764] usb 1-1.2.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.147976] usb 1-1.2.2: configuration #1 chosen from 1 choice
[    5.151042] input: HID 413c:8154 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2.2/1-1.2.2:1.0/input/input8
[    5.185094] generic-usb 0003:413C:8154.0002: input,hidraw1: USB HID v1.11 Mouse 
[    8.532223] udevd version 124 started
[    8.727507] ACPI: Battery Slot 
[    8.727770] ACPI: AC Adapter 
[    8.728044] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input9
[    8.737390] ACPI: Lid Switch 
[    8.737548] ACPI: Battery Slot 
[    8.737811] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input10
[    8.764113] ACPI: Power Button (CM) 
[    8.764278] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input11
[    8.788116] ACPI: Sleep Button (CM) 
[    8.927279] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27kds
[    8.927452] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[    8.927672] iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    8.927992] iwlagn: Detected Intel Wireless WiFi Link 5100AGN REV=0x54
[    8.952251] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
[    8.955157] iwlagn 0000:0c:00.0: PCI INT A disabled
[    8.955353] wmaster0 (iwlagn): not using net_device_ops yet
[    8.960158] wlan0 (iwlagn): not using net_device_ops yet
[    9.056205] usb 1-1.2.2: usbfs: process 2076 (hid2hci) did not claim interface 0 before use
[    9.264275] usb 1-1.2.3: new full speed USB device using ehci_hcd and address 9
[    9.360272] usb 1-1.2.3: New USB device found, idVendor=413c, idProduct=8152
[    9.360714] usb 1-1.2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    9.361471] usb 1-1.2.3: Product: Dell Wireless 410 Bluetooth + UWB Mini-card
[    9.361918] usb 1-1.2.3: Manufacturer: Dell Computer Corp
[    9.362427] usb 1-1.2.3: configuration #1 chosen from 1 choice
[    9.405019] Bluetooth: Generic Bluetooth USB driver ver 0.4
[    9.405212] usbcore: registered new interface driver btusb
[    9.527569] Adding 5879748k swap on /dev/sda5.  Priority:-1 extents:1 across:5879748k 
[    9.869429] EXT3 FS on sda1, internal journal
[   11.615963] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   12.511151] ppdev: user-space parallel port driver
[   12.988605] console-kit-dae used greatest stack depth: 3520 bytes left
[   14.346385] Bluetooth: L2CAP ver 2.11
[   14.346390] Bluetooth: L2CAP socket layer initialized
[   14.372370] Bluetooth: SCO (Voice Link) ver 0.6
[   14.372376] Bluetooth: SCO socket layer initialized
[   14.392588] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   14.520438] usb 1-1.2.2: usbfs: process 3780 (hid2hci) did not claim interface 0 before use
[   14.554226] Bluetooth: RFCOMM socket layer initialized
[   14.554232] Bluetooth: RFCOMM ver 1.10
[   17.633148] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[   18.762303] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   18.764943] iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   18.765321] iwlagn 0000:0c:00.0: firmware: requesting iwlwifi-5000-1.ucode
[   18.819767] iwlagn loaded firmware version 5.4.1.16
[   18.979292] Registered led device: iwl-phy0:radio
[   18.979346] Registered led device: iwl-phy0:assoc
[   18.979382] Registered led device: iwl-phy0:RX
[   18.979419] Registered led device: iwl-phy0:TX
[   18.990985] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   20.878366] cfg80211: Calling CRDA for country: US

After reverting 6fb88588555a18792a27f483887fe1f2af5f9c9b Xorg works
again, and I get:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.29-rc6-00001-g5cdf70f-dirty (adi@cvp-loaner-01) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu12) ) #16 SMP Mon Feb 23 21:54:21 PST 2009
[    0.000000] Command line: root=/dev/sda1 ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007d04d400 (usable)
[    0.000000]  BIOS-e820: 000000007d04d400 - 000000007d04f400 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007d04f400 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe60000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x7d04d max_arch_pfn = 0x100000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 32GB, type WB
[    0.000000] reg 1, base: 3584MB, range: 512MB, type UC
[    0.000000] reg 2, base: 2012MB, range: 4MB, type UC
[    0.000000] reg 3, base: 2016MB, range: 32MB, type UC
[    0.000000] total RAM coverred: 32220M
[    0.000000]  gran_size: 64K 	chunk_size: 64K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 64K 	chunk_size: 128K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 64K 	chunk_size: 256K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 64K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 64K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 64K 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 64K 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 64K 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 64K 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 64K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 64K 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 64K 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 64K 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 64K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 64K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 128K 	chunk_size: 128K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 128K 	chunk_size: 256K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 128K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 128K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 128K 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 128K 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 128K 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 128K 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 128K 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 128K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 128K 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 128K 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 128K 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 128K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 128K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 256K 	chunk_size: 256K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 256K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 256K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 256K 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 256K 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 256K 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 256K 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 256K 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 256K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 256K 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 256K 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 256K 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 256K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 256K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 512K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 512K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 512K 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 512K 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 512K 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 512K 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 512K 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 512K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 512K 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 512K 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 512K 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 512K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 512K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 1M 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 1M 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 1M 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 1M 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 1M 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 1M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 1M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 1M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 1M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 1M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 1M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 1M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 2M 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 2M 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 2M 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 2M 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 2M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 2M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 2M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 2M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 2M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 2M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 2M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 4M 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 4M 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 4M 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 4M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 30208M
[    0.000000]  gran_size: 4M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 4M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 4M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 4M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 4M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 4M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 16G
[    0.000000]  gran_size: 8M 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 8M 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 8M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 30212M
[    0.000000]  gran_size: 8M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 16388M
[    0.000000]  gran_size: 8M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 16388M
[    0.000000]  gran_size: 8M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16388M
[    0.000000]  gran_size: 8M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 16388M
[    0.000000]  gran_size: 8M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 16388M
[    0.000000]  gran_size: 8M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 16388M
[    0.000000]  gran_size: 16M 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 29196M
[    0.000000]  gran_size: 16M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 30220M
[    0.000000]  gran_size: 16M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 16396M
[    0.000000]  gran_size: 16M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 16396M
[    0.000000]  gran_size: 16M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16396M
[    0.000000]  gran_size: 16M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 16396M
[    0.000000]  gran_size: 16M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 16396M
[    0.000000]  gran_size: 16M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 16396M
[    0.000000]  gran_size: 32M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 28700M
[    0.000000]  gran_size: 32M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 28700M
[    0.000000]  gran_size: 32M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 32M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 32M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 32M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 32M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 64M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 28700M
[    0.000000]  gran_size: 64M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 64M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 64M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 64M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 64M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 28M
[    0.000000]  gran_size: 128M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 24668M
[    0.000000]  gran_size: 128M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 92M
[    0.000000]  gran_size: 128M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 92M
[    0.000000]  gran_size: 128M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 92M
[    0.000000]  gran_size: 128M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 92M
[    0.000000]  gran_size: 256M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 16604M
[    0.000000]  gran_size: 256M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 220M
[    0.000000]  gran_size: 256M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 220M
[    0.000000]  gran_size: 256M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 220M
[    0.000000]  gran_size: 512M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 476M
[    0.000000]  gran_size: 512M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 476M
[    0.000000]  gran_size: 512M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 476M
[    0.000000]  gran_size: 1G 	chunk_size: 1G 	num_reg: 5  	lose cover RAM: 1500M
[    0.000000]  gran_size: 1G 	chunk_size: 2G 	num_reg: 5  	lose cover RAM: 1500M
[    0.000000]  gran_size: 2G 	chunk_size: 2G 	num_reg: 3  	lose cover RAM: 3548M
[    0.000000] mtrr_cleanup: can not find optimal value
[    0.000000] please specify mtrr_gran_size/mtrr_chunk_size
[    0.000000] init_memory_mapping: 0000000000000000-000000007d04d000
[    0.000000]  0000000000 - 007d000000 page 2M
[    0.000000]  007d000000 - 007d04d000 page 4k
[    0.000000] kernel direct mapping tables up to 7d04d000 @ 8000-c000
[    0.000000] last_map_addr: 7d04d000 end: 7d04d000
[    0.000000] RAMDISK: 37c4b000 - 37fefeb5
[    0.000000] ACPI: RSDP 000FB9C0, 0024 (r2 DELL  )
[    0.000000] ACPI: XSDT 7D051E00, 006C (r1 DELL    M09     27D9020D ASL        61)
[    0.000000] ACPI: FACP 7D051C9C, 00F4 (r4 DELL    M09     27D9020D ASL        61)
[    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in Gpe0Block: 128/64 [20081204]
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT 7D052400, 6A2B (r2 INT430 SYSFexxx     1001 INTL 20050624)
[    0.000000] ACPI: FACS 7D060C00, 0040
[    0.000000] ACPI: HPET 7D051F00, 0038 (r1 DELL    M09            1 ASL        61)
[    0.000000] ACPI: ____ 7D060400, 0030 (r1 DELL    M09     27D9020D ASL        61)
[    0.000000] ACPI: APIC 7D052000, 0068 (r1 DELL    M09     27D9020D ASL        47)
[    0.000000] ACPI: ASF! 7D051C00, 006A (r32 DELL    M09     27D9020D ASL        61)
[    0.000000] ACPI: MCFG 7D051FC0, 003E (r16 DELL    M09     27D9020D ASL        61)
[    0.000000] ACPI: TCPA 7D052300, 0032 (r1                        0 ASL         0)
[    0.000000] ACPI: SLIC 7D05209C, 0176 (r1 DELL    M09     27D9020D ASL        61)
[    0.000000] ACPI: SSDT 7D05032D, 066C (r1  PmRef    CpuPm     3000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007d04d000
[    0.000000] Bootmem setup node 0 0000000000000000-000000007d04d000
[    0.000000]   NODE_DATA [0000000000001000 - 0000000000005fff]
[    0.000000]   bootmap [000000000000a000 -  0000000000019a0f] pages 10
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 007d04d000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000bcdcd8]    TEXT DATA BSS ==> [0000200000 - 0000bcdcd8]
[    0.000000]   #3 [0037c4b000 - 0037fefeb5]          RAMDISK ==> [0037c4b000 - 0037fefeb5]
[    0.000000]   #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff880001200000-ffff880002dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007d04d
[    0.000000] On node 0 totalpages: 511980
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2611 pages reserved
[    0.000000]   DMA zone: 1332 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6946 pages used for memmap
[    0.000000]   DMA32 zone: 501035 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:78000000)
[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Allocating 69632 bytes of per cpu data
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 502367
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda1 ro
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2526.679 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Calgary: detecting Calgary via BIOS EBDA area
[    0.004000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] Memory: 2005104k/2048308k available (4740k kernel code, 388k absent, 42816k reserved, 3111k data, 640k init)
[    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 5053.35 BogoMIPS (lpj=10106716)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Initializing.
[    0.004000] SELinux:  Starting in permissive mode
[    0.004000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004174] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.004925] Mount-cache hash table entries: 256
[    0.005188] Initializing cgroup subsys ns
[    0.005303] Initializing cgroup subsys cpuacct
[    0.005433] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.005584] CPU: L2 cache: 6144K
[    0.005695] [ds] using Core 2/Atom configuration
[    0.005808] CPU 0/0x0 -> Node 0
[    0.005918] CPU: Physical Processor ID: 0
[    0.006029] CPU: Processor Core ID: 0
[    0.006142] using mwait in idle threads.
[    0.008751] ACPI: Core revision 20081204
[    0.020056] Setting APIC routing to flat
[    0.020721] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.061049] CPU0: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 06
[    0.064001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5053.96 BogoMIPS (lpj=10107933)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU 1/0x1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.149665] CPU1: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 06
[    0.150908] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.152092] Brought up 2 CPUs
[    0.152200] Total of 2 processors activated (10107.32 BogoMIPS).
[    0.152393] khelper used greatest stack depth: 5976 bytes left
[    0.152393] net_namespace: 1784 bytes
[    0.152393] Booting paravirtualized kernel on bare hardware
[    0.156131] Time: 22:40:54  Date: 02/24/09
[    0.156265] NET: Registered protocol family 16
[    0.156389] ACPI: bus type pci registered
[    0.156389] PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
[    0.156389] PCI: MCFG area at f8000000 reserved in E820
[    0.159051] PCI: Using MMCONFIG at f8000000 - fbffffff
[    0.160002] PCI: Using configuration type 1 for base access
[    0.164032] bio: create slab <bio-0> at 0
[    0.164698] ACPI: EC: Look up EC in DSDT
[    0.164894] ACPI: BIOS _OSI(Linux) query ignored
[    0.224019] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.226160] ACPI: Interpreter enabled
[    0.226160] ACPI: (supports S0 S3 S4 S5)
[    0.226160] ACPI: Using IOAPIC for interrupt routing
[    0.340116] ACPI: EC: GPE = 0x11, I/O: command/status = 0x934, data = 0x930
[    0.340170] ACPI: EC: driver started in interrupt mode
[    0.341433] ACPI: No dock devices found.
[    0.341548] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.344030] DMAR: Forcing write-buffer flush capability
[    0.344166] pci 0000:00:02.0: reg 10 64bit mmio: [0xf6c00000-0xf6ffffff]
[    0.344172] pci 0000:00:02.0: reg 18 64bit mmio: [0xe0000000-0xefffffff]
[    0.344175] pci 0000:00:02.0: reg 20 io port: [0xef98-0xef9f]
[    0.344207] pci 0000:00:02.1: reg 10 64bit mmio: [0xf6b00000-0xf6bfffff]
[    0.344311] pci 0000:00:19.0: reg 10 32bit mmio: [0xf6ae0000-0xf6afffff]
[    0.344319] pci 0000:00:19.0: reg 14 32bit mmio: [0xf6adb000-0xf6adbfff]
[    0.344326] pci 0000:00:19.0: reg 18 io port: [0xefe0-0xefff]
[    0.344380] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.344492] pci 0000:00:19.0: PME# disabled
[    0.344660] pci 0000:00:1a.0: reg 20 io port: [0x6f60-0x6f7f]
[    0.344748] pci 0000:00:1a.1: reg 20 io port: [0x6f80-0x6f9f]
[    0.344836] pci 0000:00:1a.2: reg 20 io port: [0x6fa0-0x6fbf]
[    0.344924] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfed1c400-0xfed1c7ff]
[    0.344989] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.345102] pci 0000:00:1a.7: PME# disabled
[    0.345259] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf6adc000-0xf6adffff]
[    0.345259] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.345259] pci 0000:00:1b.0: PME# disabled
[    0.345259] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.345259] pci 0000:00:1c.0: PME# disabled
[    0.345259] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.345259] pci 0000:00:1c.1: PME# disabled
[    0.345259] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.345259] pci 0000:00:1c.2: PME# disabled
[    0.345259] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.345354] pci 0000:00:1c.3: PME# disabled
[    0.345530] pci 0000:00:1d.0: reg 20 io port: [0x6f00-0x6f1f]
[    0.345618] pci 0000:00:1d.1: reg 20 io port: [0x6f20-0x6f3f]
[    0.345706] pci 0000:00:1d.2: reg 20 io port: [0x6f40-0x6f5f]
[    0.345794] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfed1c000-0xfed1c3ff]
[    0.345859] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.345971] pci 0000:00:1d.7: PME# disabled
[    0.346316] pci 0000:00:1f.2: reg 10 io port: [0x6e70-0x6e77]
[    0.346323] pci 0000:00:1f.2: reg 14 io port: [0x6e78-0x6e7b]
[    0.346330] pci 0000:00:1f.2: reg 18 io port: [0x6e80-0x6e87]
[    0.346337] pci 0000:00:1f.2: reg 1c io port: [0x6e88-0x6e8b]
[    0.346344] pci 0000:00:1f.2: reg 20 io port: [0x6ea0-0x6ebf]
[    0.346351] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfed1c800-0xfed1cfff]
[    0.346396] pci 0000:00:1f.2: PME# supported from D3hot
[    0.346506] pci 0000:00:1f.2: PME# disabled
[    0.346650] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf6adaf00-0xf6adafff]
[    0.346668] pci 0000:00:1f.3: reg 20 io port: [0x1100-0x111f]
[    0.346840] pci 0000:0c:00.0: reg 10 64bit mmio: [0xf69fe000-0xf69fffff]
[    0.346954] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    0.347069] pci 0000:0c:00.0: PME# disabled
[    0.347249] pci 0000:00:1c.1: bridge 32bit mmio: [0xf6900000-0xf69fffff]
[    0.347368] pci 0000:00:1c.3: bridge io port: [0xd000-0xdfff]
[    0.347373] pci 0000:00:1c.3: bridge 32bit mmio: [0xf6600000-0xf68fffff]
[    0.347380] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf0000000-0xf01fffff]
[    0.347421] pci 0000:03:01.0: reg 10 32bit mmio: [0xf65ff800-0xf65fffff]
[    0.347477] pci 0000:03:01.0: supports D1 D2
[    0.347479] pci 0000:03:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.347592] pci 0000:03:01.0: PME# disabled
[    0.347737] pci 0000:03:01.1: reg 10 32bit mmio: [0xf65ff600-0xf65ff6ff]
[    0.347794] pci 0000:03:01.1: supports D1 D2
[    0.347795] pci 0000:03:01.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.347908] pci 0000:03:01.1: PME# disabled
[    0.348042] pci 0000:03:01.2: reg 10 32bit mmio: [0xf65ff700-0xf65ff7ff]
[    0.348099] pci 0000:03:01.2: supports D1 D2
[    0.348101] pci 0000:03:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.348213] pci 0000:03:01.2: PME# disabled
[    0.348384] pci 0000:00:1e.0: transparent bridge
[    0.348497] pci 0000:00:1e.0: bridge 32bit mmio: [0xf6500000-0xf65fffff]
[    0.348537] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.348837] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.348948] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.349017] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.349087] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.349155] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.364650] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 *11)
[    0.364650] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *3
[    0.364650] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 *11)
[    0.364956] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 *10 11)
[    0.365431] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.366150] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.366870] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.367577] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.372006] SCSI subsystem initialized
[    0.372111] libata version 3.00 loaded.
[    0.372111] usbcore: registered new interface driver usbfs
[    0.372137] usbcore: registered new interface driver hub
[    0.372147] usbcore: registered new device driver usb
[    0.372147] PCI: Using ACPI for IRQ routing
[    0.384026] Bluetooth: Core ver 2.14
[    0.384141] NET: Registered protocol family 31
[    0.384141] Bluetooth: HCI device and connection manager initialized
[    0.384233] Bluetooth: HCI socket layer initialized
[    0.400035] cfg80211: Using static regulatory domain info
[    0.400123] cfg80211: Regulatory domain: US
[    0.400231] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.400402] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.400513] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.400624] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.400735] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.400845] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.400955] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.401067] cfg80211: Calling CRDA for country: US
[    0.404015] NetLabel: Initializing
[    0.404121] NetLabel:  domain hash size = 128
[    0.404228] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.404345] NetLabel:  unlabeled traffic allowed by default
[    0.404461] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.404461] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.427151] pnp: PnP ACPI init
[    0.427262] ACPI: bus type pnp registered
[    0.503159] Switched to high resolution mode on CPU 1
[    0.504013] Switched to high resolution mode on CPU 0
[    0.510829] pnp: PnP ACPI: found 14 devices
[    0.510936] ACPI: ACPI bus type pnp unregistered
[    0.511050] system 00:05: ioport range 0xc80-0xcaf has been reserved
[    0.511162] system 00:05: ioport range 0xcc0-0xcff could not be reserved
[    0.511276] system 00:08: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.511390] system 00:0a: ioport range 0xcb0-0xcbb has been reserved
[    0.511502] system 00:0a: iomem range 0xfed40000-0xfed44fff has been reserved
[    0.511616] system 00:0b: ioport range 0x900-0x92f has been reserved
[    0.511726] system 00:0b: ioport range 0x931-0x933 has been reserved
[    0.511836] system 00:0b: ioport range 0x935-0x97f has been reserved
[    0.511947] system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
[    0.512058] system 00:0b: ioport range 0x1000-0x1005 has been reserved
[    0.512168] system 00:0b: ioport range 0x1008-0x100f has been reserved
[    0.512282] system 00:0c: ioport range 0xf400-0xf4fe has been reserved
[    0.512392] system 00:0c: ioport range 0x1006-0x1007 has been reserved
[    0.512503] system 00:0c: ioport range 0x100a-0x1059 could not be reserved
[    0.512614] system 00:0c: ioport range 0x1060-0x107f has been reserved
[    0.512725] system 00:0c: ioport range 0x1080-0x10bf has been reserved
[    0.512835] system 00:0c: ioport range 0x1100-0x111f has been reserved
[    0.512946] system 00:0c: ioport range 0x1010-0x102f has been reserved
[    0.513061] system 00:0c: ioport range 0x809-0x809 has been reserved
[    0.513174] system 00:0d: iomem range 0x0-0x9efff could not be reserved
[    0.513285] system 00:0d: iomem range 0x9f000-0x9ffff could not be reserved
[    0.513396] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
[    0.513507] system 00:0d: iomem range 0xe0000-0xfffff has been reserved
[    0.513619] system 00:0d: iomem range 0x100000-0x7d04d3ff could not be reserved
[    0.513791] system 00:0d: iomem range 0x7d04d400-0x7dafffff could not be reserved
[    0.513963] system 00:0d: iomem range 0x7db00000-0x7dbfffff has been reserved
[    0.514075] system 00:0d: iomem range 0xffe00000-0xffffffff could not be reserved
[    0.514248] system 00:0d: iomem range 0xffa00000-0xffbfffff has been reserved
[    0.514359] system 00:0d: iomem range 0xfec00000-0xfec0ffff has been reserved
[    0.514471] system 00:0d: iomem range 0xfee00000-0xfee0ffff has been reserved
[    0.514582] system 00:0d: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.514694] system 00:0d: iomem range 0xfed45000-0xfed8ffff has been reserved
[    0.514806] system 00:0d: iomem range 0xfeda0000-0xfeda3fff has been reserved
[    0.514917] system 00:0d: iomem range 0xfeda4000-0xfeda4fff has been reserved
[    0.515029] system 00:0d: iomem range 0xfeda5000-0xfeda5fff has been reserved
[    0.515140] system 00:0d: iomem range 0xfeda6000-0xfeda6fff has been reserved
[    0.515252] system 00:0d: iomem range 0xfed1c800-0xfed1cfff has been reserved
[    0.515364] system 00:0d: iomem range 0xfed18000-0xfed1bfff has been reserved
[    0.515476] system 00:0d: iomem range 0xf8000000-0xfbffffff has been reserved
[    0.520522] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0b
[    0.520632] pci 0000:00:1c.0:   IO window: disabled
[    0.520743] pci 0000:00:1c.0:   MEM window: disabled
[    0.520853] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.520967] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:0c
[    0.521082] pci 0000:00:1c.1:   IO window: disabled
[    0.521194] pci 0000:00:1c.1:   MEM window: 0xf6900000-0xf69fffff
[    0.521307] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.521421] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:0d
[    0.521530] pci 0000:00:1c.2:   IO window: disabled
[    0.521642] pci 0000:00:1c.2:   MEM window: disabled
[    0.521753] pci 0000:00:1c.2:   PREFETCH window: disabled
[    0.521866] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:0e
[    0.521977] pci 0000:00:1c.3:   IO window: 0xd000-0xdfff
[    0.522090] pci 0000:00:1c.3:   MEM window: 0xf6600000-0xf68fffff
[    0.522202] pci 0000:00:1c.3:   PREFETCH window: 0x000000f0000000-0x000000f01fffff
[    0.524162] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
[    0.524271] pci 0000:00:1e.0:   IO window: disabled
[    0.524384] pci 0000:00:1e.0:   MEM window: 0xf6500000-0xf65fffff
[    0.524497] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.524619] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.524732] pci 0000:00:1c.0: setting latency timer to 64
[    0.524741] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.524855] pci 0000:00:1c.1: setting latency timer to 64
[    0.524863] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.524976] pci 0000:00:1c.2: setting latency timer to 64
[    0.524985] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.525103] pci 0000:00:1c.3: setting latency timer to 64
[    0.525111] pci 0000:00:1e.0: setting latency timer to 64
[    0.525114] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.525116] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.525118] pci_bus 0000:0b: resource 0 mem: [0x0-0x0]
[    0.525120] pci_bus 0000:0b: resource 1 mem: [0x0-0x0]
[    0.525121] pci_bus 0000:0b: resource 2 mem: [0x0-0x0]
[    0.525123] pci_bus 0000:0b: resource 3 mem: [0x0-0x0]
[    0.525124] pci_bus 0000:0c: resource 0 mem: [0x0-0x0]
[    0.525126] pci_bus 0000:0c: resource 1 mem: [0xf6900000-0xf69fffff]
[    0.525127] pci_bus 0000:0c: resource 2 mem: [0x0-0x0]
[    0.525129] pci_bus 0000:0c: resource 3 mem: [0x0-0x0]
[    0.525131] pci_bus 0000:0d: resource 0 mem: [0x0-0x0]
[    0.525132] pci_bus 0000:0d: resource 1 mem: [0x0-0x0]
[    0.525134] pci_bus 0000:0d: resource 2 mem: [0x0-0x0]
[    0.525135] pci_bus 0000:0d: resource 3 mem: [0x0-0x0]
[    0.525137] pci_bus 0000:0e: resource 0 io:  [0xd000-0xdfff]
[    0.525138] pci_bus 0000:0e: resource 1 mem: [0xf6600000-0xf68fffff]
[    0.525140] pci_bus 0000:0e: resource 2 mem: [0xf0000000-0xf01fffff]
[    0.525142] pci_bus 0000:0e: resource 3 mem: [0x0-0x0]
[    0.525143] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
[    0.525145] pci_bus 0000:03: resource 1 mem: [0xf6500000-0xf65fffff]
[    0.525147] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.525148] pci_bus 0000:03: resource 3 io:  [0x00-0xffff]
[    0.525150] pci_bus 0000:03: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.525172] NET: Registered protocol family 2
[    0.573083] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.573780] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.575469] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.576041] TCP: Hash tables configured (established 262144 bind 65536)
[    0.576151] TCP reno registered
[    0.585080] NET: Registered protocol family 1
[    0.585290] checking if image is initramfs... it is
[    0.845797] Freeing initrd memory: 3731k freed
[    0.847309] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.847705] audit: initializing netlink socket (disabled)
[    0.847824] type=2000 audit(1235515253.845:1): initialized
[    0.855262] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.857631] VFS: Disk quotas dquot_6.5.2
[    0.857808] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.858708] msgmni has been set to 3923
[    0.858910] SELinux:  Registering netfilter hooks
[    0.859235] alg: No test for stdrng (krng)
[    0.859430] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.859602] io scheduler noop registered
[    0.859708] io scheduler anticipatory registered
[    0.859816] io scheduler deadline registered
[    0.860056] io scheduler cfq registered (default)
[    0.860173] pci 0000:00:02.0: Boot video device
[    0.860183] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0080
[    0.860185] pci 0000:00:1a.0: Performing full reset
[    0.860203] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0080
[    0.860205] pci 0000:00:1a.1: Performing full reset
[    0.860223] pci 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0080
[    0.860224] pci 0000:00:1a.2: Performing full reset
[    0.860273] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0080
[    0.860274] pci 0000:00:1d.0: Performing full reset
[    0.860293] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0080
[    0.860294] pci 0000:00:1d.1: Performing full reset
[    0.860312] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0080
[    0.860313] pci 0000:00:1d.2: Performing full reset
[    0.860447] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.860524] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.860702] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.860775] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.860942] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.861015] pcieport-driver 0000:00:1c.2: irq 26 for MSI/MSI-X
[    0.861209] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.861282] pcieport-driver 0000:00:1c.3: irq 27 for MSI/MSI-X
[    0.861511] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.862217] ACPI: SSDT 7D050999, 0281 (r1  PmRef   BspIst     3000 INTL 20050624)
[    0.862853] ACPI: SSDT 7D050DF1, 05C6 (r1  PmRef   BspCst     3001 INTL 20050624)
[    0.863420] Monitor-Mwait will be used to enter C-1 state
[    0.863425] Monitor-Mwait will be used to enter C-2 state
[    0.863429] Monitor-Mwait will be used to enter C-3 state
[    0.863475] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.863790] processor ACPI_CPU:00: registered as cooling_device0
[    0.863899] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.864534] ACPI: SSDT 7D050C1A, 01D7 (r1  PmRef    ApIst     3000 INTL 20050624)
[    0.865099] ACPI: SSDT 7D0513B7, 008D (r1  PmRef    ApCst     3000 INTL 20050624)
[    0.865756] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.866061] processor ACPI_CPU:01: registered as cooling_device1
[    0.866171] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.889722] XENFS: not registering filesystem on non-xen platform
[    0.892268] Non-volatile memory driver v1.3
[    0.892375] Linux agpgart interface v0.103
[    0.892495] agpgart-intel 0000:00:00.0: Intel Mobile Intel® GM45 Express Chipset
[    0.894545] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    0.898340] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.898543] [drm] Initialized drm 1.1.0 20060810
[    0.898708] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.898820] pci 0000:00:02.0: setting latency timer to 64
[    0.911610] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[    0.911785] [drm] MTRR allocation failed
[    0.911786] .  Graphics performance may suffer.
[    0.912012] pci 0000:00:02.0: irq 28 for MSI/MSI-X
[    0.912025] [drm] Initialized i915 1.6.0 20080730 on minor 0
[    0.912148] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.164287] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.164770] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.166276] brd: module loaded
[    1.166444] console [netcon0] enabled
[    1.166552] netconsole: network logging started
[    1.166717] Loading iSCSI transport class v2.0-870.
[    1.167007] Driver 'sd' needs updating - please use bus_type methods
[    1.167149] Driver 'sr' needs updating - please use bus_type methods
[    1.167338] ahci 0000:00:1f.2: version 3.0
[    1.167352] ahci 0000:00:1f.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.167492] ahci 0000:00:1f.2: irq 29 for MSI/MSI-X
[    1.167547] ahci: SSS flag set, parallel bus scan disabled
[    1.167687] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[    1.167860] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems 
[    1.168043] ahci 0000:00:1f.2: setting latency timer to 64
[    1.168346] scsi0 : ahci
[    1.168583] scsi1 : ahci
[    1.168785] scsi2 : ahci
[    1.168980] scsi3 : ahci
[    1.169179] scsi4 : ahci
[    1.169376] scsi5 : ahci
[    1.170005] ata1: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1c900 irq 29
[    1.170177] ata2: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1c980 irq 29
[    1.170348] ata3: DUMMY
[    1.170452] ata4: DUMMY
[    1.170558] ata5: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1cb00 irq 29
[    1.170731] ata6: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1cb80 irq 29
[    1.652020] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.695442] ata1.00: ATA-8: ST9160414ASG, DEC5, max UDMA/133
[    1.695552] ata1.00: 312581808 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    1.698515] ata1.00: configured for UDMA/133
[    1.712091] scsi 0:0:0:0: Direct-Access     ATA      ST9160414ASG     DEC5 PQ: 0 ANSI: 5
[    1.712413] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    1.712597] sd 0:0:0:0: [sda] Write Protect is off
[    1.712705] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.712729] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.712945] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    1.713126] sd 0:0:0:0: [sda] Write Protect is off
[    1.713234] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.713254] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.713429]  sda: sda1 sda2 < sda5 >
[    1.773523] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.773713] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.256020] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.260167] ata2.00: ATAPI: HL-DT-ST DVD+/-RW GSA-U20N, A101, max UDMA/133
[    2.264976] ata2.00: configured for UDMA/133
[    2.286944] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GSA-U20N A101 PQ: 0 ANSI: 5
[    2.298193] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.298366] Uniform CD-ROM driver Revision: 3.20
[    2.298598] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.298672] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.616015] ata5: SATA link down (SStatus 0 SControl 300)
[    2.952014] ata6: SATA link down (SStatus 0 SControl 300)
[    2.968150] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.968261] ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
[    2.968283] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.968404] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    2.968407] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.968563] drivers/usb/core/inode.c: creating file 'devices'
[    2.968567] drivers/usb/core/inode.c: creating file '001'
[    2.968611] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    2.968789] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    2.968792] ehci_hcd 0000:00:1a.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    2.968807] ehci_hcd 0000:00:1a.7: reset command 000002 (park)=0 ithresh=0 period=1024 Reset HALT
[    2.972684] ehci_hcd 0000:00:1a.7: debug port 1
[    2.972796] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    2.972798] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    2.972810] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    2.972921] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    2.976795] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    2.988006] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.988145] usb usb1: default language 0x0409
[    2.988151] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.988262] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.988433] usb usb1: Product: EHCI Host Controller
[    2.988541] usb usb1: Manufacturer: Linux 2.6.29-rc6-00001-g5cdf70f-dirty ehci_hcd
[    2.988713] usb usb1: SerialNumber: 0000:00:1a.7
[    2.988848] usb usb1: uevent
[    2.988880] usb usb1: usb_probe_device
[    2.988881] usb usb1: configuration #1 chosen from 1 choice
[    2.988994] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    2.989008] usb 1-0:1.0: uevent
[    2.989039] hub 1-0:1.0: usb_probe_interface
[    2.989040] hub 1-0:1.0: usb_probe_interface - got id
[    2.989042] hub 1-0:1.0: USB hub found
[    2.989153] hub 1-0:1.0: 6 ports detected
[    2.989259] hub 1-0:1.0: standalone hub
[    2.989261] hub 1-0:1.0: no power switching (usb 1.0)
[    2.989262] hub 1-0:1.0: individual port over-current protection
[    2.989264] hub 1-0:1.0: power on to power good time: 20ms
[    2.989267] hub 1-0:1.0: local power source is good
[    2.989269] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    2.989363] drivers/usb/core/inode.c: creating file '001'
[    2.989433] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.989551] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.989554] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.989699] drivers/usb/core/inode.c: creating file '002'
[    2.989748] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    2.989924] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    2.989928] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    2.989941] ehci_hcd 0000:00:1d.7: reset command 000002 (park)=0 ithresh=0 period=1024 Reset HALT
[    2.993833] ehci_hcd 0000:00:1d.7: debug port 1
[    2.993945] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.993947] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    2.993958] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    2.994069] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    2.997945] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    3.008006] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.008128] usb usb2: default language 0x0409
[    3.008133] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.008245] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.008416] usb usb2: Product: EHCI Host Controller
[    3.008523] usb usb2: Manufacturer: Linux 2.6.29-rc6-00001-g5cdf70f-dirty ehci_hcd
[    3.008694] usb usb2: SerialNumber: 0000:00:1d.7
[    3.008829] usb usb2: uevent
[    3.008860] usb usb2: usb_probe_device
[    3.008862] usb usb2: configuration #1 chosen from 1 choice
[    3.008973] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    3.008985] usb 2-0:1.0: uevent
[    3.009015] hub 2-0:1.0: usb_probe_interface
[    3.009017] hub 2-0:1.0: usb_probe_interface - got id
[    3.009018] hub 2-0:1.0: USB hub found
[    3.009128] hub 2-0:1.0: 6 ports detected
[    3.009234] hub 2-0:1.0: standalone hub
[    3.009235] hub 2-0:1.0: no power switching (usb 1.0)
[    3.009237] hub 2-0:1.0: individual port over-current protection
[    3.009238] hub 2-0:1.0: power on to power good time: 20ms
[    3.009242] hub 2-0:1.0: local power source is good
[    3.009243] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    3.009305] drivers/usb/core/inode.c: creating file '001'
[    3.009385] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.009495] ohci_hcd: block sizes: ed 80 td 96
[    3.009529] uhci_hcd: USB Universal Host Controller Interface driver
[    3.009705] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.009822] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.009825] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    3.009972] drivers/usb/core/inode.c: creating file '003'
[    3.010018] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    3.010196] uhci_hcd 0000:00:1a.0: detected 2 ports
[    3.010307] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    3.010308] uhci_hcd 0000:00:1a.0: Performing full reset
[    3.010322] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    3.010326] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f60
[    3.010462] usb usb3: default language 0x0409
[    3.010467] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.010578] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.010750] usb usb3: Product: UHCI Host Controller
[    3.010857] usb usb3: Manufacturer: Linux 2.6.29-rc6-00001-g5cdf70f-dirty uhci_hcd
[    3.011029] usb usb3: SerialNumber: 0000:00:1a.0
[    3.011163] usb usb3: uevent
[    3.011193] usb usb3: usb_probe_device
[    3.011195] usb usb3: configuration #1 chosen from 1 choice
[    3.011306] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    3.011323] usb 3-0:1.0: uevent
[    3.011354] hub 3-0:1.0: usb_probe_interface
[    3.011355] hub 3-0:1.0: usb_probe_interface - got id
[    3.011357] hub 3-0:1.0: USB hub found
[    3.011467] hub 3-0:1.0: 2 ports detected
[    3.011573] hub 3-0:1.0: standalone hub
[    3.011574] hub 3-0:1.0: no power switching (usb 1.0)
[    3.011575] hub 3-0:1.0: individual port over-current protection
[    3.011577] hub 3-0:1.0: power on to power good time: 2ms
[    3.011580] hub 3-0:1.0: local power source is good
[    3.011582] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    3.011630] drivers/usb/core/inode.c: creating file '001'
[    3.011698] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    3.011813] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    3.011816] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    3.011963] drivers/usb/core/inode.c: creating file '004'
[    3.012024] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    3.013978] uhci_hcd 0000:00:1a.1: detected 2 ports
[    3.014089] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    3.014090] uhci_hcd 0000:00:1a.1: Performing full reset
[    3.014105] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    3.014115] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f80
[    3.014248] usb usb4: default language 0x0409
[    3.014254] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.014364] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.014534] usb usb4: Product: UHCI Host Controller
[    3.014642] usb usb4: Manufacturer: Linux 2.6.29-rc6-00001-g5cdf70f-dirty uhci_hcd
[    3.014812] usb usb4: SerialNumber: 0000:00:1a.1
[    3.014945] usb usb4: uevent
[    3.014978] usb usb4: usb_probe_device
[    3.014980] usb usb4: configuration #1 chosen from 1 choice
[    3.015091] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    3.015102] usb 4-0:1.0: uevent
[    3.015131] hub 4-0:1.0: usb_probe_interface
[    3.015132] hub 4-0:1.0: usb_probe_interface - got id
[    3.015134] hub 4-0:1.0: USB hub found
[    3.015245] hub 4-0:1.0: 2 ports detected
[    3.015352] hub 4-0:1.0: standalone hub
[    3.015354] hub 4-0:1.0: no power switching (usb 1.0)
[    3.015355] hub 4-0:1.0: individual port over-current protection
[    3.015356] hub 4-0:1.0: power on to power good time: 2ms
[    3.015359] hub 4-0:1.0: local power source is good
[    3.015361] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    3.015410] drivers/usb/core/inode.c: creating file '001'
[    3.015478] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    3.015593] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    3.015596] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    3.015740] drivers/usb/core/inode.c: creating file '005'
[    3.015787] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    3.015963] uhci_hcd 0000:00:1a.2: detected 2 ports
[    3.016077] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    3.016079] uhci_hcd 0000:00:1a.2: Performing full reset
[    3.016093] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    3.016097] uhci_hcd 0000:00:1a.2: irq 22, io base 0x00006fa0
[    3.016231] usb usb5: default language 0x0409
[    3.016236] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.016347] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.016517] usb usb5: Product: UHCI Host Controller
[    3.016625] usb usb5: Manufacturer: Linux 2.6.29-rc6-00001-g5cdf70f-dirty uhci_hcd
[    3.016795] usb usb5: SerialNumber: 0000:00:1a.2
[    3.016927] usb usb5: uevent
[    3.016959] usb usb5: usb_probe_device
[    3.016960] usb usb5: configuration #1 chosen from 1 choice
[    3.017072] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    3.017086] usb 5-0:1.0: uevent
[    3.017117] hub 5-0:1.0: usb_probe_interface
[    3.017119] hub 5-0:1.0: usb_probe_interface - got id
[    3.017120] hub 5-0:1.0: USB hub found
[    3.017230] hub 5-0:1.0: 2 ports detected
[    3.017337] hub 5-0:1.0: standalone hub
[    3.017338] hub 5-0:1.0: no power switching (usb 1.0)
[    3.017339] hub 5-0:1.0: individual port over-current protection
[    3.017341] hub 5-0:1.0: power on to power good time: 2ms
[    3.017344] hub 5-0:1.0: local power source is good
[    3.017345] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    3.017395] drivers/usb/core/inode.c: creating file '001'
[    3.017462] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.017578] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.017581] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.017730] drivers/usb/core/inode.c: creating file '006'
[    3.017780] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    3.017956] uhci_hcd 0000:00:1d.0: detected 2 ports
[    3.018067] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    3.018068] uhci_hcd 0000:00:1d.0: Performing full reset
[    3.018083] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    3.018086] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f00
[    3.018220] usb usb6: default language 0x0409
[    3.018225] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    3.018336] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.018507] usb usb6: Product: UHCI Host Controller
[    3.018615] usb usb6: Manufacturer: Linux 2.6.29-rc6-00001-g5cdf70f-dirty uhci_hcd
[    3.018786] usb usb6: SerialNumber: 0000:00:1d.0
[    3.018919] usb usb6: uevent
[    3.018953] usb usb6: usb_probe_device
[    3.018954] usb usb6: configuration #1 chosen from 1 choice
[    3.019066] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    3.019078] usb 6-0:1.0: uevent
[    3.019108] hub 6-0:1.0: usb_probe_interface
[    3.019110] hub 6-0:1.0: usb_probe_interface - got id
[    3.019111] hub 6-0:1.0: USB hub found
[    3.019220] hub 6-0:1.0: 2 ports detected
[    3.019327] hub 6-0:1.0: standalone hub
[    3.019328] hub 6-0:1.0: no power switching (usb 1.0)
[    3.019330] hub 6-0:1.0: individual port over-current protection
[    3.019331] hub 6-0:1.0: power on to power good time: 2ms
[    3.019334] hub 6-0:1.0: local power source is good
[    3.019336] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    3.019384] drivers/usb/core/inode.c: creating file '001'
[    3.019453] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    3.019569] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.019571] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.019718] drivers/usb/core/inode.c: creating file '007'
[    3.019763] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    3.019938] uhci_hcd 0000:00:1d.1: detected 2 ports
[    3.020053] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    3.020055] uhci_hcd 0000:00:1d.1: Performing full reset
[    3.020070] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    3.020074] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f20
[    3.020212] usb usb7: default language 0x0409
[    3.020218] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    3.020327] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.020498] usb usb7: Product: UHCI Host Controller
[    3.020604] usb usb7: Manufacturer: Linux 2.6.29-rc6-00001-g5cdf70f-dirty uhci_hcd
[    3.020774] usb usb7: SerialNumber: 0000:00:1d.1
[    3.020909] usb usb7: uevent
[    3.020942] usb usb7: usb_probe_device
[    3.020944] usb usb7: configuration #1 chosen from 1 choice
[    3.021054] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    3.021066] usb 7-0:1.0: uevent
[    3.021097] hub 7-0:1.0: usb_probe_interface
[    3.021099] hub 7-0:1.0: usb_probe_interface - got id
[    3.021100] hub 7-0:1.0: USB hub found
[    3.021209] hub 7-0:1.0: 2 ports detected
[    3.021315] hub 7-0:1.0: standalone hub
[    3.021317] hub 7-0:1.0: no power switching (usb 1.0)
[    3.021318] hub 7-0:1.0: individual port over-current protection
[    3.021319] hub 7-0:1.0: power on to power good time: 2ms
[    3.021322] hub 7-0:1.0: local power source is good
[    3.021324] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    3.021377] drivers/usb/core/inode.c: creating file '001'
[    3.021445] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    3.021560] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.021563] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.021706] drivers/usb/core/inode.c: creating file '008'
[    3.021751] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    3.021925] uhci_hcd 0000:00:1d.2: detected 2 ports
[    3.022035] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    3.022037] uhci_hcd 0000:00:1d.2: Performing full reset
[    3.022051] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    3.022055] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    3.022194] usb usb8: default language 0x0409
[    3.022199] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    3.022310] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.022479] usb usb8: Product: UHCI Host Controller
[    3.022585] usb usb8: Manufacturer: Linux 2.6.29-rc6-00001-g5cdf70f-dirty uhci_hcd
[    3.022756] usb usb8: SerialNumber: 0000:00:1d.2
[    3.022890] usb usb8: uevent
[    3.022922] usb usb8: usb_probe_device
[    3.022923] usb usb8: configuration #1 chosen from 1 choice
[    3.023034] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    3.023045] usb 8-0:1.0: uevent
[    3.023076] hub 8-0:1.0: usb_probe_interface
[    3.023077] hub 8-0:1.0: usb_probe_interface - got id
[    3.023079] hub 8-0:1.0: USB hub found
[    3.023188] hub 8-0:1.0: 2 ports detected
[    3.023293] hub 8-0:1.0: standalone hub
[    3.023294] hub 8-0:1.0: no power switching (usb 1.0)
[    3.023296] hub 8-0:1.0: individual port over-current protection
[    3.023297] hub 8-0:1.0: power on to power good time: 2ms
[    3.023300] hub 8-0:1.0: local power source is good
[    3.023302] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    3.023355] drivers/usb/core/inode.c: creating file '001'
[    3.023489] usbcore: registered new interface driver usblp
[    3.023598] Initializing USB Mass Storage driver...
[    3.023758] usbcore: registered new interface driver usb-storage
[    3.023868] USB Mass Storage support registered.
[    3.024028] usbcore: registered new interface driver libusual
[    3.024222] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    3.024681] i8042.c: Warning: Keylock active.
[    3.028554] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.028664] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.028831] mice: PS/2 mouse device common for all mice
[    3.029133] rtc_cmos 00:03: RTC can wake from S4
[    3.029287] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    3.029422] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.029574] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.029987] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    3.030421] cpuidle: using governor ladder
[    3.030979] cpuidle: using governor menu
[    3.031089] No iBFT detected.
[    3.031245] Marking TSC unstable due to TSC halts in idle
[    3.033532] modprobe used greatest stack depth: 5312 bytes left
[    3.033596] usbcore: registered new interface driver hiddev
[    3.033631] usbcore: registered new interface driver usbhid
[    3.033633] usbhid: v2.6:USB HID core driver
[    3.033679] Advanced Linux Sound Architecture Driver Version 1.0.18a.
[    3.035862] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    3.036064] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    3.088037] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
[    3.088042] hub 1-0:1.0: port 1: status 0501 change 0001
[    3.088059] ehci_hcd 0000:00:1a.7: GetStatus port 5 status 001803 POWER sig=j CSC CONNECT
[    3.088063] hub 1-0:1.0: port 5: status 0501 change 0001
[    3.088072] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 001803 POWER sig=j CSC CONNECT
[    3.088076] hub 1-0:1.0: port 6: status 0501 change 0001
[    3.108069] uhci_hcd 0000:00:1a.0: port 1 portsc 0082,00
[    3.108075] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    3.112232] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.116216] uhci_hcd 0000:00:1a.2: port 1 portsc 008a,00
[    3.116232] uhci_hcd 0000:00:1a.2: port 2 portsc 0082,00
[    3.116279] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.120248] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.120252] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.144636] input: HDA Intel Mic at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/input/input0
[    3.156486] input: HDA Intel Mic at Ext Right Jack as /devices/pci0000:00/0000:00:1b.0/input/input1
[    3.172284] input: HDA Intel Line Out at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/input/input2
[    3.188241] hub 1-0:1.0: state 7 ports 6 chg 0062 evt 0000
[    3.188249] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    3.188498] input: HDA Intel HP Out at Ext Right Jack as /devices/pci0000:00/0000:00:1b.0/input/input3
[    3.201541] ALSA device list:
[    3.201647]   #0: HDA Intel at 0xf6adc000 irq 21
[    3.201799] Netfilter messages via NETLINK v0.30.
[    3.201916] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.202269] ctnetlink v0.93: registering with nfnetlink.
[    3.202872] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.203004] TCP cubic registered
[    3.203110] Initializing XFRM netlink socket
[    3.203527] NET: Registered protocol family 10
[    3.204295] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    3.204444] IPv6 over IPv4 tunneling driver
[    3.205095] NET: Registered protocol family 17
[    3.205414] RPC: Registered udp transport module.
[    3.205522] RPC: Registered tcp transport module.
[    3.205639] lib80211: common routines for IEEE802.11 drivers
[    3.205749] lib80211_crypt: registered algorithm 'NULL'
[    3.206790] registered taskstats version 1
[    3.207009]   Magic number: 13:246:705
[    3.207210] Freeing unused kernel memory: 640k freed
[    3.207560] Write protecting the kernel read-only data: 7016k
[    3.213899] all_generic_ide used greatest stack depth: 5296 bytes left
[    3.245578] ehci_hcd 0000:00:1a.7: port 1 high speed
[    3.245583] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[    3.289247] thermal LNXTHERM:01: registered as thermal_zone0
[    3.296144] ACPI: Thermal Zone [THM] (49 C)
[    3.301046] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    3.316765] usb usb3: uevent
[    3.316782] usb 3-0:1.0: uevent
[    3.316861] usb usb4: uevent
[    3.316875] usb 4-0:1.0: uevent
[    3.316952] usb usb5: uevent
[    3.316967] usb 5-0:1.0: uevent
[    3.317046] usb usb1: uevent
[    3.317060] usb 1-0:1.0: uevent
[    3.317639] usb usb6: uevent
[    3.317654] usb 6-0:1.0: uevent
[    3.317733] usb usb7: uevent
[    3.317748] usb 7-0:1.0: uevent
[    3.317825] usb usb8: uevent
[    3.317843] usb 8-0:1.0: uevent
[    3.317920] usb usb2: uevent
[    3.317934] usb 2-0:1.0: uevent
[    3.357327] ehci_hcd 0000:00:1a.7: port 1 high speed
[    3.357331] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[    3.402316] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    3.402430] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    3.402585] e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    3.402707] e1000e 0000:00:19.0: setting latency timer to 64
[    3.402814] e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
[    3.433467] usb 1-1: New USB device found, idVendor=0424, idProduct=2512
[    3.433580] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.433740] usb 1-1: uevent
[    3.433749] usb 1-1: usb_probe_device
[    3.433751] usb 1-1: configuration #1 chosen from 1 choice
[    3.433968] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    3.433982] usb 1-1:1.0: uevent
[    3.433992] hub 1-1:1.0: usb_probe_interface
[    3.433993] hub 1-1:1.0: usb_probe_interface - got id
[    3.433995] hub 1-1:1.0: USB hub found
[    3.434216] hub 1-1:1.0: 2 ports detected
[    3.434325] hub 1-1:1.0: compound device; port removable status: FF
[    3.434327] hub 1-1:1.0: individual port power switching
[    3.434328] hub 1-1:1.0: individual port over-current protection
[    3.434329] hub 1-1:1.0: Single TT
[    3.434331] hub 1-1:1.0: TT requires at most 8 FS bit times (666 ns)
[    3.434332] hub 1-1:1.0: power on to power good time: 100ms
[    3.434591] hub 1-1:1.0: local power source is good
[    3.434592] hub 1-1:1.0: enabling power on all ports
[    3.434875] drivers/usb/core/inode.c: creating file '002'
[    3.434907] hub 1-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
[    3.488204] ehci_hcd 0000:00:1a.7: port 5 full speed --> companion
[    3.488208] ehci_hcd 0000:00:1a.7: GetStatus port 5 status 003801 POWER OWNER sig=j CONNECT
[    3.488211] hub 1-0:1.0: port 5 not reset yet, waiting 50ms
[    3.490962] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:21:70:d1:b7:92
[    3.491142] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.491282] 0000:00:19.0: eth0: MAC: 6, PHY: 8, PBA No: 1004ff-0ff
[    3.491405] ohci1394 0000:03:01.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.500041] Clocksource tsc unstable (delta = -125744742 ns)
[    3.528024] scsi_id used greatest stack depth: 4960 bytes left
[    3.532094] hub 1-1:1.0: port 1: status 0101 change 0001
[    3.532338] hub 1-1:1.0: port 2: status 0101 change 0001
[    3.544027] ehci_hcd 0000:00:1a.7: GetStatus port 5 status 003002 POWER OWNER sig=se0 CSC
[    3.544050] hub 1-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[    3.550107] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[f65ff800-f65fffff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[    3.600203] ehci_hcd 0000:00:1a.7: port 6 high speed
[    3.600207] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 001005 POWER sig=se0 PE CONNECT
[    3.632104] usb 1-1: link qh256-0001/ffff88007a9b7140 start 255 [1/0 us]
[    3.656052] usb 1-6: new high speed USB device using ehci_hcd and address 4
[    3.707537] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input4
[    3.716327] ehci_hcd 0000:00:1a.7: port 6 high speed
[    3.716330] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 001005 POWER sig=se0 PE CONNECT
[    3.749451] PM: Starting manual resume from disk
[    3.749559] PM: Resume from partition 8:5
[    3.749561] PM: Checking hibernation image.
[    3.750035] PM: Resume from disk failed.
[    3.752531] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input5
[    3.789201] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input6
[    3.819246] kjournald starting.  Commit interval 5 seconds
[    3.819370] EXT3-fs: mounted filesystem with ordered data mode.
[    3.828129] usb 1-6: skipped 2 descriptors after configuration
[    3.828131] usb 1-6: skipped 6 descriptors after interface
[    3.828133] usb 1-6: skipped 1 descriptor after endpoint
[    3.828135] usb 1-6: skipped 8 descriptors after interface
[    3.828742] usb 1-6: default language 0x0409
[    3.833742] usb 1-6: New USB device found, idVendor=0c45, idProduct=63f8
[    3.833863] usb 1-6: New USB device strings: Mfr=2, Product=1, SerialNumber=0
[    3.833974] usb 1-6: Product: Laptop_Integrated_Webcam_0.3M
[    3.834082] usb 1-6: Manufacturer: CN0TX593724878C2013V
[    3.834225] usb 1-6: uevent
[    3.834234] usb 1-6: usb_probe_device
[    3.834236] usb 1-6: configuration #1 chosen from 1 choice
[    3.834752] usb 1-6: adding 1-6:1.0 (config #1, interface 0)
[    3.836750] usb 1-6:1.0: uevent
[    3.836811] usb 1-6: adding 1-6:1.1 (config #1, interface 1)
[    3.836833] usb 1-6:1.1: uevent
[    3.836852] drivers/usb/core/inode.c: creating file '004'
[    3.836900] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.836906] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    3.836915] uhci_hcd 0000:00:1a.2: port 1 portsc 0093,00
[    3.836924] hub 5-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    3.960056] hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    4.072070] usb 5-1: new full speed USB device using uhci_hcd and address 2
[    4.120053] usb usb4: suspend_rh (auto-stop)
[    4.120079] usb usb6: suspend_rh (auto-stop)
[    4.120106] usb usb7: suspend_rh (auto-stop)
[    4.120131] usb usb8: suspend_rh (auto-stop)
[    4.224277] usb 5-1: skipped 1 descriptor after interface
[    4.224281] usb 5-1: skipped 1 descriptor after interface
[    4.231273] usb 5-1: default language 0x0409
[    4.248264] usb 5-1: New USB device found, idVendor=0a5c, idProduct=5800
[    4.248375] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.248485] usb 5-1: Product: 5880
[    4.248590] usb 5-1: Manufacturer: Broadcom Corp
[    4.248697] usb 5-1: SerialNumber: 0123456789ABCD
[    4.248834] usb 5-1: uevent
[    4.248841] usb 5-1: usb_probe_device
[    4.248842] usb 5-1: configuration #0 chosen from 1 choice
[    4.248950] usb 5-1: config 0 descriptor??
[    4.250272] usb 5-1: adding 5-1:0.0 (config #0, interface 0)
[    4.255278] usb 5-1:0.0: uevent
[    4.255389] usb 5-1: adding 5-1:0.1 (config #0, interface 1)
[    4.258281] usb 5-1:0.1: uevent
[    4.258392] drivers/usb/core/inode.c: creating file '002'
[    4.258433] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0020
[    4.258442] hub 1-1:1.0: state 7 ports 2 chg 0006 evt 0000
[    4.258637] hub 1-1:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    4.328251] usb 1-1.1: new high speed USB device using ehci_hcd and address 5
[    4.368054] usb usb3: suspend_rh (auto-stop)
[    4.424491] usb 1-1.1: skipped 2 descriptors after interface
[    4.424495] usb 1-1.1: New USB device found, idVendor=413c, idProduct=8149
[    4.424613] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.424820] usb 1-1.1: uevent
[    4.424828] usb 1-1.1: usb_probe_device
[    4.424829] usb 1-1.1: configuration #1 chosen from 1 choice
[    4.425118] usb 1-1.1: adding 1-1.1:1.0 (config #1, interface 0)
[    4.425137] usb 1-1.1:1.0: uevent
[    4.425157] drivers/usb/core/inode.c: creating file '005'
[    4.425372] hub 1-1:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    4.440246] hub 1-1:1.0: port 2 not reset yet, waiting 10ms
[    4.462112] runlevel used greatest stack depth: 3608 bytes left
[    4.513245] usb 1-1.2: new full speed USB device using ehci_hcd and address 6
[    4.525388] stty used greatest stack depth: 3520 bytes left
[    4.605050] usb 1-1.2: ep0 maxpacket = 8
[    4.606621] usb 1-1.2: default language 0x0409
[    4.606979] usb 1-1.2: New USB device found, idVendor=0a5c, idProduct=4500
[    4.607096] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.607274] usb 1-1.2: Product: BCM2046B1
[    4.607380] usb 1-1.2: Manufacturer: Broadcom
[    4.607517] usb 1-1.2: uevent
[    4.607524] usb 1-1.2: usb_probe_device
[    4.607526] usb 1-1.2: configuration #1 chosen from 1 choice
[    4.607730] usb 1-1.2: adding 1-1.2:1.0 (config #1, interface 0)
[    4.607756] usb 1-1.2:1.0: uevent
[    4.607771] hub 1-1.2:1.0: usb_probe_interface
[    4.607773] hub 1-1.2:1.0: usb_probe_interface - got id
[    4.607776] hub 1-1.2:1.0: USB hub found
[    4.607980] hub 1-1.2:1.0: 3 ports detected
[    4.608092] hub 1-1.2:1.0: compound device; port removable status: FFF
[    4.608094] hub 1-1.2:1.0: ganged power switching
[    4.608095] hub 1-1.2:1.0: global over-current protection
[    4.608096] hub 1-1.2:1.0: power on to power good time: 100ms
[    4.608350] hub 1-1.2:1.0: local power source is good
[    4.608352] hub 1-1.2:1.0: no over-current condition exists
[    4.608355] hub 1-1.2:1.0: enabling power on all ports
[    4.608782] drivers/usb/core/inode.c: creating file '006'
[    4.608823] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    4.608833] hub 1-1:1.0: state 7 ports 2 chg 0000 evt 0004
[    4.708250] hub 1-1.2:1.0: port 1: status 0101 change 0001
[    4.708625] hub 1-1.2:1.0: port 2: status 0101 change 0001
[    4.808078] usb 1-1.2: link qh128-0601/ffff88007a9b73c0 start 127 [1/2 us]
[    4.808111] hub 1-1.2:1.0: state 7 ports 3 chg 0006 evt 0000
[    4.808247] hub 1-1.2:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    4.825151] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[314fc00010e571e1]
[    4.881247] usb 1-1.2.1: new full speed USB device using ehci_hcd and address 7
[    4.973047] usb 1-1.2.1: ep0 maxpacket = 8
[    4.975996] usb 1-1.2.1: skipped 1 descriptor after interface
[    4.976000] usb 1-1.2.1: New USB device found, idVendor=413c, idProduct=8153
[    4.976139] usb 1-1.2.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.976370] usb 1-1.2.1: uevent
[    4.976378] usb 1-1.2.1: usb_probe_device
[    4.976380] usb 1-1.2.1: configuration #1 chosen from 1 choice
[    4.976621] usb 1-1.2.1: adding 1-1.2.1:1.0 (config #1, interface 0)
[    4.976642] usb 1-1.2.1:1.0: uevent
[    4.976667] usbhid 1-1.2.1:1.0: usb_probe_interface
[    4.976670] usbhid 1-1.2.1:1.0: usb_probe_interface - got id
[    4.978234] input: HID 413c:8153 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2.1/1-1.2.1:1.0/input/input7
[    4.992074] usb 1-1.2.1: link qh8-3008/ffff88007a9b7500 start 7 [1/2 us]
[    5.008123] generic-usb 0003:413C:8153.0001: input,hidraw0: USB HID v1.11 Keyboard [HID 413c:8153] on usb-0000:00:1a.7-1.2.1/input0
[    5.008340] drivers/usb/core/inode.c: creating file '007'
[    5.008499] hub 1-1.2:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    5.080249] usb 1-1.2.2: new full speed USB device using ehci_hcd and address 8
[    5.172069] usb 1-1.2.2: ep0 maxpacket = 8
[    5.175647] usb 1-1.2.2: skipped 1 descriptor after interface
[    5.175650] usb 1-1.2.2: skipped 1 descriptor after endpoint
[    5.175653] usb 1-1.2.2: New USB device found, idVendor=413c, idProduct=8154
[    5.175770] usb 1-1.2.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.175977] usb 1-1.2.2: uevent
[    5.175985] usb 1-1.2.2: usb_probe_device
[    5.175986] usb 1-1.2.2: configuration #1 chosen from 1 choice
[    5.176271] usb 1-1.2.2: adding 1-1.2.2:1.0 (config #1, interface 0)
[    5.176291] usb 1-1.2.2:1.0: uevent
[    5.176313] usbhid 1-1.2.2:1.0: usb_probe_interface
[    5.176315] usbhid 1-1.2.2:1.0: usb_probe_interface - got id
[    5.179027] input: HID 413c:8154 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2.2/1-1.2.2:1.0/input/input8
[    5.204099] generic-usb 0003:413C:8154.0002: input,hidraw1: USB HID v1.11 Mouse [HID 413c:8154] on usb-0000:00:1a.7-1.2.2/input0
[    5.204372] drivers/usb/core/inode.c: creating file '008'
[    5.204396] hub 1-1.2:1.0: state 7 ports 3 chg 0000 evt 0004
[    5.804062] hub 2-0:1.0: hub_suspend
[    5.804068] usb usb2: bus auto-suspend
[    5.804071] ehci_hcd 0000:00:1d.7: suspend root hub
[    5.804095] hub 4-0:1.0: hub_suspend
[    5.804098] usb usb4: bus auto-suspend
[    5.804101] usb usb4: suspend_rh
[    5.804117] hub 6-0:1.0: hub_suspend
[    5.804121] usb usb6: bus auto-suspend
[    5.804123] usb usb6: suspend_rh
[    5.804140] hub 7-0:1.0: hub_suspend
[    5.804143] usb usb7: bus auto-suspend
[    5.804145] usb usb7: suspend_rh
[    5.804161] hub 8-0:1.0: hub_suspend
[    5.804165] usb usb8: bus auto-suspend
[    5.804166] usb usb8: suspend_rh
[    6.816067] hub 3-0:1.0: hub_suspend
[    6.816072] usb usb3: bus auto-suspend
[    6.816075] usb usb3: suspend_rh
[    9.258708] udevd version 124 started
[    9.282282] usb usb3: uevent
[    9.282300] usb 3-0:1.0: uevent
[    9.282392] usb usb4: uevent
[    9.282409] usb 4-0:1.0: uevent
[    9.282502] usb usb5: uevent
[    9.282520] usb 5-0:1.0: uevent
[    9.282554] usb 5-1: uevent
[    9.282571] usb 5-1:0.0: uevent
[    9.282637] usb 5-1:0.1: uevent
[    9.282779] usb usb1: uevent
[    9.282796] usb 1-0:1.0: uevent
[    9.282831] usb 1-1: uevent
[    9.282849] usb 1-1.1: uevent
[    9.282866] usb 1-1.1:1.0: uevent
[    9.282903] usb 1-1.2: uevent
[    9.282921] usb 1-1.2.1: uevent
[    9.282940] usb 1-1.2.1:1.0: uevent
[    9.283078] usb 1-1.2.2: uevent
[    9.283097] usb 1-1.2.2:1.0: uevent
[    9.283241] usb 1-1.2:1.0: uevent
[    9.283292] usb 1-1:1.0: uevent
[    9.283344] usb 1-6: uevent
[    9.283361] usb 1-6:1.0: uevent
[    9.283396] usb 1-6:1.1: uevent
[    9.284031] usb usb6: uevent
[    9.284048] usb 6-0:1.0: uevent
[    9.284141] usb usb7: uevent
[    9.284159] usb 7-0:1.0: uevent
[    9.284297] usb usb8: uevent
[    9.284327] usb 8-0:1.0: uevent
[    9.284482] usb usb2: uevent
[    9.284510] usb 2-0:1.0: uevent
[    9.393348] ACPI: AC Adapter [AC] (on-line)
[    9.437357] ACPI: Battery Slot [BAT0] (battery present)
[    9.437529] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input9
[    9.458066] ACPI: Lid Switch [LID]
[    9.458273] ACPI: Battery Slot [BAT1] (battery absent)
[    9.458450] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input10
[    9.480104] ACPI: Power Button (CM) [PBTN]
[    9.480264] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input11
[    9.504066] ACPI: Sleep Button (CM) [SBTN]
[    9.509335] usb usb2: usb auto-resume
[    9.509339] ehci_hcd 0000:00:1d.7: resume root hub
[    9.537020] hub 2-0:1.0: hub_resume
[    9.537101] usb usb8: usb auto-resume
[    9.537104] usb usb8: wakeup_rh
[    9.537111] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    9.569210] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27kds
[    9.569384] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[    9.569670] iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    9.569786] iwlagn 0000:0c:00.0: setting latency timer to 64
[    9.569853] iwlagn: Detected Intel Wireless WiFi Link 5100AGN REV=0x54
[    9.577063] hub 8-0:1.0: hub_resume
[    9.577128] usb usb7: usb auto-resume
[    9.577131] usb usb7: wakeup_rh
[    9.577140] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    9.591694] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
[    9.592018] iwlagn 0000:0c:00.0: PCI INT A disabled
[    9.592237] wmaster0 (iwlagn): not using net_device_ops yet
[    9.592883] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    9.599007] wlan0 (iwlagn): not using net_device_ops yet
[    9.617025] hub 7-0:1.0: hub_resume
[    9.617089] usb usb6: usb auto-resume
[    9.617091] usb usb6: wakeup_rh
[    9.617098] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    9.657031] hub 6-0:1.0: hub_resume
[    9.657311] usb usb4: usb auto-resume
[    9.657313] usb usb4: wakeup_rh
[    9.657320] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    9.697042] hub 4-0:1.0: hub_resume
[    9.697107] usb usb3: usb auto-resume
[    9.697109] usb usb3: wakeup_rh
[    9.697115] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    9.737081] hub 3-0:1.0: hub_resume
[    9.737181] usbhid 1-1.2.2:1.0: disconnect by usbfs
[    9.737292] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    9.765227] usb 1-1.2.2: usbfs: process 2069 (hid2hci) did not claim interface 0 before use
[    9.888141] hub 1-1.2:1.0: state 7 ports 3 chg 0000 evt 0008
[    9.888493] hub 1-1.2:1.0: port 3, status 0101, change 0001, 12 Mb/s
[   10.016136] hub 1-1.2:1.0: debounce: port 3: total 100ms stable 100ms status 0x101
[   10.089098] usb 1-1.2.3: new full speed USB device using ehci_hcd and address 9
[   10.183991] usb 1-1.2.3: skipped 1 descriptor after interface
[   10.184239] usb 1-1.2.3: default language 0x0409
[   10.185243] usb 1-1.2.3: New USB device found, idVendor=413c, idProduct=8152
[   10.185245] usb 1-1.2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   10.185247] usb 1-1.2.3: Product: Dell Wireless 410 Bluetooth + UWB Mini-card
[   10.185248] usb 1-1.2.3: Manufacturer: Dell Computer Corp
[   10.185310] usb 1-1.2.3: uevent
[   10.185324] usb 1-1.2.3: usb_probe_device
[   10.185326] usb 1-1.2.3: configuration #1 chosen from 1 choice
[   10.186883] usb 1-1.2.3: adding 1-1.2.3:1.0 (config #1, interface 0)
[   10.186901] usb 1-1.2.3:1.0: uevent
[   10.186989] usb 1-1.2.3: adding 1-1.2.3:1.1 (config #1, interface 1)
[   10.187001] usb 1-1.2.3:1.1: uevent
[   10.187055] usb 1-1.2.3: adding 1-1.2.3:1.2 (config #1, interface 2)
[   10.187067] usb 1-1.2.3:1.2: uevent
[   10.187121] usb 1-1.2.3: adding 1-1.2.3:1.3 (config #1, interface 3)
[   10.187133] usb 1-1.2.3:1.3: uevent
[   10.187147] drivers/usb/core/inode.c: creating file '009'
[   10.187176] hub 1-1.2:1.0: state 7 ports 3 chg 0000 evt 0008
[   10.204149] Bluetooth: Generic Bluetooth USB driver ver 0.4
[   10.204172] btusb 1-1.2.3:1.0: usb_probe_interface
[   10.204174] btusb 1-1.2.3:1.0: usb_probe_interface - got id
[   10.204219] btusb 1-1.2.3:1.2: usb_probe_interface
[   10.204220] btusb 1-1.2.3:1.2: usb_probe_interface - got id
[   10.204227] btusb 1-1.2.3:1.3: usb_probe_interface
[   10.204228] btusb 1-1.2.3:1.3: usb_probe_interface - got id
[   10.204240] usbcore: registered new interface driver btusb
[   10.230945] Adding 5879748k swap on /dev/sda5.  Priority:-1 extents:1 across:5879748k 
[   10.545763] EXT3 FS on sda1, internal journal
[   10.569056] usb usb8: suspend_rh (auto-stop)
[   10.817052] usb usb7: suspend_rh (auto-stop)
[   10.817080] usb usb6: suspend_rh (auto-stop)
[   10.817107] usb usb4: suspend_rh (auto-stop)
[   10.817133] usb usb3: suspend_rh (auto-stop)
[   11.805055] hub 2-0:1.0: hub_suspend
[   11.805064] usb usb2: bus auto-suspend
[   11.805067] ehci_hcd 0000:00:1d.7: suspend root hub
[   11.805091] hub 8-0:1.0: hub_suspend
[   11.805094] usb usb8: bus auto-suspend
[   11.805097] usb usb8: suspend_rh
[   11.805114] hub 7-0:1.0: hub_suspend
[   11.805117] usb usb7: bus auto-suspend
[   11.805119] usb usb7: suspend_rh
[   11.805136] hub 6-0:1.0: hub_suspend
[   11.805139] usb usb6: bus auto-suspend
[   11.805141] usb usb6: suspend_rh
[   11.805157] hub 4-0:1.0: hub_suspend
[   11.805160] usb usb4: bus auto-suspend
[   11.805162] usb usb4: suspend_rh
[   11.805180] hub 3-0:1.0: hub_suspend
[   11.805183] usb usb3: bus auto-suspend
[   11.805185] usb usb3: suspend_rh
[   12.416335] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   13.355822] ppdev: user-space parallel port driver
[   15.283394] usb usb2: usb auto-resume
[   15.283404] ehci_hcd 0000:00:1d.7: resume root hub
[   15.312257] hub 2-0:1.0: hub_resume
[   15.312349] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   15.312530] usb usb8: usb auto-resume
[   15.312537] usb usb8: wakeup_rh
[   15.337477] Bluetooth: L2CAP ver 2.11
[   15.337482] Bluetooth: L2CAP socket layer initialized
[   15.352256] hub 8-0:1.0: hub_resume
[   15.352338] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.352490] usb usb7: usb auto-resume
[   15.352497] usb usb7: wakeup_rh
[   15.361493] Bluetooth: SCO (Voice Link) ver 0.6
[   15.361499] Bluetooth: SCO socket layer initialized
[   15.386127] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   15.392067] hub 7-0:1.0: hub_resume
[   15.392236] usb usb6: usb auto-resume
[   15.392242] usb usb6: wakeup_rh
[   15.395173] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.397271] btusb_submit_intr_urb: hci0 urb ffff88007a0cb840 submission failed (28)
[   15.432254] hub 6-0:1.0: hub_resume
[   15.432339] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.433283] usb usb4: usb auto-resume
[   15.433292] usb usb4: wakeup_rh
[   15.472261] hub 4-0:1.0: hub_resume
[   15.472346] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.472477] usb usb3: usb auto-resume
[   15.472483] usb usb3: wakeup_rh
[   15.512099] hub 3-0:1.0: hub_resume
[   15.512179] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.512425] usbfs 1-1.2.2:1.0: disconnect by usbfs
[   15.512448] usb 1-1.2.2: usbfs: process 3761 (hid2hci) did not claim interface 0 before use
[   15.545431] Bluetooth: RFCOMM socket layer initialized
[   15.545438] Bluetooth: RFCOMM ver 1.10
[   16.520278] usb usb8: suspend_rh (auto-stop)
[   16.520315] usb usb7: suspend_rh (auto-stop)
[   16.520347] usb usb6: suspend_rh (auto-stop)
[   16.520378] usb usb4: suspend_rh (auto-stop)
[   16.520408] usb usb3: suspend_rh (auto-stop)
[   17.061272] hdparm used greatest stack depth: 3440 bytes left
[   17.804125] hub 8-0:1.0: hub_suspend
[   17.804143] usb usb8: bus auto-suspend
[   17.804149] usb usb8: suspend_rh
[   17.804173] hub 7-0:1.0: hub_suspend
[   17.804180] usb usb7: bus auto-suspend
[   17.804184] usb usb7: suspend_rh
[   17.804205] hub 6-0:1.0: hub_suspend
[   17.804211] usb usb6: bus auto-suspend
[   17.804215] usb usb6: suspend_rh
[   17.804235] hub 4-0:1.0: hub_suspend
[   17.804241] usb usb4: bus auto-suspend
[   17.804245] usb usb4: suspend_rh
[   17.804265] hub 3-0:1.0: hub_suspend
[   17.804272] usb usb3: bus auto-suspend
[   17.804275] usb usb3: suspend_rh
[   17.816104] hub 2-0:1.0: hub_suspend
[   17.816119] usb usb2: bus auto-suspend
[   17.816125] ehci_hcd 0000:00:1d.7: suspend root hub
[   18.641268] [drm:i915_initialize] *ERROR* can not ioremap virtual address for ring buffer
[   18.658686] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[   19.704083] e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
[   19.776003] e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
[   19.780371] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   19.781554] iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   19.791784] iwlagn 0000:0c:00.0: restoring config space at offset 0x1 (was 0x100102, writing 0x100106)
[   19.799675] iwlagn 0000:0c:00.0: irq 31 for MSI/MSI-X
[   19.804116] iwlagn 0000:0c:00.0: firmware: requesting iwlwifi-5000-1.ucode
[   19.851544] iwlagn loaded firmware version 5.4.1.16
[   20.006620] Registered led device: iwl-phy0:radio
[   20.006634] Registered led device: iwl-phy0:assoc
[   20.006646] Registered led device: iwl-phy0:RX
[   20.006658] Registered led device: iwl-phy0:TX
[   20.093035] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   20.374672] Xorg:3847 conflicting memory types e0000000-f0000000 uncached-minus<->write-combining
[   20.374680] reserve_memtype failed 0xe0000000-0xf0000000, track uncached-minus, req uncached-minus
[   21.190663] Xorg:3847 conflicting memory types e0000000-f0000000 uncached-minus<->write-combining
[   21.190671] reserve_memtype failed 0xe0000000-0xf0000000, track uncached-minus, req uncached-minus
[   21.483382] Xorg:3847 conflicting memory types e0000000-f0000000 uncached-minus<->write-combining
[   21.483391] reserve_memtype failed 0xe0000000-0xf0000000, track uncached-minus, req uncached-minus
[   21.627705] wlan0: authenticate with AP 00:0b:0e:72:ec:41
[   21.825262] wlan0: authenticate with AP 00:0b:0e:72:ec:41
[   21.826050] wlan0: authenticated
[   21.826059] wlan0: associate with AP 00:0b:0e:72:ec:41
[   21.828889] wlan0: RX AssocResp from 00:0b:0e:72:ec:41 (capab=0x401 status=0 aid=6)
[   21.828897] wlan0: associated
[   21.833979] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   21.834183] wlan0: disassociating by local choice (reason=3)
[   32.576241] wlan0: no IPv6 routers present
[   47.494953] sort used greatest stack depth: 3280 bytes left
[   51.805229] wlan0: authenticate with AP 00:0b:0e:72:ec:41
[   51.805855] wlan0: authenticated
[   51.805861] wlan0: associate with AP 00:0b:0e:72:ec:41
[   51.807825] wlan0: RX ReassocResp from 00:0b:0e:72:ec:41 (capab=0x401 status=0 aid=6)
[   51.807832] wlan0: associated
[   51.813521] cfg80211: Calling CRDA for country: US
[  115.964652] usb usb2: usb auto-resume
[  115.964663] ehci_hcd 0000:00:1d.7: resume root hub
[  115.992270] hub 2-0:1.0: hub_resume
[  115.992372] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[  115.992531] usb usb8: usb auto-resume
[  115.992537] usb usb8: wakeup_rh
[  116.032063] hub 8-0:1.0: hub_resume
[  116.032142] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  116.032275] usb usb7: usb auto-resume
[  116.032281] usb usb7: wakeup_rh
[  116.072081] hub 7-0:1.0: hub_resume
[  116.072164] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  116.072296] usb usb6: usb auto-resume
[  116.072302] usb usb6: wakeup_rh
[  116.112276] hub 6-0:1.0: hub_resume
[  116.112364] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  116.113853] usb usb4: usb auto-resume
[  116.113862] usb usb4: wakeup_rh
[  116.152268] hub 4-0:1.0: hub_resume
[  116.152352] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  116.152492] usb usb3: usb auto-resume
[  116.152499] usb usb3: wakeup_rh
[  116.192115] hub 3-0:1.0: hub_resume
[  116.192202] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  117.208101] usb usb8: suspend_rh (auto-stop)
[  117.208138] usb usb7: suspend_rh (auto-stop)
[  117.208169] usb usb6: suspend_rh (auto-stop)
[  117.208200] usb usb4: suspend_rh (auto-stop)
[  117.208230] usb usb3: suspend_rh (auto-stop)
[  118.805280] hub 8-0:1.0: hub_suspend
[  118.805297] usb usb8: bus auto-suspend
[  118.805303] usb usb8: suspend_rh
[  118.805327] hub 7-0:1.0: hub_suspend
[  118.805333] usb usb7: bus auto-suspend
[  118.805337] usb usb7: suspend_rh
[  118.805358] hub 6-0:1.0: hub_suspend
[  118.805365] usb usb6: bus auto-suspend
[  118.805369] usb usb6: suspend_rh
[  118.805390] hub 4-0:1.0: hub_suspend
[  118.805397] usb usb4: bus auto-suspend
[  118.805401] usb usb4: suspend_rh
[  118.805422] hub 3-0:1.0: hub_suspend
[  118.805428] usb usb3: bus auto-suspend
[  118.805432] usb usb3: suspend_rh
[  118.820099] hub 2-0:1.0: hub_suspend
[  118.820117] usb usb2: bus auto-suspend
[  118.820122] ehci_hcd 0000:00:1d.7: suspend root hub
[  118.850508] usb usb2: usb auto-resume
[  118.850519] ehci_hcd 0000:00:1d.7: resume root hub
[  118.880259] hub 2-0:1.0: hub_resume
[  118.880353] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[  118.880565] usb usb8: usb auto-resume
[  118.880573] usb usb8: wakeup_rh
[  118.916080] hub 8-0:1.0: hub_resume
[  118.916165] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  118.916312] usb usb7: usb auto-resume
[  118.916318] usb usb7: wakeup_rh
[  118.956274] hub 7-0:1.0: hub_resume
[  118.956366] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  118.956536] usb usb6: usb auto-resume
[  118.956543] usb usb6: wakeup_rh
[  118.996104] hub 6-0:1.0: hub_resume
[  118.996181] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  118.997198] usb usb4: usb auto-resume
[  118.997206] usb usb4: wakeup_rh
[  119.036105] hub 4-0:1.0: hub_resume
[  119.036186] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  119.036326] usb usb3: usb auto-resume
[  119.036332] usb usb3: wakeup_rh
[  119.078869] hub 3-0:1.0: hub_resume
[  119.079412] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  119.931001] jockey-gtk used greatest stack depth: 3184 bytes left
[  119.936089] usb usb8: suspend_rh (auto-stop)
[  120.184102] usb usb7: suspend_rh (auto-stop)
[  120.184138] usb usb6: suspend_rh (auto-stop)
[  120.184170] usb usb4: suspend_rh (auto-stop)
[  120.184201] usb usb3: suspend_rh (auto-stop)
[  121.805067] hub 8-0:1.0: hub_suspend
[  121.805085] usb usb8: bus auto-suspend
[  121.805090] usb usb8: suspend_rh
[  121.805114] hub 7-0:1.0: hub_suspend
[  121.805121] usb usb7: bus auto-suspend
[  121.805125] usb usb7: suspend_rh
[  121.805146] hub 6-0:1.0: hub_suspend
[  121.805152] usb usb6: bus auto-suspend
[  121.805156] usb usb6: suspend_rh
[  121.805177] hub 4-0:1.0: hub_suspend
[  121.805184] usb usb4: bus auto-suspend
[  121.805188] usb usb4: suspend_rh
[  121.805210] hub 3-0:1.0: hub_suspend
[  121.805216] usb usb3: bus auto-suspend
[  121.805220] usb usb3: suspend_rh
[  121.816081] hub 2-0:1.0: hub_suspend
[  121.816095] usb usb2: bus auto-suspend
[  121.816100] ehci_hcd 0000:00:1d.7: suspend root hub

-andy
