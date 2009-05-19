Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbZESP0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbZESP0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 11:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZESP0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 11:26:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36461 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbZESP0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 11:26:11 -0400
Date: Tue, 19 May 2009 17:24:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Jan Beulich <JBeulich@novell.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Xen-devel] Re: [GIT PULL] xen /proc/mtrr implementation
Message-ID: <20090519152456.GB21271@elte.hu>
References: <20090519095918.GA11790@elte.hu> <4A12A46A02000078000017E1@vpn.id2.novell.com> <20090519110837.GA10548@elte.hu> <4A12A05C.6050004@redhat.com> <20090519122623.GD14305@elte.hu> <4A12B244.8070301@redhat.com> <20090519133138.GA8410@elte.hu> <4A12B97C.9040706@redhat.com> <20090519141708.GA6008@elte.hu> <4A12C84A.5070100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A12C84A.5070100@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Gerd Hoffmann <kraxel@redhat.com> wrote:

>>>>> No, the linux kernel probably should do the wrmsr on one cpu only then.
>>>> Why?
>
>> | The change of MTRR's on _any_ of the guest CPUs in a dom0 context
>> | should immediately be refected on all CPUs. Assymetric MTRR
>> | settings are madness.
>
> Exactly.  And thats why it is pointless to let the dom0 kernel 
> write the mtrr msrs on more than one cpu.

How does this negate my claim that the Linux kernel needs no 
modifications? (which i think your point is - let me know if you 
have some other point here.)

the Xen hypervisor can simply repeat all requests (i.e. not care at 
all about the fact that a guest does these modifications on all CPUs 
it sees), or realize that the modification has already been done and 
skip it. This is in no way a performance sensitive codepath - mtrrs 
are only modified in init sequences - and setting mtrrs is slow and 
globally serialized to begin with.

>>>>> Oops, the third "proper technical solutions" is missing.
>>>> Yeah, the third one is to not touch MTRRs after bootup and use PAT.
>>> Works only in case the CPU has PAT support.
>>
>> Which specific CPU without PAT support do you worry about?
>
> For example: I have a Notebook here, with MTRR and without PAT 
> according to the boot log.  "Pentium III (Coppermine)" says 
> /proc/cpuinfo.

That's a really old CPU, but even Coppermine has PAT support in the 
CPU. You need to go back to things like P5 200 MHz CPUs to find 
PAT-less CPUs.

On the Linux side it's easy to enable it (and _such_ a patch would 
make sense indeed) - it's just that nobody has yet gone through the 
effort of testing and validating the PAT code on that CPU. If you 
care enough, you can do it, send a patch and ping the Intel folks 
about it.

Once the issues are framed correctly, Linux is helped for real.

	Ingo
