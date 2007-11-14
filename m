Return-Path: <linux-kernel-owner+w=401wt.eu-S1763626AbXKNA3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763626AbXKNA3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761409AbXKNA3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:29:11 -0500
Received: from shu.cs.utk.edu ([160.36.56.39]:43897 "EHLO shu.cs.utk.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761408AbXKNA3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:29:10 -0500
In-Reply-To: <20071113203645.GA17145@one.firstfloor.org>
References: <20071107003454.GA13374@kroah.com> <20071109120627.60ec9ab4.akpm@linux-foundation.org> <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu> <20071113185924.GA22748@suse.de> <20071113120728.4342e7d7.akpm@linux-foundation.org> <20071113203645.GA17145@one.firstfloor.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <9FF72994-F55A-4B36-9EAA-CB1D2360A6F5@cs.utk.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Stephane Eranian <eranian@hpl.hp.com>,
       William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       Perfmon <perfmon@napali.hpl.hp.com>,
       perfmon2-devel@lists.sourceforge.net,
       papi list <ptools-perfapi@cs.utk.edu>
Content-Transfer-Encoding: 7bit
From: Philip Mucci <mucci@cs.utk.edu>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Date: Tue, 13 Nov 2007 16:28:52 -0800
To: Andi Kleen <andi@firstfloor.org>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

pfmon is a single tool and fairly low level, the HPC folks don't use  
it so much because it isn't parallel aware and is meant for power- 
users. It is not representative of the tools used in HPC at all. Our  
community uses tools built on the infrastructure provided by libpfm  
and PAPI for the most part.

I know you don't want to hear this, but we actually use all of the  
features of perfmon, because a) we wanted to use the best methods  
available and b) areas where user level solutions could be made (like  
multiplexing) introduced too much noise and overhead to be of use.  
For years we relied on PerfCtr which did 'just enough' for us. But  
when Perfmon2 became available, we adopted technology where it meant  
a significant increase in accuracy for the resulting measurements,  
specifically for us that meant, kernel multiplexing and sample buffers.
Note that PAPI is just middleware. The tools built upon it are what  
people use...some of those are commercial tools like Vampir but most  
are Open Source. These tools are cross platform, as such they run on  
nearly everything...although intel/amd/ppc systems dominate the HPC  
market.

The usage cases are always the same and can be broken down into  
simple counting and sampling:

	- providing virtualized 64-bit counters per-thread
	- providing notification (buffered or non) on interrupt/overflow of  
the above.

If you'd like to outline further what you'd like to hear from the  
community, I can arrange that. I seem to remember going through this  
once before, but I'd be happy to do it again. For reference, here's a  
quick list from memory of some of the tools in active use and built  
on this infrastructure. These are used heavily around the globe.  
You'll see that each basically follows one of the 2 usage models above.

- HPCToolkit (Rice)
- PerfSuite (NCSA)
- Vampir (Dresden)
- Kojak (Juelich)
- TAU (UOregon)
- PAPIEX (me)
- GPTL (NCAR)
- HPM-Linux (IBM)
- Paraver (Barcelona)

Time to go give a talk here at a tools session at SC'07 about this  
very subject.

Phil

On Nov 13, 2007, at 12:36 PM, Andi Kleen wrote:

>> He speaks for quite a few people - they have serious need for this  
>> feature
>
> Most likely they have serious need for a very small subset of  
> perfmon2.
> The point of my proposal was to get this very small subset in quickly.
>
> Phil, how many of the command line options of pfmon do you
> actually use? How many do the people at your conference use? Or what
> functions, what performance counters etc. in PAPI or whatever
> library you use?
>
> Make use understand the use cases better, that would already help a  
> lot
> in merging by concentrating on what people actually really need.
>
> -Andi
>

