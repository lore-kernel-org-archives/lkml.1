Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbZLWKXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbZLWKXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 05:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbZLWKXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 05:23:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667AbZLWKXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 05:23:41 -0500
Message-ID: <4B31EF65.6070000@redhat.com>
Date: Wed, 23 Dec 2009 12:22:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Anthony Liguori <anthony@codemonkey.ws>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <87637zdy9g.fsf@basil.nowhere.org> <4B30E654.40702@codemonkey.ws> <200912221701.56840.bzolnier@gmail.com> <4B30F214.80206@codemonkey.ws> <20091223065129.GA19600@elte.hu> <20091223101340.GC20539@basil.fritz.box>
In-Reply-To: <20091223101340.GC20539@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 12:13 PM, Andi Kleen wrote:
>> i.e. it has all the makings of a stupid, avoidable, permanent fork. The thing
>>      
> Nearly. There was no equivalent of a kernel based virtual driver host
> before.
>    

These are guest drivers.  We have virtio drivers, and Xen drivers (which 
are Xen-specific).

>> - Are a pure software concept and any compatibility mismatch is
>>    self-inflicted. The patches are in fact breaking the ABI to KVM
>>      
> In practice, especially considering older kernel releases, VMs
> behave like hardware, with all its quirks, compatibility requirements,
> sometimes not fully understood, etc.
>    

There was no attempt by Gregory to improve virtio-net.

>> It's a bit as if someone found a performance problem with sys_open() and came
>> up with sys_open_v2() and claimed that he wants to work with the VFS
>> developers while not really doing so but advances sys_open_v2() all the time.
>>      
> AFAIK Gregory tried for several months to work with the KVM maintainers,
> but failed at their NIH filter.
>    

It was the backwards compatibility, live migration, unneeded complexity, 
and scalability filters from where I sit.  vbus fails on all four.

>> The main difference is that Gregory claims that improved performance is not
>> possible within the existing KVM framework, while the KVM developers disagree.
>> The good news is that this is a hard, testable fact.
>>      
> Yes clearly the onus at this point is on the vhost-net developers/
> "pci is all that is ever needed for PV" proponents to show similar numbers
> with their current code.
>
> If they can show the same performance there's really no need for
> the alacrityvm model (or at least I haven't seen a convincing reason
> other than performance so far to have a separate model)
>    

Anthony posted this:

http://www.redhat.com/f/pdf/summit/cwright_11_open_source_virt.pdf

See slide 32.  This is without vhost-net.

-- 
error compiling committee.c: too many arguments to function

