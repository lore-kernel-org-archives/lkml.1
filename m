Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYH1BIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYH1BIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 21:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbYH1BIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 21:08:40 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:38467 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752500AbYH1BIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 21:08:39 -0400
Message-ID: <48B5F9F3.20505@snapgear.com>
Date: Thu, 28 Aug 2008 11:05:55 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org> <20080826183051.GB10925@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org> <20080826205916.GB11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org> <20080826232411.GC11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261648140.3363@nehalem.linux-foundation.org> <20080827002316.GE11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261726560.3363@nehalem.linux-foundation.org> <20080827115829.GF11734@cs181140183.pp.htv.fi> <20080827160052.GA15968@linux-sh.org>
In-Reply-To: <20080827160052.GA15968@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Paul Mundt wrote:
> On Wed, Aug 27, 2008 at 02:58:30PM +0300, Adrian Bunk wrote:
>> On Tue, Aug 26, 2008 at 05:28:37PM -0700, Linus Torvalds wrote:
>>> On Wed, 27 Aug 2008, Adrian Bunk wrote:
>>>> When did we get callpaths like like nfs+xfs+md+scsi reliably 
>>>> working with 4kB stacks on x86-32?
>>> XFS may never have been usable, but the rest, sure.
>>>
>>> And you seem to be making this whole argument an excuse to SUCK, adn an 
>>> excuse to let gcc crap even more on our stack space.
>>>
>>> Why?
>>>
>>> Why aren't you saying that we should be able to do better? Instead, you 
>>> seem to asking us to do even worse than we do now?
>> My main point is:
>> - getting 4kB stacks working reliably is a hard task
>> - having an eye on gcc increasing the stack usage, and fixing it if
>>   required, is relatively easy
>>
>> If we should be able to do better at getting (and keeping) 4kB stacks 
>> working, then coping with possible inlining problems caused by gcc
>> should not be a big problem for us.
>>
> Out of the architectures you've mentioned for 4k stacks, they also tend
> to do IRQ stacks, which is something you seem to have overlooked.
> 
> In addition to that, debugging the runaway stack users on 4k tends to be
> easier anyways since you end up blowing the stack a lot sooner. On sh
> we've had pretty good luck with it, though most of our users are using
> fairly deterministic workloads and continually profiling the footprint.
> Anything that runs away or uses an insane amount of stack space needs to
> be fixed well before that anyways, so catching it sooner is always
> preferable. I imagine the same case is true for m68knommu (even sans IRQ
> stacks).

Yep, definitely true for m68knommu in my experience. I haven't had
any problems with 4k stacks recently. But yes the workloads do tend
to be constrained - and almost never use any of the more exotic
filesystems or drivers.



> Things might be more sensitive on x86, but it's certainly not something
> that's a huge problem for the various embedded platforms to wire up,
> whether they want to go the IRQ stack route or not.
> 
> In any event, lack of support for something on embedded architectures in
> the kernel is more often due to apathy/utter indifference on the part of
> the architecture maintainer rather than being indicative of any intrinsic
> difficulty in supporting the thing in question. Most new "features" on the
> lesser maintained architectures tend to end up there either out of peer
> pressure or copying-and-pasting accidents rather than any sort of design.
> ;-)

Indeed :-)

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
