Return-Path: <linux-kernel-owner+w=401wt.eu-S1030546AbXBLX7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030546AbXBLX7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030562AbXBLX7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:59:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030555AbXBLX7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:59:18 -0500
Date: Mon, 12 Feb 2007 18:59:07 -0500
From: Dave Jones <davej@redhat.com>
To: Simon Arlott <6bc04bda904655a1b91hgkso0000m4ev@thunder.lp0.eu>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Mark de Vries <mark@asphyx.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Which CPU for VIA C7/Esther?
Message-ID: <20070212235907.GC13573@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Simon Arlott <6bc04bda904655a1b91hgkso0000m4ev@thunder.lp0.eu>,
	Kyle McMartin <kyle@mcmartin.ca>, Mark de Vries <mark@asphyx.net>,
	linux-kernel@vger.kernel.org
References: <1171301858.3557.6.camel@localhost> <20070212191441.GB20686@athena.road.mcmartin.ca> <20070212201635.GD10697@redhat.com> <45D0FC66.5030205@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D0FC66.5030205@simon.arlott.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 11:46:46PM +0000, Simon Arlott wrote:

 > MVIAC3_2 doesn't enable X86_GOOD_APIC

which is pretty irrelevant unless you have a dual C7.

 > , try M686 (Pentium-Pro) - but that won't enable MMX and SSE (via -march=c3-2).

If gcc generated SSE/MMX instructions that would be a bug. (hint: it doesn't).

 > These CPUs support SSE2 too... 

The SSE/SSE2/SSE3 etc support for userspace is unconditional. The context switch paths will
save/restore the registers regardless of the CPU you've compiled your kernel for.
The only SSE code in the kernel is the memcpy code (which wasn't that big a win when
I last tried it on VIA due to their poor memory bandwidth), and the RAID code, which
gets tested at runtime rather than compile time.

 > Also, for the C7 you'll want CRYPTO_DEV_PADLOCK_* (Hardware Crypto Devices, Support for VIA PadLock ACE) and HW_RANDOM_VIA (VIA HW Random Number Generator support).

Yes. But these aren't dependant on any CPU config options.

		Dave

-- 
http://www.codemonkey.org.uk
