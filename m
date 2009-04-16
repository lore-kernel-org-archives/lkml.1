Return-Path: <linux-kernel-owner+w=401wt.eu-S1758252AbZDPS3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbZDPS3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 14:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbZDPS3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 14:29:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33706 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992AbZDPS3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 14:29:02 -0400
Message-ID: <49E77814.6030306@redhat.com>
Date: Thu, 16 Apr 2009 21:25:24 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       aarcange@redhat.com, chrisw@redhat.com, mtosatti@redhat.com,
       hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux v3
References: <1239249521-5013-1-git-send-email-ieidus@redhat.com> <20090414150903.b01fa3b9.akpm@linux-foundation.org> <200904170355.26294.nickpiggin@yahoo.com.au>
In-Reply-To: <200904170355.26294.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Wednesday 15 April 2009 08:09:03 Andrew Morton wrote:
>   
>> On Thu,  9 Apr 2009 06:58:37 +0300
>> Izik Eidus <ieidus@redhat.com> wrote:
>>
>>     
>>> KSM is a linux driver that allows dynamicly sharing identical memory
>>> pages between one or more processes.
>>>       
>> Generally looks OK to me.  But that doesn't mean much.  We should rub
>> bottles with words like "hugh" and "nick" on them to be sure.
>>     
>
> I haven't looked too closely at it yet sorry. Hugh has a great eye for
> these details, though, hint hint :)
>
> As everyone knows, my favourite thing is to say nasty things about any
> new feature that adds complexity to common code.

The whole idea and the way i wrote it so it wont touch common code, i 
didnt change the linux mm logic no where.
The worst thing that we have add is helper functions.

>  I feel like crying to
> hear about how many more instances of MS Office we can all run, if only
> we apply this patch.

And more instances of linux guests...

>  And the poorly written HPC app just sounds like
> scrapings from the bottom of justification barrel.
>   

So if you have a big rendering application that load gigas of 
geometrical data that is handled by many threads
and you have a case that each thread sometimes change this geometrical 
data and you dont want the other threads will notice it.
How would you share it in traditional way?, after one time shared data 
will get cowed, how will you recollect it again when it become identical?
KSM do it for applications transparently

KSM writing motivation indeed was KVM where there it is highly needed 
you may check what VMware say about the fact that they have much better 
overcommit than Hyper-V / XEN:

http://blogs.vmware.com/virtualreality/2008/03/cheap-hyperviso.html

It is important to understand that in virtualization enviorments there 
are cases where memory is much more critical than any other resource for 
higher density.

Together with KSM, KVM will have the same memory overcommit abilitys 
such as VMware have.
> I'm sorry, maybe I'm way off with my understanding of how important
> this is. There isn't too much help in the changelog. A discussion of
> where the memory savings comes from,

Memory saving come from identical librarys, identical kernels, zeroed 
pages -> that is for virtualization.
The Librarys code will always be identical among similar guests, so why 
have this code at multiple places on the host memory?

>  and how far does things like
> sharing of fs image, or ballooning goes and how much extra savings we
> get from this...

Ballooning is much worse when it come to performance, beacuse what it 
does is shrink the guest memory, with KSM we find identical pages and 
merge them into one page, so we dont get guest performance lose

>  with people from other hypervisors involved as well.
> Have I missed this kind of discussion?
>
> Careful what you wish for, ay? :)
>   

