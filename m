Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867Ab0AOSC7 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 13:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757307Ab0AOSC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 13:02:58 -0500
Received: from mx2.compro.net ([12.186.155.4]:15867 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718Ab0AOSC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 13:02:58 -0500
X-IronPort-AV: E=Sophos;i="4.49,282,1262581200"; 
   d="scan'208";a="4877720"
Message-ID: <4B50ADD0.20508@compro.net>
Date: Fri, 15 Jan 2010 13:02:56 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>, Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alain Knaff <alain@knaff.lu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
        "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
References: <alpine.LFD.2.00.0912220922250.31313@localhost.localdomain>	 <4B310879.9050701@compro.net>	 <1261525076.16916.4.camel@localhost.localdomain>	 <4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net>	 <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com>	 <4B32386B.2060509@compro.net>	 <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain>	 <87bphpd4rt.fsf@basil.nowhere.org> <4B32565E.6000501@compro.net>	 <20091223191806.GA3336@linux-os.sc.intel.com> <4B3270FE.5090607@compro.net>	 <1261600243.16916.56.camel@localhost.localdomain>	 <4B476E8D.1030308@compro.net>	 <1263255557.16916.132.camel@localhost.localdomain>	 <4B4C3B1A.50906@cfl.rr.com> <1263520917.16916.171.camel@localhost.localdomain>
In-Reply-To: <1263520917.16916.171.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2010 09:01 PM, Pallipadi, Venkatesh wrote:
> On Tue, 2010-01-12 at 01:04 -0800, Mark Hounschell wrote:
>> On 01/11/2010 07:19 PM, Pallipadi, Venkatesh wrote:
>>>
>>> Sorry for not following up on this. We have narrowed this down to HPET
>>> MSI and floppy DMA. I still don't know how HPET MSI interrupts are
>>> breaking floppy DMA.
>>>
>>> You are seeing the problem on two different systems. Correct? Do you
>>> have any system where this works with HPET MSI enabled?
>>>
>>
>> I see the problem on every system in which the HPET2 shows up in
>> /proc/interrupts. The machines that work with HPET enabled don't show HPET
>> at all in /proc/interrupts.  I have some of each. All the boxes that fail
>> here use the (AMD) 790x series chip sets.
>>
>>> Couple of options on how we can go about this one:
>>> 1) Change the HPET-MSI change to not get activated when there are no
>>> C-states with LAPIC stoppage involved. This will resolve the problem on
>>> the systems you reported as there are no deep C-states. But, I fear that
>>> with the actual problem unresolved, we may hit it in future with this or
>>> some other platform having same issue with CPUs that support deep
>>> C-state.
>>> 2) Try this testcase on few other platforms that support HPET-MSI and
>>> deep C-states and check how widespread the problem is and then add a
>>> whitelist-blacklist for HPET MSI usage.
>>>
>>> I think, for 2.6.33 option 1 is better. Will work on that and send in
>>> patches for you test.
>>>
>>
> 
> Mark,
> 
> I just sent out a patchset that should workaround the problem here. Can
> you check and let me know whether thats the case.
> 

Yes, it does seem to fix the issue. The floppy formats and /proc/interrupts
look normal with nothing going on with the hpet2 msi.

Regards
Mark

