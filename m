Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbZBQXVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbZBQXVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbZBQXUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:20:53 -0500
Received: from smtp2.ono.com ([62.42.230.20]:19780 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753175AbZBQXUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:20:53 -0500
Date: Wed, 18 Feb 2009 00:20:46 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Intel driver vs MTRRs conflict
Message-ID: <20090218002046.55c17814@werewolf.home>
X-Mailer: Claws Mail 3.7.0cvs67 (GTK+ 2.15.3; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

I have a little problem (near religious, not real, as averything works fine)
with the intel driver crying about mtrrs:

[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
[drm] Initialized i915 1.6.0 20080730 on minor 0
X:3004 conflicting memory types 20000000-30000000 write-combining<->uncached-minus
reserve_memtype failed 0x20000000-0x30000000, track write-combining, req write-combining
X:3004 conflicting memory types 20000000-30000000 write-combining<->uncached-minus
reserve_memtype failed 0x20000000-0x30000000, track write-combining, req write-combining
X:3004 conflicting memory types 20000000-30000000 write-combining<->uncached-minus
reserve_memtype failed 0x20000000-0x30000000, track write-combining, req write-combining
X:3031 freeing invalid memtype 20000000-30000000
X:3004 conflicting memory types 20000000-30000000 write-combining<->uncached-minus
reserve_memtype failed 0x20000000-0x30000000, track write-combining, req write-combining
X:3032 freeing invalid memtype 20000000-30000000
X:3004 conflicting memory types 20000000-30000000 write-combining<->uncached-minus
reserve_memtype failed 0x20000000-0x30000000, track write-combining, req write-combining
X:3033 freeing invalid memtype 20000000-30000000
X:3004 conflicting memory types 20000000-30000000 write-combining<->uncached-minus
reserve_memtype failed 0x20000000-0x30000000, track write-combining, req write-combining
X:3034 freeing invalid memtype 20000000-30000000

But that mtrr is there:

one:~# cat /proc/mtrr
reg00: base=0x000000000 (    0MB), size=  512MB, count=1: write-back
reg01: base=0x01f500000 (  501MB), size=    1MB, count=1: uncachable
reg02: base=0x01f600000 (  502MB), size=    2MB, count=1: uncachable
reg03: base=0x01f800000 (  504MB), size=    8MB, count=1: uncachable
reg04: base=0x020000000 (  512MB), size=  256MB, count=1: write-combining

Where is the problem ? Kernel or driver side ?
This logs are with kernel 2.6.29-rc5, and intel driver 2.6.1.

As I said, everything works. And even fast for the kind of machine, it's an
Aspire One and gears gives 740 fps, and video playback is pretty smooth.
But perhaps it would be faster if X could get that mtrr it claims ?

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.1 (Cooker) for x86_64
Linux 2.6.28.2-desktop-1mnb (gcc 4.3.2 (GCC) #1 Wed Jan
