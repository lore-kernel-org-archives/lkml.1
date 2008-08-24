Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbYHXSQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbYHXSQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 14:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYHXSQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 14:16:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55206 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbYHXSQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 14:16:31 -0400
Date: Sun, 24 Aug 2008 14:13:04 -0400
From: Dave Jones <davej@redhat.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123
	send_IPI_mask_bitmask+0xc3/0xe0()
Message-ID: <20080824181304.GA5963@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	"H. Peter Anvin" <hpa@kernel.org>, Andi Kleen <andi@firstfloor.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Rusty Russell <rusty@rustcorp.com.au>
References: <19f34abd0808191251x4eb61c50n13ecf7c90f0f3d9f@mail.gmail.com> <20080820013930.GN9807@one.firstfloor.org> <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com> <20080822003659.GA7581@redhat.com> <48AE20B8.9000204@kernel.org> <19f34abd0808240220v77bcdd5di32f8f865b18fc49f@mail.gmail.com> <48B19799.6090703@kernel.org> <19f34abd0808241022j1ab6f3e6qd72b9acba5df4892@mail.gmail.com> <19f34abd0808241045r37eb8661h3cc688b6f0513777@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808241045r37eb8661h3cc688b6f0513777@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 07:45:48PM +0200, Vegard Nossum wrote:
 > Removing acpi=off helps with the CPU detection problem. The kernel is
 > still really slow, though. From /proc/cpuinfo:
 > 
 > processor       : 1
 > vendor_id       : GenuineIntel
 > cpu family      : 15
 > model           : 6
 > model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
 > stepping        : 5
 > cpu MHz         : 375.000
 > cache size      : 2048 KB
 > 
 > Why is MHz on 375!? I tried cpufreq-selector, but nothing changed. Maybe
 > 
 > calling  acpi_cpufreq_init+0x0/0x90
 > initcall acpi_cpufreq_init+0x0/0x90 returned -19 after 0 msecs

-ENODEV.  Because you don't have frequency scaling capable CPU.

 > Okay, now I used cpufreq-selector to change to "ondemand" governor,
 > and MHz goes back to 3000. Weird. Why would "performance" governor put
 > my machine to a constant 375?
 
Probably because you're using p4-clockmod, and it's crap.

	Dave

-- 
http://www.codemonkey.org.uk
