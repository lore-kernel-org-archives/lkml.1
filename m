Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbZGLJSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbZGLJSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 05:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbZGLJS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 05:18:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38439 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbZGLJS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 05:18:26 -0400
Message-ID: <4A59AAF1.1030102@redhat.com>
Date: Sun, 12 Jul 2009 12:20:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, npiggin@suse.de, akpm@osdl.org,
       jeremy@goop.org, xen-devel@lists.xensource.com,
       tmem-devel@oss.oracle.com, alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org,
       kurt.hackel@oracle.com, Rusty Russell <rusty@rustcorp.com.au>,
       dave.mccracken@oracle.com, Marcelo Tosatti <mtosatti@redhat.com>,
       sunil.mushran@oracle.com, Schwidefsky <schwidefsky@de.ibm.com>,
       chris.mason@oracle.com, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/4] (Take 2): transcendent memory ("tmem") for Linux
References: <d693761e-2f2b-4d8c-ae4f-7f22479f6c0f@default>
In-Reply-To: <d693761e-2f2b-4d8c-ae4f-7f22479f6c0f@default>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2009 06:23 PM, Dan Magenheimer wrote:
>> If there was one change to tmem that would make it more
>> palatable, for
>> me it would be changing the way pools are "allocated".  Instead of
>> getting an opaque handle from the hypervisor, I would force
>> the guest to
>> allocate it's own memory and to tell the hypervisor that it's a tmem
>> pool.
>>      
>
> An interesting idea but one of the nice advantages of tmem being
> completely external to the OS is that the tmem pool may be much
> larger than the total memory available to the OS.  As an extreme
> example, assume you have one 1GB guest on a physical machine that
> has 64GB physical RAM.  The guest now has 1GB of directly-addressable
> memory and 63GB of indirectly-addressable memory through tmem.
> That 63GB requires no page structs or other data structures in the
> guest.  And in the current (external) implementation, the size
> of each pool is constantly changing, sometimes dramatically so
> the guest would have to be prepared to handle this.  I also wonder
> if this would make shared-tmem-pools more difficult.
>    

Having no struct pages is also a downside; for example this guest cannot 
have more than 1GB of anonymous memory without swapping like mad.  
Swapping to tmem is fast but still a lot slower than having the memory 
available.

tmem makes life a lot easier to the hypervisor and to the guest, but 
also gives up a lot of flexibility.  There's a difference between memory 
and a very fast synchronous backing store.

> I can see how it might be useful for KVM though.  Once the
> core API and all the hooks are in place, a KVM implementation of
> tmem could attempt something like this.
>    

My worry is that tmem for kvm leaves a lot of niftiness on the table, 
since it was designed for a hypervisor with much simpler memory 
management.  kvm can already use spare memory for backing guest swap, 
and can already convert unused guest memory to free memory (by swapping 
it).  tmem doesn't really integrate well with these capabilities.


-- 
error compiling committee.c: too many arguments to function

