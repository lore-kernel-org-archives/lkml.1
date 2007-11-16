Return-Path: <linux-kernel-owner+w=401wt.eu-S1762952AbXKPJTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762952AbXKPJTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 04:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbXKPJSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 04:18:46 -0500
Received: from ka.cs.utk.edu ([160.36.56.221]:51047 "EHLO ka.cs.utk.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbXKPJSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 04:18:43 -0500
In-Reply-To: <20071114015210.GA20365@one.firstfloor.org>
References: <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu> <20071113185924.GA22748@suse.de> <20071113120728.4342e7d7.akpm@linux-foundation.org> <20071113203645.GA17145@one.firstfloor.org> <9FF72994-F55A-4B36-9EAA-CB1D2360A6F5@cs.utk.edu> <20071114015210.GA20365@one.firstfloor.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A42C2398-2EAB-460C-95C7-686A34A76F82@cs.utk.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Stephane Eranian <eranian@hpl.hp.com>,
       William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       papi list <ptools-perfapi@cs.utk.edu>
Content-Transfer-Encoding: 7bit
From: Philip Mucci <mucci@cs.utk.edu>
Subject: Re: perfmon2 merge news
Date: Fri, 16 Nov 2007 01:18:19 -0800
To: Andi Kleen <andi@firstfloor.org>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just getting back to this now that SC07 is finally over...

On Nov 13, 2007, at 5:52 PM, Andi Kleen wrote:

> On Tue, Nov 13, 2007 at 04:28:52PM -0800, Philip Mucci wrote:
>> I know you don't want to hear this, but we actually use all of the
>> features of perfmon, because a) we wanted to use the best methods
>
> That is hard to believe.
>

You are welcome to download the code and some of the tools and verify  
the functionality yourself. It might be a good exercise.

> But let's go for it temporarily for the argument.
>
> Can you instead prioritize features.  What is most essential, what is
> important, what is just nice to have, what is rarely used?

Yes, although this has been done before. You've got the list below in  
the previous
emails which should be considered the absolute minimum.

- A feature which was dropped earlier by Stefane (only to satiate  
LKML), we consider
very important. Allowing one tomapping of the kernels view of the  
PMD's, allowing
user-space access to full 64-bit counts, if the architecture
supports a user-level read instruction. Getting the counts in a  
couple of dozen cycles
is ALWAYS a win for us. This is because the HPC community is mainly  
interested in
self-monitoring, not third-party, because the former can be easily  
associated with
context in the app through instrumentation in various forms.

- Kernel multiplexing is very nice to have, saves you tremendous  
overhead at user
level. PAPI has an implementation in user-space for the platforms  
that don't support
this. The flexibility of the current implementation is not exploited,  
here I'm
referring to the concept of eventsets. Having multiplexing is  
important. Being able
to allocate/reallocate eventsets and the threshold of individual  
eventsets is just nice
to have.

- Custom sample formats would be considered not often used in our  
community, largely
because the tools run on all HPC/Linux architectures. PAPI uses the  
default sample
format which has been sufficient for our needs. However, the lack of  
custom sample
formats preclude the dev of the specialized tools that access the  
sampling
hardware as found on the IA64, PPC64, the Barcelona and the SiCortex  
node chip.
pfmon exports this functionality quite well, and it does get used.


>> 	- providing virtualized 64-bit counters per-thread
>> 	- providing notification (buffered or non) on interrupt/overflow of
>> the above.
>
> Ok that makes sense and should be possible with a reasonable simple
> interface.

Well that's good news. The above is what we have used via the PerfCtr  
set of
patches for a long time. It wasn't quite enough, but it got the job  
done.

>> If you'd like to outline further what you'd like to hear from the
>> community, I can arrange that. I seem to remember going through this
>> once before, but I'd be happy to do it again. For reference, here's a
>> quick list from memory of some of the tools in active use and built
>> on this infrastructure. These are used heavily around the globe.
>
> Please list concrete features, throwing around random names is not  
> useful.
>

This is kind of comment that makes the Linux/HPC folks 'somber'. What  
isn't useful, is being dismissive of an entire community that moves a  
heck of a lot of Linux DVD's. >80% of the top500 list is Linux these  
days (compared to < 10% just a few years back), and so is the bulk of  
the HPC clusters in the marketplace, large and small. (ref those  
expensive IDC reports) These are tools used daily in HPC centers and  
industry around the globe, doing real work for folks that buy a lot  
of hardware and actually pay for Linux distributions. These tools  
seem random to you, because you haven't spent any time educating  
yourself about this community since we first talked about this >3  
years back when considering PerfCtr. Really, there are dozens of HPC/ 
Linux events held every year around the world of varying sizes;  
should you ever attend one, this all might not seem so 'random'. And  
yes, you would be warmly welcomed.

-Phil
  
