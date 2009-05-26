Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbZEZS2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbZEZS2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 14:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbZEZS15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 14:27:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55609 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148AbZEZS14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 14:27:56 -0400
Message-ID: <4A1C3453.6080402@redhat.com>
Date: Tue, 26 May 2009 21:26:27 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: George Dunlap <George.Dunlap@eu.citrix.com>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: [Xen-devel] Re: [GIT PULL] Xen APIC hooks (with io_apic_ops)
References: <1242170724-13349-1-git-send-email-jeremy@goop.org>	 <20090519123548.GA26439@elte.hu> <4A14447E.9060607@goop.org>	 <20090525041057.GD9396@elte.hu> <de76405a0905260546k56bc866bx1658ec13f65e3eec@mail.gmail.com>
In-Reply-To: <de76405a0905260546k56bc866bx1658ec13f65e3eec@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

George Dunlap wrote:
> As a simple example, take scheduling.  I'm about to re-write the Xen
> scheduler, and in the process I took a good look at the scheduler you
> wrote.  I think it's got a lot of really good ideas, which I plan to
> steal. :-)  However, I'm going to have to make some key changes in
> order for it to function well as a hypervisor scheduler.  If KVM is
> used on a production server with 20 or 30 multi-vcpu VMs, I predict
> the current scheduler will do very poorly, because it wasn't designed
> with VMs in mind, but with processes.  Making changes so that VMs run
> better will fundamentally make things that make processes run less
> well.
>   

The Linux scheduler already supports multiple scheduling classes.  If we 
find that none of them will fit our needs, we'll propose a new one.  
There are also multiple I/O schedulers, multiple allocators (perhaps a 
bad example), and multiple filesystems.

When the need can be demonstrated to be real, and the implementation can 
be clean, Linux can usually be adapted.

I think the Xen design has merit if it can truly make dom0 a guest -- 
that is, if it can survive dom0 failure.  Until then, you're just taking 
a large interdependent codebase and splitting it at some random point, 
but you don't get any stability or security in return.  It will also be 
interesting to see how far Xen can get along without real memory 
management (overcommit).

>> The whole Xen design is messed up really: you have taken off bits of
>> the Linux kernel you found interesting, turned them into a
>> micro-kernel in essence and renamed it to 'Xen'.
>>     
>
> That's how Xen started, and that's really the beauty of open-source.
> (After all, KVM has stolen some ideas from the Xen shadow code.)  But
> since then, basically all of the code has been replaced with
> Xen-written code.  I think if you did an SCO-style audit comparing
> Linux and Xen 3.4, you'd find a lot less in common than you think.
>   

A lot of the arch code is derived from Linux.

>> Xen isnt actually useful _at all_ without Linux/DOM0. Without Dom0
>> Xen is slow and native hardware support within Xen is virtually
>> non-existent, as you point out above.
>>     
>
> And qemu-kvm isn't useful _at_all_ without Linux either; and Linux-KVM
> isn't useful _at_all_ without qemu.  Your point?
>   

kvm is actually being used by other userspaces.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

