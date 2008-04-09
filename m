Return-Path: <linux-kernel-owner+w=401wt.eu-S1756973AbYDISOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbYDISOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbYDISOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:14:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:33513 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbYDISOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:14:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=HavSGB/r1xDZCs4UgUYYA16JSG8IyQNOCg7mwNX4nYnxAy6CJznk2ZwFOtDTbQYUg3L3Hq4rx+rTuCSEzAyc5cMsf0Eah7VAnhiNqN8LI4OUqpdvusF4BOsfD7dhMGL+YBMRPgMLnw4RK5TuYD/XsPkO7NjIIF/EHMrotWal2Jw=
Date: Wed, 9 Apr 2008 22:10:10 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Jason Baron <jbaron@redhat.com>,
       Adrian Bunk <bunk@stusta.de>, Christoph Hellwig <hch@infradead.org>,
       akpm@osdl.org
Subject: Re: [patch 09/17] Add all cpus option to stop machine run
Message-ID: <20080409181010.GA4924@martell.zuzino.mipt.ru>
References: <20080409150829.855195878@polymtl.ca> <20080409152049.513274847@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409152049.513274847@polymtl.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, stop Cc'ing me on this.

I continue to think that all this so-called "immediate" infrastructure
is an absolute overkill and declared D-cache line savings will _never_
matter and will never be measured on real life workloads. Right now you
claim 1 (one) cacheline saving in schedule() which can be trivially
moved under CONFIG_PROFILING umbrella. On the other hand is more ugly
assembler code. Sorry, people add infra with much better good/bad ratios.

Also, my gut feeling of a guy who is also on receiveing end of bugreports
at SWsoft that line with .text games was crossed by SMP alternatives and
fooprobes. The rest won't matter because programs like firefox will fuck
up L1, L2 caches in one blow just by showing animation.

We don't need bugs when immediate update screwed up fighting for
cacheline.

And bugs when screwup happened out of the window of "Code:" printout, so
you won't have a chance to compare relevant vmlinux .text and printout.

And bugs when CPU executed bullshit and silently rebooted.

And so on.

	Alexey, more and more liking OpenBSD
		where such games won't even
	        hit mailing lists

