Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbYIHPRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbYIHPRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYIHPRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:17:07 -0400
Received: from relay2.sgi.com ([192.48.171.30]:33432 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752875AbYIHPRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:17:06 -0400
Message-ID: <48C541EF.3040404@sgi.com>
Date: Mon, 08 Sep 2008 08:17:03 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, davej@codemonkey.org.uk,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/13] smp: reduce stack requirements for genapic	send_IPI_mask
 functions
References: <20080906235036.891970000@polaris-admin.engr.sgi.com> <20080907073620.GC14907@elte.hu>
In-Reply-To: <20080907073620.GC14907@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> [Note: all these changes require some more testing but I wanted to 
>> solicit comments before then, hence the "RFC" in the subject line. 
>> -thanks! Mike]
> 
> these changes are certainly looking very nice.
> 
> They do interact with a ton of high-flux topics in -tip, so i'd prefer 
> to start integrating/testing this straight away (today-ish), before the 
> target moves yet again. Are there any showstoppers that speak against 
> that?
> 
> The plan would be to not keep this in a single topic but to spread them 
> into their closest topic (tip/x86/x2apic, tip/irq/sparseirq etc.) - are 
> there any cross-topic dependencies to be careful about? Most of the 
> commits seem to be standalone. The debug patch would go into 
> tip/cpus4096.
> 
> And more generally: how far away are we from being able to introduce 
> struct cpumask and hide its implementation from most .c files? That 
> would be rather efficient in preventing it from being put on the stack 
> spuriously in one of the 30+ thousand Linux kernel source code files. 
> Just like we hide the true structure of things like 'struct kmem_cache' 
> and force them to always be used as pointers.
> 
> 	Ingo

What I'll do is resubmit the changes that have nothing to do with
cpumask_ptr's first as they are mostly just "cleaning up extraneous
temp cpumask variables".  Then I'll try the redefine of cpumask_t to
see what kind of hornet's nest is opened up.

What do you think of a pool of temp cpumask_t's?  That way, they
could be made available early (before kmalloc is available).  An
atomic op could be used for reservation which when the zero-based
percpu variables finally get completed, become very low cost.

Thanks,
Mike
