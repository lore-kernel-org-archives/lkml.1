Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbYIZXJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbYIZXJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 19:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYIZXJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 19:09:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41045 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752533AbYIZXJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 19:09:42 -0400
Message-ID: <48DD6BBC.4000402@sgi.com>
Date: Fri, 26 Sep 2008 16:09:48 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: num_possible_cpus() giving more than possible.
References: <alpine.DEB.1.10.0809261613070.21618@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0809261613070.21618@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Hi Mike,
> 
> Peter told me that I should report this to you. I have two socket
> single core hyper threaded box (must be hell). Peter told me that the 
> num_possible_cpus() should return the number possible on this box. The 
> explanation of my box tells us it should be 4. But it in fact returns 8.

It looks like the APIC discovery code is finding 2 dual cores w/HT.  I'm
no expert in how all this works but it's assigning

	proc 0/2 --> phys id 0 w/2 HT
	proc 1/3 --> phys id 3 w/2 HT

Either the BIOS on your machine is confusing the APIC code, the APIC code
has a bug, or you've found an Easter egg... ;-)

> 
> nr_cpu_ids also returns 8.

Yes, this reflects the number of possible cpus if all were enabled.  On
our systems, we can designate a number of cores to be "present" but
"disabled".  Perhaps a "low bin" cpu is basically a dual core with the
non-working core disabled, but still accounted for in the BIOS APIC
tables?

Cheers,
Mike
> 
> here's the /proc/cpuinfo:
> 
> processor	: 0
.
> physical id	: 0
> siblings	: 2
> core id		: 0
> cpu cores	: 1
> apicid		: 0
> initial apicid	: 0
.
> 
> processor	: 1
.
> physical id	: 3
> siblings	: 2
> core id		: 0
> cpu cores	: 1
> apicid		: 6
> initial apicid	: 6
.
> 
> processor	: 2
.
> physical id	: 0
> siblings	: 2
> core id		: 0
> cpu cores	: 1
> apicid		: 1
> initial apicid	: 1
.
> 
> processor	: 3
.
> physical id	: 3
> siblings	: 2
> core id		: 0
> cpu cores	: 1
> apicid		: 7
> initial apicid	: 7
.
> Perhaps since my physical ids show 0 and 3, it thinks it can also have 
> a 1 and 2?
> 
> Thanks,
> 
> -- Steve
> 
> 

