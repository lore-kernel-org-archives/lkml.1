Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbZETIEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbZETIEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZETIDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:03:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35551 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbZETIDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:03:46 -0400
Message-ID: <4A13B8E9.9060703@redhat.com>
Date: Wed, 20 May 2009 10:01:45 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Beulich <JBeulich@novell.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Xen-devel] Re: [GIT PULL] xen /proc/mtrr implementation
References: <20090519095918.GA11790@elte.hu> <4A12A46A02000078000017E1@vpn.id2.novell.com> <20090519110837.GA10548@elte.hu> <4A12A05C.6050004@redhat.com> <20090519122623.GD14305@elte.hu> <4A12B244.8070301@redhat.com> <20090519133138.GA8410@elte.hu> <4A12B97C.9040706@redhat.com> <20090519141708.GA6008@elte.hu> <4A12C84A.5070100@redhat.com> <20090519152456.GB21271@elte.hu>
In-Reply-To: <20090519152456.GB21271@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/09 17:24, Ingo Molnar wrote:
> the Xen hypervisor can simply repeat all requests (i.e. not care at
> all about the fact that a guest does these modifications on all CPUs
> it sees), or realize that the modification has already been done and
> skip it.

Could be done, yes.  It still feels wrong that wrmsr(mtrr) works 
slightly different on xen and on native.  And it wouldn't work on 
existing Xen deployments as the Xen hypervisor doesn't support that today.

>>>>> Yeah, the third one is to not touch MTRRs after bootup and use PAT.

> That's a really old CPU, but even Coppermine has PAT support in the
> CPU. You need to go back to things like P5 200 MHz CPUs to find
> PAT-less CPUs.

Linux shouln't say "PAT not supported by CPU." then.

Also it doesn't make sense to me to handle things differently on native 
and xen.  While it might make sense to deprecate mtrrs in favor of PAT 
(don't know enougth about all the different cpus in the wild to justify 
that) I don't think it makes sense to do that for xen only.  Native 
should declare mtrrs obsolete as well.

cheers,
   Gerd

