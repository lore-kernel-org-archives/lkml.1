Return-Path: <linux-kernel-owner+w=401wt.eu-S1764097AbYCDMHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764097AbYCDMHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762411AbYCDMHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:07:42 -0500
Received: from ozlabs.org ([203.10.76.45]:40383 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762397AbYCDMHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:07:41 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG + PATCH/Bugfix] x86/lguest: fix pgdir pmd index calculation
Date: Tue, 4 Mar 2008 23:06:57 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       lguest@ozlabs.org, akpm <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
References: <20080224155515.GA24831@ubuntu> <20080229003224.GA18821@ubuntu> <20080229195838.GB21494@elte.hu>
In-Reply-To: <20080229195838.GB21494@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803042306.58400.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 March 2008 06:58:38 Ingo Molnar wrote:
> * Ahmed S. Darwish <darwish.07@gmail.com> wrote:
> > On the lguest _guest_ side, 'cpu_has_tsc' is _always_ false (due to
> > lguest using his own clocksource ?), thus a guest with a pentium+ cpu
> > always panics with:
>
> does the "RDTSC" instruction work in an lguest guest? If not, then the
> lguest kernel is correct in not exposing it - and then the solution is
> to build a non-TSC guest kernel. Does the patch below help?
>
> but if the RDTSC instruction does work in an lguest guest, then the
> proper approach would be to expose it in the CPU features.

Yes, and after some investigation, I came up with two patches.  I'll queue 
both to you if that's ok, since they're dependent.

When lguest was being developed we didn't have a get_tsc_khz hook, so I had to 
kill the TSC cpuid bit.  Nowdays, the code can actually be much more natural: 
the Host tells us the cpu khz, and if it's zero, we fall back to the 
dumb "lguest" clock.

Thanks,
Rusty.
