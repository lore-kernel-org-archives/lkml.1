Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbZCNXpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbZCNXpl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 19:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbZCNXpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 19:45:30 -0400
Received: from gw.goop.org ([64.81.55.164]:56892 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756669AbZCNXp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 19:45:29 -0400
Message-ID: <49BC4196.3070204@goop.org>
Date: Sat, 14 Mar 2009 16:45:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: VMI broken on tip/master...
References: <1236966968.14680.15.camel@alok-dev1>
In-Reply-To: <1236966968.14680.15.camel@alok-dev1>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> Hi Peter, 
>
> I was seeing a early fault when running tip/master with VMI enabled on
> VMware platform. 
> This early fault was in the vmi_patch code where we are applying
> paravirt_alternatives. After some trials i noticed that this is
> reproducible only with CONFIG_TRACING. With that disabled my VM boots
> again. 
>
> I started a git bisect after that, and git pointed to this as the bad
> commit
>
> commit 6cc3c6e12bb039047974ad2e7e2d46d15a1b762f
>     trace_clock: fix preemption bug
>
> I then reverted that commit from tip/master and the system did boot. 
> But I fail to understand how this simple patch would be causing things
> to fail in VMI. Any ideas ?
>   

Nope.  My first guess is that this is a misbisection, but the fact that 
reverting helps tends to undermine that diagnosis.

What crash are you seeing?  What kind of fault?  At what instruction?  
Doing what?  It's a bit hard to tell what you're actually seeing.

Does reverting the text_poke() changes make a difference?

    J
