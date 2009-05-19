Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbZESJ7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbZESJ7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbZESJ7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:59:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33432 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbZESJ7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:59:48 -0400
Date: Tue, 19 May 2009 11:59:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
Message-ID: <20090519095918.GA11790@elte.hu>
References: <4A0ADBA2.2020300@goop.org> <20090515182757.GA19256@elte.hu> <4A0DCC11.10307@goop.org> <m1my9ex818.fsf@fess.ebiederm.org> <4A0DFF78.6000501@goop.org> <20090515202250.0f1218ef@jbarnes-g45> <m1iqk1k708.fsf@fess.ebiederm.org> <4A10EAC4.9070701@goop.org> <20090518085902.GE10687@elte.hu> <4A11A3F8.1010202@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A11A3F8.1010202@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> Here Xen invades an already fragile piece of upstream code  
>> (/proc/mtrr) that is obsolete and on the way out. If you want a  
>> solution you should add PAT support to Xen and you should use recent  
>> upstream kernels. Or you should emulate /proc/mtrr in _Xen the  
>> hypervisor_, if you really care that much - without increasing the  
>> amount of crap in Linux.
>>   
>
> That's a gross mis-characterisation of what we're talking about here.
>
> arch/x86 already defines an mtrr_ops, which defines how to 
> manipulate the MTRR registers.  There are currently several 
> implementations of that interface.  In Xen the MTRR registers 
> belong to the hypervisor, but it allows a privileged kernel to 
> modify them via hypercalls.  I simply added a new, straightforward 
> mtrr_ops implementation to do that.  It adds about 120 lines of 
> new code, in a single mtrr/xen.c file.
>
> That's it.  I could add any number of bizarre convolutions to 
> achieve the same effect, but given that there's an existing 
> interface that is exactly designed for what we want to achieve, I 
> have to admit it didn't occur to me to do anything else.

Exactly what is 'bizarre' about using the API defined by the _CPU_ 
already, without adding any ad-hoc hypecall? Catch the dom0 WRMSRs, 
filter out the MTRR indices - that's it.

	Ingo
