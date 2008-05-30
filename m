Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbYE3Tkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbYE3Tkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 15:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbYE3Tk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 15:40:27 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:24634 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbYE3Tk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 15:40:26 -0400
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>, chucklever@gmail.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-Id: <CEA741EF-8E34-40FD-82A8-747AE1B6E78F@oracle.com>
From: Chuck Lever <chuck.lever@oracle.com>
To: Dave Jones <davej@redhat.com>
In-Reply-To: <20080530190314.GC32480@redhat.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v924)
Subject: Re: NFS oops in 2.6.26rc4
Date: Fri, 30 May 2008 15:37:01 -0400
References: <20080527190419.GA14577@redhat.com> <76bd70e30805301059v461e8f0eocc38b6fe36dd3b21@mail.gmail.com> <20080530182126.GB32480@redhat.com> <1212172308.8579.20.camel@localhost> <20080530190314.GC32480@redhat.com>
X-Mailer: Apple Mail (2.924)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 30, 2008, at 3:03 PM, Dave Jones wrote:
> On Fri, May 30, 2008 at 11:31:48AM -0700, Trond Myklebust wrote:
>> On Fri, 2008-05-30 at 14:21 -0400, Dave Jones wrote:
>>
>>> mount point in the fstab is ..
>>>
>>> gelk:/mnt/data      /mnt/nfs/gelk       nfs      
>>> nfsvers=3,tcp        0 0
>>>
>>>> What "brand" of server were you trying to mount?
>>>
>>> It's just another linux box. A no-name core2 duo, running 2.6.25.
>>>
>>>> How often can you reproduce this?
>>>
>>> Seems to do it every time I ask it to.
>>
>> Could you provide us with a binary tcpdump in that case? I'd love to
>> have a look at the actual filehandle the server is producing.
>
> This is from the client side: http://www.codemonkey.org.uk/junk/ 
> tcp.out
> Wireshark picks up some of those packets as being 'malformed', which
> could be a clue ?

Wireshark is overly cautious, and sometimes throws spurious warnings.

> Something else of note which I hadn't seen before, usually things lock
> up just after that first oops. For some reason, today it survived
> a little longer, but things really went downhill fast.
> It survived a 'dmesg ; scp dmesg davej@gelk', and then wedged solid.
> So as well as the oops, it seems we're corrupting memory too.
> For reference, this kernel has both SLUB_DEBUG and PAGEALLOC_DEBUG  
> enabled.

I haven't seen this kind of problem here with .26, but yes, it does  
look like something is clobbering memory during an NFS mount.

I introduced some NFS mount parsing changes in this commit range:

   2d767432..82d101d5

A quick bisect should show which, if any of these, is the guilty  
party.  If any of these are the problem, I suspect it's 3f8400d1.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
