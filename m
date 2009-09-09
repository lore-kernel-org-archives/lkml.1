Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbZIIDcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbZIIDcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 23:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbZIIDcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 23:32:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57083 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbZIIDcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 23:32:13 -0400
Message-ID: <4AA72175.5000108@cn.fujitsu.com>
Date: Wed, 09 Sep 2009 11:31:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4 -mm] flex_array: poison free elements
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com> <alpine.DEB.2.00.0908211620580.28611@chino.kir.corp.google.com> <1251129384.22398.7166.camel@nimitz> <alpine.DEB.2.00.0908241330361.5574@chino.kir.corp.google.com> <1251150156.22398.8289.camel@nimitz> <alpine.DEB.2.00.0908241540480.12448@chino.kir.corp.google.com> <alpine.DEB.1.00.0909081511590.26432@chino.kir.corp.google.com> <4AA70D4F.3040503@cn.fujitsu.com> <alpine.DEB.1.00.0909081959030.5084@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0909081959030.5084@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Wed, 9 Sep 2009, Li Zefan wrote:
> 
>>> I'm struggling to find other examples.  Dave, do you know of any 
>>> subsystems in the kernel that can readily be converted to using flex 
>>> array?
>> Actually I'm planing to try to convert to use flex array in
>> kernel/trace/ftrace.c, and it needs some change in flex array,
>> and I'll have to check if it will have a performance effect
>> or not.
>>
> 
> That's cool, but it looks like none of those allocations currently would 
> ever exceed PAGE_SIZE.  The return stack for each task would be a flex 
> array of 50 elements, each element being 40 bytes for a maximum array 
> size of 2KB.  The tasklist would allocate a flex array of pointers to 
> struct ftrace_ret_stack with a maximum of 32 elements.  On x86_64, that 
> has a maximum size of 256 bytes.
> 
> So while you would be converting existing kernel code to use the new 
> interface, which is great, it doesn't have any advantage over the existing 
> implementation.  I was looking for a current use-case that would otherwise 
> use vmalloc because the entire array could not fit into a single page.
> 

I was not talking about ftrace_ret_stack, I was talking about
struct ftrace_page and struct ftrace_profile_page. ;)

Each page holds an array of records, and there is a list linking
those pages. The total nr of elements can be the nr of functions
in kernel.

I think flex array can be used here to remove duplicate
implementation.

