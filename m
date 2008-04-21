Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbYDUEGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbYDUEGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 00:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbYDUEGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 00:06:00 -0400
Received: from rs35.luxsci.com ([66.216.127.90]:34093 "EHLO rs35.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbYDUEF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 00:05:59 -0400
Message-ID: <480C1286.3040307@firmworks.com>
Date: Sun, 20 Apr 2008 18:05:26 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andres Salomon <dilinger@queued.net>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	 <20080419031024.GC3503@nineveh.local>	 <20080418202925.b18452c5.akpm@linux-foundation.org>	 <20080419092544.378664a8@ephemeral>	 <20080419133909.5aa6b63e@ephemeral>	 <86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>	 <480C0582.9010509@firmworks.com> <86802c440804202015h2605eff7vc733874dd1f22261@mail.gmail.com>
In-Reply-To: <86802c440804202015h2605eff7vc733874dd1f22261@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Yinghai Lu wrote:
> On Sun, Apr 20, 2008 at 8:09 PM, Mitch Bradley <wmb@firmworks.com> wrote:
>   
>>
>>  Yinghai Lu wrote:
>>
>>     
>>> how about changing to ofw_32.c?
>>>
>>> YH
>>>
>>>
>>>       
>>  Is your suggestion to change the filename from "ofw.c" to "ofw_32.c"?  That
>> seems like a good idea to me.
>>     
>
> Yes.
>
> BTW,  why olpc need OFW runtime service?
> why not just put the info in in ram with some signiture, so
> kernel/util just need to loot at the table if needed?
>   

In SPARC land, at least on SunOS and Solaris, it was very convenient for 
debugging to interrupt the OS with Stop-A and use OFW to inspect the 
system state.  That was especially handy for live crash analysis.  Dumps 
are useful as far as they go, but they often fail to capture detailed 
I/O device state.

I was hoping to do that on x86 too.  So far we (OLPC) haven't 
implemented a sysrq hook to enter OFW, but I haven't given up hope yet.  
It doesn't cost much to leave OFW around, but once you decide to eject 
it, you can't easily get it back.

Apple made the early decision to eject OFW and just keep a device tree 
table.  That decision was probably due to several factors, including the 
rather lame state of Apple's first OFW implementation and the complexity 
of their OS startup process at the time (which included "trampolining" 
to a 68000 emulator to run their legacy code).  Once they went down that 
path, the die was cast, and the PowerPC community got used to the "OFW 
ends up as just a table" idea.

>   
