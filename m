Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbZLWRmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbZLWRmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 12:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZLWRlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 12:41:52 -0500
Received: from mx2.compro.net ([12.186.155.4]:37052 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbZLWRlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 12:41:51 -0500
X-IronPort-AV: E=Sophos;i="4.47,443,1257138000"; 
   d="scan'208";a="4811978"
Message-ID: <4B32565E.6000501@compro.net>
Date: Wed, 23 Dec 2009 12:41:50 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
References: <4AFB3962.2020106@ntlworld.com> <4B2B4485.6000305@cfl.rr.com>	<4B2B5F86.1090403@cfl.rr.com>	<alpine.LFD.2.00.0912180716400.3712@localhost.localdomain>	<4B2B9F9F.7040802@compro.net>	<alpine.LFD.2.00.0912180734220.3712@localhost.localdomain>	<4B2BE05B.9050006@compro.net>	<alpine.LFD.2.00.0912181213540.3712@localhost.localdomain>	<4B30E1B4.7000702@compro.net>	<alpine.LFD.2.00.0912220922250.31313@localhost.localdomain>	<4B310879.9050701@compro.net>	<1261525076.16916.4.camel@localhost.localdo main>	<4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net>	<6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com>	<4B32386B.2060509@compro.net>	<alpine.LFD.2.00.0912230828230.6879@localhost.localdomain> <87bphpd4rt.fsf@basil.nowhere.org>
In-Reply-To: <87bphpd4rt.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 11:38 AM, Andi Kleen wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
>> It's not using the lapic for CPU0. 
>>
>> Using the HPET as a per-cpu timer is some crazy sh*t, since it's pretty 
>> expensive to reprogram (compared to the local apic). And having different 
>> timers for different CPU's is just odd.
>>
>> The fact that the timer subsystem can do this and it all (mostly) works at 
>> all is nice and impressive, but doesn't make it any less crazy ;)
> 
> I suspect it's a system where the APIC timer stops in deeper idle
> states and it supports them. In this case CPU #0 does timer broadcasts
> when needed to wake the other CPUs up from deep C, but for that it has
> to run with HPET. At least the other ones can still enjoy the LAPIC
> timer.
> 
> This might suggest that Mark's floppy controller doesn't like
> deep C? Mark, did you try booting with processor.max_cstate=1
> and HPET enabled?

I just did and /proc/interrupts looks the same and the floppy still does
not format.

I'll try the patch Linus provided now.

Mark

