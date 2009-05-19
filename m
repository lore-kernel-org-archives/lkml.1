Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbZESO5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbZESO5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 10:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZESO46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 10:56:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39659 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbZESO46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 10:56:58 -0400
Message-ID: <4A12C84A.5070100@redhat.com>
Date: Tue, 19 May 2009 16:55:06 +0200
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
References: <20090518085902.GE10687@elte.hu> <4A11A3F8.1010202@goop.org> <20090519095918.GA11790@elte.hu> <4A12A46A02000078000017E1@vpn.id2.novell.com> <20090519110837.GA10548@elte.hu> <4A12A05C.6050004@redhat.com> <20090519122623.GD14305@elte.hu> <4A12B244.8070301@redhat.com> <20090519133138.GA8410@elte.hu> <4A12B97C.9040706@redhat.com> <20090519141708.GA6008@elte.hu>
In-Reply-To: <20090519141708.GA6008@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> No, the linux kernel probably should do the wrmsr on one cpu only then.
>>> Why?

> | The change of MTRR's on _any_ of the guest CPUs in a dom0 context
> | should immediately be refected on all CPUs. Assymetric MTRR
> | settings are madness.

Exactly.  And thats why it is pointless to let the dom0 kernel write the 
mtrr msrs on more than one cpu.

>>>> Oops, the third "proper technical solutions" is missing.
>>> Yeah, the third one is to not touch MTRRs after bootup and use PAT.
>> Works only in case the CPU has PAT support.
>
> Which specific CPU without PAT support do you worry about?

For example:  I have a Notebook here, with MTRR and without PAT 
according to the boot log.  "Pentium III (Coppermine)" says /proc/cpuinfo.

cheers,
   Gerd
