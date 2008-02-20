Return-Path: <linux-kernel-owner+w=401wt.eu-S1760485AbYBTPMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760485AbYBTPMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbYBTPML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:12:11 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:45846 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbYBTPMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:12:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18364.16552.455371.242369@stoffel.org>
Date: Wed, 20 Feb 2008 10:00:56 -0500
From: "John Stoffel" <john@stoffel.org>
To: balbir@linux.vnet.ibm.com
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller
 in Kconfig
In-Reply-To: <47BC2275.4060900@linux.vnet.ibm.com>
References: <20080220122338.GA4352@basil.nowhere.org>
	<47BC2275.4060900@linux.vnet.ibm.com>
X-Mailer: VM 8.0.x-xemacs-542 under Emacs 22.1.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Balbir" == Balbir Singh <balbir@linux.vnet.ibm.com> writes:

Balbir> Andi Kleen wrote:
>> Document huge memory/cache overhead of memory controller in Kconfig
>> 
>> I was a little surprised that 2.6.25-rc* increased struct page for the memory
>> controller.  At least on many x86-64 machines it will not fit into a single
>> cache line now anymore and also costs considerable amounts of RAM. 

Balbir> The size of struct page earlier was 56 bytes on x86_64 and with 64 bytes it
Balbir> won't fit into the cacheline anymore? Please also look at
Balbir> http://lwn.net/Articles/234974/

>> At earlier review I remembered asking for a external data structure for this.
>> 
>> It's also quite unobvious that a innocent looking Kconfig option with a 
>> single line Kconfig description has such a negative effect.
>> 
>> This patch attempts to document these disadvantages at least so that users
>> configuring their kernel can make a informed decision.
>> 
>> Cc: balbir@linux.vnet.ibm.com
>> 
>> Signed-off-by: Andi Kleen <ak@suse.de>
>> 
>> Index: linux/init/Kconfig
>> ===================================================================
>> --- linux.orig/init/Kconfig
>> +++ linux/init/Kconfig
>> @@ -394,6 +394,14 @@ config CGROUP_MEM_CONT
>> Provides a memory controller that manages both page cache and
>> RSS memory.
>> 
>> +	  Note that setting this option increases fixed memory overhead
>> +	  associated with each page of memory in the system by 4/8 bytes
>> +	  and also increases cache misses because struct page on many 64bit
>> +	  systems will not fit into a single cache line anymore.
>> +
>> +	  Only enable when you're ok with these trade offs and really
>> +	  sure you need the memory controller.
>> +

I know this is a pedantic comment, but why the heck is it called such
a generic term as "Memory Controller" which doesn't give any
indication of what it does.

Shouldn't it be something like "Memory Quota Controller", or "Memory
Limits Controller"?

Also, the Kconfig name "CGROUP_MEM_CONT" is just wrong, it should be
"CGROUP_MEM_CONTROLLER", just spell it out so it's clear what's up.

It took me a bunch of reading of Documentation/controllers/memory.txt
to even start to understand what the purpose of this was.  The
document could also use a re-writing to include a clear introduction
at the top to explain "what" a memory controller is.  

Something which talks about limits, resource management, quotas, etc
would be nice.  

Thanks,
John
