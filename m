Return-Path: <linux-kernel-owner+w=401wt.eu-S1759672AbZBYOnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672AbZBYOnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 09:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbZBYOm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 09:42:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60412 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbZBYOm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:42:58 -0500
Message-ID: <49A55742.5030104@redhat.com>
Date: Wed, 25 Feb 2009 15:35:46 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: Yinghai Lu <yinghai@kernel.org>, Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lenb@kernel.org" <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       mjg@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       rui.zhang@intel.com, airlied@redhat.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not
 ioremap virtual address for G33 hw status page
References: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com> <1235419343.4816.27.camel@gaiman> <200902232230.29501.rjw@sisk.pl> <8db1092f0902231340k7c7d0fd1me49302f2efd03491@mail.gmail.com> <86802c440902231701q1e169a67oa12bd84ac0e4c7aa@mail.gmail.com> <20090224032304.GA26344@hexapodia.org> <86802c440902232150m2b22e3cfg8993193f8867dfbf@mail.gmail.com> <20090224064830.GA12600@hexapodia.org> <20090224225424.GB12600@hexapodia.org>
In-Reply-To: <20090224225424.GB12600@hexapodia.org>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Isaacson napsal(a):
> On Mon, Feb 23, 2009 at 10:48:30PM -0800, Andy Isaacson wrote:
>> On Mon, Feb 23, 2009 at 09:50:03PM -0800, Yinghai Lu wrote:
>>>> reg 0, base: 0GB, range: 32GB, type WB
>>>> reg 1, base: 3584MB, range: 512MB, type UC
>>>> reg 2, base: 2012MB, range: 4MB, type UC
>>>> reg 3, base: 2016MB, range: 32MB, type UC
>>> the BIOS is so sick
>>> according to MTRR, it said:
>>> [0,2012M) is WB
>>> [2048M, 3.5G) is WB too
>>> [4G, 32G) is WB
>>>
>>> but according to e820: about [0,2g) is RAM...
>>>
>>> really not how to workaround in BIOS.
>>>
>>> please check if you have some new BIOS?
>> That was with bios A11.  There is an A12 available on dell.com, I'll try
>> installing it tomorrow...
> 
> With BIOS A12 2.6.29-rc6 still fails to initialize Xorg, but I think the
> failure is different -- Xorg.0.log says:
> 


Unsure if my configuration is similar to some else.

My machine is T61 - 4GB and I've these things in my log:
(I'm using the latest BIOS for this Lenovo machine 2.25)
Running latest Fedora rawhide Xorg - it might be that Ubuntu Xorg doesn't show 
this problem ??


[    0.000000] DMI present.
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x100000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 3GB, range: 1GB, type UC
[    0.000000] reg 1, base: 5056MB, range: 64MB, type UC
[    0.000000] reg 2, base: 0GB, range: 4GB, type WB
[    0.000000] reg 3, base: 4GB, range: 1GB, type WB
[    0.000000] reg 4, base: 3063MB, range: 1MB, type UC
[    0.000000] reg 5, base: 3064MB, range: 8MB, type UC
[    0.000000] total RAM coverred: 4023M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K  chunk_size: 128M        num_reg: 6      lose 
cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3063MB, range: 1MB, type UC
[    0.000000] reg 3, base: 3064MB, range: 8MB, type UC
[    0.000000] reg 4, base: 4GB, range: 1GB, type WB
[    0.000000] reg 5, base: 5056MB, range: 64MB, type UC
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbf6b0 max_arch_pfn = 0x100000000
[    0.000000] Scanning 2 areas for low memory corruption
[    0.000000] modified physical RAM map:
...
[  104.509490] X:2865 conflicting memory types e0000000-f0000000 
uncached-minus<->write-combining
[  104.509495] reserve_memtype failed 0xe0000000-0xf0000000, track 
uncached-minus, req uncached-minus
[  105.511870] X:2865 conflicting memory types e0000000-f0000000 
uncached-minus<->write-combining
[  105.511874] reserve_memtype failed 0xe0000000-0xf0000000, track 
uncached-minus, req uncached-minus
[  105.666438] X:2865 conflicting memory types e0000000-f0000000 
uncached-minus<->write-combining
[  105.666448] reserve_memtype failed 0xe0000000-0xf0000000, track 
uncached-minus, req uncached-minus
[  105.905061] X:2865 conflicting memory types e0000000-f0000000 
uncached-minus<->write-combining
[  105.905065] reserve_memtype failed 0xe0000000-0xf0000000, track 
uncached-minus, req uncached-minus
[  105.918004] X:2911 freeing invalid memtype e0000000-f0000000
[  106.051774] X:2865 conflicting memory types e0000000-f0000000 
uncached-minus<->write-combining
[  106.051784] reserve_memtype failed 0xe0000000-0xf0000000, track 
uncached-minus, req uncached-minus
[  106.089265] X:2912 freeing invalid memtype e0000000-f0000000
...
[  284.662145] [drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU 
list empty
[  284.662160] [drm:i915_gem_object_pin] *ERROR* Failure to bind: 
-12<3>[drm:i915_gem_evict_something] *ERROR* inactive empty 1 request e
mpty 1 flushing empty 1
[  331.744678] [drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU 
list empty
[  331.744690] [drm:i915_gem_object_pin] *ERROR* Failure to bind: 
-12<3>[drm:i915_gem_evict_something] *ERROR* inactive empty 1 request e
mpty 1 flushing empty 1
[  360.904121] [drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU 
list empty
[  360.904174] [drm:i915_gem_object_pin] *ERROR* Failure to bind: 
-12<3>[drm:i915_gem_evict_something] *ERROR* inactive empty 1 request e
mpty 1 flushing empty 1



cat /proc/mtrr
  cat /proc/mtrr
reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
reg02: base=0x0bf700000 ( 3063MB), size=    1MB, count=1: uncachable
reg03: base=0x0bf800000 ( 3064MB), size=    8MB, count=1: uncachable
reg04: base=0x100000000 ( 4096MB), size= 1024MB, count=1: write-back
reg05: base=0x13c000000 ( 5056MB), size=   64MB, count=1: uncachable
reg06: base=0x0e0000000 ( 3584MB), size=  256MB, count=2: write-combining


.config for 2.6.29-rc6 f7e603ad8f78cd3b59e33fa72707da0cbabdf699
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1


Zdenek
