Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352AbZJZWzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbZJZWzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbZJZWzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:55:21 -0400
Received: from claw.goop.org ([74.207.240.146]:43354 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbZJZWzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:55:20 -0400
Message-ID: <4AE628DB.5010305@goop.org>
Date: Mon, 26 Oct 2009 15:55:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.32-rc not booting with Xen-3.2 (bisected)
References: <alpine.DEB.2.01.0910261445170.9408@bogon.housecafe.de> <alpine.DEB.2.01.0910261513520.9408@bogon.housecafe.de>
In-Reply-To: <alpine.DEB.2.01.0910261513520.9408@bogon.housecafe.de>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/09 15:17, Christian Kujau wrote:
> On Mon, 26 Oct 2009 at 15:02, Christian Kujau wrote:
>   
>> really know where the DomU stops (or panics). However, I was able to 
>> bisect it, I hope the bisection makes any sense:
>>     
> My bisection was one iteration short, here's the full one, which confirms 
> my suspicion of 78f28b7c555359c67c2a0d23f7436e915329421e being the 
> culprit:
>   

Yes, that is indeed a likely suspect.  Is Xen compiled with DEBUG=y? 
Does anything appear on the Xen console (xm dmesg)?

    J

> domU$ git bisect start
> # good: [74fca6a42863ffacaf7ba6f1936a9f228950f657] Linux 2.6.31
> git bisect good 74fca6a42863ffacaf7ba6f1936a9f228950f657
> # bad: [17d857be649a21ca90008c6dc425d849fa83db5c] Linux 2.6.32-rc1
> git bisect bad 17d857be649a21ca90008c6dc425d849fa83db5c
> # good: [5d1fe0c98f2aef99fb57aaf6dd25e793c186cea3] Staging: vt6656: Integrate vt6656 into build system.
> git bisect good 5d1fe0c98f2aef99fb57aaf6dd25e793c186cea3
> # bad: [c720f5655df159a630fa0290a0bd67c93e92b0bf] Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6
> git bisect bad c720f5655df159a630fa0290a0bd67c93e92b0bf
> # good: [a03fdb7612874834d6847107198712d18b5242c7] Merge branch 'timers-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
> git bisect good a03fdb7612874834d6847107198712d18b5242c7
> # good: [3530c1886291df061e3972c55590777ef1cb67f8] Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
> git bisect good 3530c1886291df061e3972c55590777ef1cb67f8
> # bad: [84d6ae431f315e8973aac3c3fe1d550fc9240ef3] V4L/DVB (13033): pt1: Don't use a deprecated DMA_BIT_MASK macro
> git bisect bad 84d6ae431f315e8973aac3c3fe1d550fc9240ef3
> # bad: [068ed40b8fc14cd3d16b5cf2db59ecd735a68ca8] V4L/DVB (12939): SAA7164: Removed a duplicate call to address any PCI quirks.
> git bisect bad 068ed40b8fc14cd3d16b5cf2db59ecd735a68ca8
> # bad: [f4e96deb4513d044653027d4921fd7592195503a] V4L/DVB (12756): af9015: fix typo in register compare
> git bisect bad f4e96deb4513d044653027d4921fd7592195503a
> # good: [dd0a70c8f921708eba29ef9f30dde1f14a74af05] x86: Move tsc_init to late_time_init
> git bisect good dd0a70c8f921708eba29ef9f30dde1f14a74af05
> # bad: [53e712d0844e99b8d8720327470b86ef401fb727] V4L/DVB (12734): cx25821: Fix some compilation troubles
> git bisect bad 53e712d0844e99b8d8720327470b86ef401fb727
> # good: [7bd867dfb4e0357e06a3211ab2bd0e714110def3] x86: Move get/set_wallclock to x86_platform_ops
> git bisect good 7bd867dfb4e0357e06a3211ab2bd0e714110def3
> # bad: [78f28b7c555359c67c2a0d23f7436e915329421e] Merge branch 'x86-platform-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
> git bisect bad 78f28b7c555359c67c2a0d23f7436e915329421e
> # good: [9c88b25bcfde51eccf2cca13d933a2948d0ca4eb] frv: clean up linker script using new linker script macros.
> git bisect good 9c88b25bcfde51eccf2cca13d933a2948d0ca4eb
> # good: [3240a77b515f4a15e24d8a3a2135bc87b02cf1d6] sparc: Clean up linker script using new linker script macros.
> git bisect good 3240a77b515f4a15e24d8a3a2135bc87b02cf1d6
>
>
>   
>> Version numbers and more for both the domU and dom0 are on:
>> http://nerdbynature.de/bits/2.6.32/dom0/dpkg-l.txt
>>     
> That should read: http://nerdbynature.de/bits/2.6.32/
>
> Thanks,
> Christian.
>   

