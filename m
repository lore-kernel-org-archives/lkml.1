Return-Path: <linux-kernel-owner+w=401wt.eu-S1161419AbXDLAWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161419AbXDLAWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 20:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965407AbXDLAWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 20:22:09 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34587 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965320AbXDLAWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 20:22:08 -0400
Message-ID: <461D7BA5.4050009@us.ibm.com>
Date: Wed, 11 Apr 2007 17:21:57 -0700
From: Vara Prasad <prasadav@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.2) Gecko/20040804 Netscape/7.2 (ax)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jim Keniston <jkenisto@us.ibm.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>,
       "Frank Ch. Eigler" <fche@redhat.com>, systemtap@sources.redhat.com
Subject: Re: [PATCH] markers-linker-generic
References: <20070410223658.GC7092@Krystal> 	 <20070411074414.GC3752@flint.arm.linux.org.uk> 	 <20070411175110.GA30879@Krystal> 	 <20070411110240.537ee25d.akpm@linux-foundation.org> 	 <20070411192122.GA4668@Krystal> <1176327900.3542.22.camel@ibm-ni9dztukfq8.beaverton.ibm.com>
In-Reply-To: <1176327900.3542.22.camel@ibm-ni9dztukfq8.beaverton.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Keniston wrote:

>On Wed, 2007-04-11 at 15:21 -0400, Mathieu Desnoyers wrote:
>  
>
>>* Andrew Morton (akpm@linux-foundation.org) wrote:
>>    
>>
>>>On Wed, 11 Apr 2007 13:51:11 -0400
>>>Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
>>>
>>>      
>>>
>>>>>What's this marker stuff about?
>>>>>
>>>>>          
>>>>>
>>>>Hi Russel,
>>>>
>>>>Here is an overview :
>>>>        
>>>>
>>>I am told that the systemtap developers plan to (or are) using this
>>>infrastructure.
>>>
>>>      
>>>
>>Quoting Frank Ch. Eigler, from the SystemTAP team :
>>
>>"The LTTng user-space programs use it today.  Systemtap used to support
>>the earlier marker prototype and will be rapidly ported over to this
>>new API upon acceptance."
>>
>>
>>    
>>
>>>If correct: what is their reason for preferring it over kprobes?
>>>      
>>>
Markers are not a substitute or preference over kprobes, they augment 
kprobes by enabling additional functionality.

>>>      
>>>
>>I will let them answer on this one..
>>
>>    
>>
>
>I'll take a shot at this one.
>
>First of all, kprobes remains a vital foundation for SystemTap.  But
>markers are attactive as an alternate source of trace/debug info.
>Here's why:
>
>1. Markers will live in the kernel and presumably be kept up to date by
>the maintainers of the enclosing code.  We have a growing set of tapsets
>(probe libraries), each of which "knows" the source code for a certain
>area of the kernel.  Whenever the underlying kernel code changes (e.g.,
>a function or one of its args disappears or is renamed), there's a
>chance that the tapset will become invalid until we bring it back in
>sync with the kernel.  As you can imagine, maintaining tapsets separate
>from the kernel source is a maintenance headache.  Markers could
>mitigate this.
>  
>
Jim's above stated reason is not a consideration for markers. We don't 
plan to convert the current tapsets to use markers. We do need to 
augment tapsets with a few markers in the kernel code where it is not 
easy to put a kprobe in a maintainable fashion -- e.g in the middle of a 
function.

>2. Because the kernel code is highly optimized, the kernel's dwarf info
>doesn't always accurately reflect which variables have which values on
>which lines (sometimes even upon entry to a function).  A marker is a
>way to ensure that values of interest are available to SystemTap at
>marked points.
>  
>
Agreed

>3. Sometimes the overhead of a kprobe probepoint is too much (either in
>terms of time or locking) for the particular hotspot we want to probe.
>
>  
>
Agreed

>Jim
>
>  
>
bye,
Vara Prasad

