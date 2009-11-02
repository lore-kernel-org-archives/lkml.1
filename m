Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbZKBUcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbZKBUcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 15:32:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbZKBUcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 15:32:07 -0500
Received: from relay1.sgi.com ([192.48.179.29]:37452 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756730AbZKBUcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 15:32:06 -0500
Message-ID: <4AEF41C5.6010503@sgi.com>
Date: Mon, 02 Nov 2009 12:32:05 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Limit the number of processor bootup messages
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233746.128967000@alcatraz.americas.sgi.com> <87tyxmy6x6.fsf@basil.nowhere.org> <4AE5E48F.6020408@sgi.com> <20091026215544.GA3355@basil.fritz.box> <4AEB3D95.50300@sgi.com> <4AEEBE65.3070202@linux.intel.com> <4AEF3143.2030701@sgi.com> <20091102193445.GA9948@elte.hu>
In-Reply-To: <20091102193445.GA9948@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>>
>> Andi Kleen wrote:
>>> Mike Travis wrote:
>>>> This set of patches limits the number of repetitious messages which  
>>>> contain
>>>> no additional information.  Much of this information is obtainable  
>>>> from the
>>>> /proc and /sysfs.   Most of the messages are also sent to the kernel log
>>>> buffer as KERN_DEBUG messages so it can be used to examine more  
>>>> closely any
>>>> details specific to a processor.
>>> What would be good is to put the information from the booting CPUs
>>> into some buffer and print it visibly if there's a timeout detected on  
>>> the BP.
>> What do you think of this idea....  Add a "mark kernel log buffer" 
>> function, and then if any KERN_NOTE or above happens, it sends the 
>> marked info from the kernel log buffer to the console before the 
>> current message.  Set the marker to '0' to clear.
> 
> That's _way_ too complex really, for little benefit. (If there's a boot 
> hang people will re-try anyway (and this time with a serial console 
> attached or so), and they can add various boot options to increase 
> verbosity - depending in which phase the bootup hung.)

I'm ok with this, though generally speaking large server systems have
serial consoles attached, and save the output into admin logs.  One
problem with just setting the loglevel high enough to output debug
messages, is you get literally 100's of thousands of lines of meaningless
information.  We waited over 8 hours for a system with 2k cpus to boot
in debug mode, and it never made it all the way up.

My intention for the above was to attempt to print debug information
that pertains to the failure, and not everything else.

> 
> So please go with the simple solution i suggested days ago: print stuff 
> on the boot CPU but after that only a single line per AP CPU.
> 
> 	Ingo

So you think printing 4096 lines provides meaningful additional
information?  I would think at least compress it so you only print
each new processor socket boots and not the 16 threads each of
them have?

I should have timing information soon for 512 cores/1024 threads and
printing a single line for each of those will significantly increase
the time it takes to boot.

Thanks,
Mike
