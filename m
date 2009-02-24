Return-Path: <linux-kernel-owner+w=401wt.eu-S1760580AbZBXVkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760580AbZBXVkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 16:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758977AbZBXVjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 16:39:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45932 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757642AbZBXVjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 16:39:49 -0500
Date: Tue, 24 Feb 2009 22:39:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Andy Isaacson <adi@hexapodia.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lenb@kernel.org" <lenb@kernel.org>, mjg@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, rui.zhang@intel.com,
       airlied@redhat.com
Subject: Re: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not
	ioremap virtual address for G33 hw status page
Message-ID: <20090224213907.GA12601@elte.hu>
References: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com> <1235419343.4816.27.camel@gaiman> <200902232230.29501.rjw@sisk.pl> <8db1092f0902231340k7c7d0fd1me49302f2efd03491@mail.gmail.com> <86802c440902231701q1e169a67oa12bd84ac0e4c7aa@mail.gmail.com> <20090224032304.GA26344@hexapodia.org> <86802c440902232150m2b22e3cfg8993193f8867dfbf@mail.gmail.com> <20090224194432.GB28772@elte.hu> <49A44F0F.4060105@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A44F0F.4060105@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Ingo Molnar wrote:
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> On Mon, Feb 23, 2009 at 7:23 PM, Andy Isaacson <adi@hexapodia.org> wrote:
> >>> On Mon, Feb 23, 2009 at 05:01:10PM -0800, Yinghai Lu wrote:
> >>>> CONFIG_MTRR=y
> >>>> CONFIG_MTRR_SANITIZER=y
> >>>> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> >>>> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> >>>>
> >>>> should help mtrr ones.
> >>>>
> >>>> please post bootlog with those option set.
> >>> Doesn't help here (Dell E6400).
> >>>
> >>> [    0.000000] Initializing cgroup subsys cpuset
> >>> [    0.000000] Initializing cgroup subsys cpu
> >>> [    0.000000] Linux version 2.6.29-rc6-dirty (adi@cvp-loaner-01) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu12) ) #14 SMP Mon Feb 23 19:05:31 PST 2009
> >>> [    0.000000] Command line: root=/dev/sda1 ro
> >>> [    0.000000] KERNEL supported cpus:
> >>> [    0.000000]   Intel GenuineIntel
> >>> [    0.000000]   AMD AuthenticAMD
> >>> [    0.000000]   Centaur CentaurHauls
> >>> [    0.000000] BIOS-provided physical RAM map:
> >>> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
> >>> [    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
> >>> [    0.000000]  BIOS-e820: 0000000000100000 - 000000007d04d400 (usable)
> >>> [    0.000000]  BIOS-e820: 000000007d04d400 - 000000007d04f400 (ACPI NVS)
> >>> [    0.000000]  BIOS-e820: 000000007d04f400 - 0000000080000000 (reserved)
> >>> [    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
> >>> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
> >>> [    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
> >>> [    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
> >>> [    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
> >>> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
> >>> [    0.000000]  BIOS-e820: 00000000ffe60000 - 0000000100000000 (reserved)
> >>> [    0.000000] DMI 2.4 present.
> >>> [    0.000000] last_pfn = 0x7d04d max_arch_pfn = 0x100000000
> >>> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> >>> [    0.000000] original variable MTRRs
> >>> [    0.000000] reg 0, base: 0GB, range: 32GB, type WB
> >>> [    0.000000] reg 1, base: 3584MB, range: 512MB, type UC
> >>> [    0.000000] reg 2, base: 2012MB, range: 4MB, type UC
> >>> [    0.000000] reg 3, base: 2016MB, range: 32MB, type UC
> >> the BIOS is so sick
> >> according to MTRR, it said:
> >> [0,2012M) is WB
> >> [2048M, 3.5G) is WB too
> >> [4G, 32G) is WB
> >>
> >> but according to e820: about [0,2g) is RAM...
> >>
> >> really not how to workaround in BIOS.
> > 
> > I suspect the box was tested with other OSs and limped along 
> > there. Should we perhaps clear non-sensical MTRR entries?
> > 
> 
> according to e820 to update MTRR?
> 
> in the previous discussion, some SMI region that is not stated 
> in e820 could still need to be covered by MTRR with WB

Indeed. Nasty. Those tend to be in pretty specific places 
though, typically next to RAM. (they are taken off RAM usually) 
So if we leave the boundary around real e820 RAM alone, we could 
zap the other bogosities perhaps?

Dunno, removing MTRRs does indeed sound somewhat dangerous. A WB 
MTRR region could also be defined for some PCI card.

The other question is, why did the ioremap_wc() fail? Why doesnt 
it fall back to UC transparently?

	Ingo
