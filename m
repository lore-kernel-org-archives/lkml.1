Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYJIPxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYJIPxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 11:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbYJIPx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 11:53:26 -0400
Received: from relay.gothnet.se ([82.193.160.251]:1333 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750904AbYJIPxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 11:53:25 -0400
Message-ID: <48EE28ED.1070401@tungstengraphics.com>
Date: Thu, 09 Oct 2008 17:53:17 +0200
From: Thomas Hellstrom <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080926)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dave Airlie <airlied@gmail.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>,
       Alan Hourihane <alanh@tungstengraphics.com>
Subject: Re: AGP PAT issue.
References: <20080820194127.GA10887@linux-os.sc.intel.com> <48AC8F69.4050201@keyaccess.nl> <21d7e9970808201446k3c1a6bc1naf04568a8ad06ed4@mail.gmail.com> <20080820221630.GA3598@linux-os.sc.intel.com> <20080821120626.GG5615@elte.hu> <48ADA2C2.8090905@keyaccess.nl> <48ADF3FC.7070002@keyaccess.nl> <20080822041544.GF30284@elte.hu> <48AF1B6A.80408@keyaccess.nl> <48C8259B.7040702@keyaccess.nl> <20080911081702.GA27425@elte.hu> <48C8D731.4000309@keyaccess.nl> <7E82351C108FA840AB1866AC776AEC462CA8E8B7@orsmsx505.amr.corp.intel.com> <48CB0CDD.9020706@keyaccess.nl>
In-Reply-To: <48CB0CDD.9020706@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 13-09-08 02:26, Pallipadi, Venkatesh wrote:
> 
>>>>> Haven't been subcribed to any lists recently and someone was 
>>>>> talking about "the other thread" before but just noticed that 
>>>>> an-rc6 was cut.
>>>>>
>>>>> Please note that the shutdown issue remains unfixed in it (I'm 
>>>>> doing my coalescing changes locally).
>>>>>
>>>> here's what is pending in tip/x86/pat for v2.6.28:
>>>>
>>> Only talking about .27 and just making sure again the issue is known.
>>>
>>> The above mentioned subject for the entry cache one ("fix Xorg 
>>> startup/shutdown slowdown with PAT") after all mistakingly says it 
>>> does something for shutdown.
>>>
>> Can you try the patch here 
>> http://www.ussg.iu.edu/hypermail/linux/kernel/0809.1/2074.html
>>
>> That should resolve both reserve and free issues..
> 
> Not for .27 though.
> 
> Rene.

Hi!
What's the status on this?

There are graphics devices we're working with that require large 
(non-AGP) write-combined memory buffers at any time.
We can solve the tlb- and cache flush latencies by using pools of these 
pages to allocate from and free to, but sooner or later we'll probably 
end up with _huge_ memtype lists. In the (very unlikely) worst case I 
guess they'd contain every other lowmem page in they system.

If I understand things correctly the patch above will fix this issue?
Will it be considered for future kernel inclusion.

Any enlightenment on this subject would be greatly appreciated.
Thanks,
/Thomas



