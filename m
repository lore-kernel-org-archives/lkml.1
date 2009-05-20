Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbZETQM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbZETQM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 12:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754414AbZETQMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 12:12:15 -0400
Received: from claw.goop.org ([74.207.240.146]:48685 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773AbZETQMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 12:12:14 -0400
Message-ID: <4A142BD7.7020101@goop.org>
Date: Wed, 20 May 2009 09:12:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
References: <4A0ADBA2.2020300@goop.org> <20090515182757.GA19256@elte.hu> <4A0DCC11.10307@goop.org> <m1my9ex818.fsf@fess.ebiederm.org> <4A0DFF78.6000501@goop.org> <20090515202250.0f1218ef@jbarnes-g45> <m1iqk1k708.fsf@fess.ebiederm.org> <4A10EAC4.9070701@goop.org> <20090518085902.GE10687@elte.hu> <4A11A3F8.1010202@goop.org> <20090519095918.GA11790@elte.hu>
In-Reply-To: <20090519095918.GA11790@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> That's it.  I could add any number of bizarre convolutions to 
>> achieve the same effect, but given that there's an existing 
>> interface that is exactly designed for what we want to achieve, I 
>> have to admit it didn't occur to me to do anything else.
>>     
>
> Exactly what is 'bizarre' about using the API defined by the _CPU_ 
> already, without adding any ad-hoc hypecall? Catch the dom0 WRMSRs, 
> filter out the MTRR indices - that's it.
>   

Well, the x86 world can't seem to decide what the ABI is supposed to be, 
which is why we have mtrr_ops in the first place.  Doing emulation at 
the MSR level means that I'd need to decide which MTRR interface we're 
emulating today and do that.

Yes, I realize that almost everyone is using the same Intel-like 
interface these days, but it does mean there's a level of fragility that 
doesn't exist if we just implement mtrr_ops.

There's some secondary issues which arise.  For example, the mtrr 
trimming test is meaningless in dom0 (the e820 is fake, so it doesn't 
make sense to compare it with the mtrrs); we currently avoid that 
because the test only happens if the mtrr vendor is Intel.  We would 
need to disable that test some other way.

    J
