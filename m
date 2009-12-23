Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbZLWVC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbZLWVC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbZLWVCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:02:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbZLWVCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:02:25 -0500
Message-ID: <4B328535.5040105@redhat.com>
Date: Wed, 23 Dec 2009 23:01:41 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Anthony Liguori <anthony@codemonkey.ws>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <87637zdy9g.fsf@basil.nowhere.org> <4B30E654.40702@codemonkey.ws> <200912221701.56840.bzolnier@gmail.com> <4B30F214.80206@codemonkey.ws> <20091223065129.GA19600@elte.hu> <4B3248F9.5030504@gmail.com> <4B327F3A.9020101@redhat.com>
In-Reply-To: <4B327F3A.9020101@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 10:36 PM, Avi Kivity wrote:
> On 12/23/2009 06:44 PM, Gregory Haskins wrote:
>>
>>>   - Are a pure software concept
>> By design.  In fact, I would describe it as "software to software
>> optimized" as opposed to trying to shoehorn into something that was
>> designed as a software-to-hardware interface (and therefore has
>> assumptions about the constraints in that environment that are not
>> applicable in software-only).
>>
>
> And that's the biggest mistake you can make.  Look at Xen, for 
> instance.  The paravirtualized the fork out of everything that moved 
> in order to get x86 virt going.  And where are they now? x86_64 
> syscalls are slow since they have to trap to the hypervisor and 
> (partially) flush the tlb.  With npt or ept capable hosts performance 
> is better for many workloads on fullvirt.  And paravirt doesn't 
> support Windows.  Their unsung hero Jeremy is still trying to upstream 
> dom0 Xen support.  And they get to support it forever.
>
> VMware stuck with the hardware defined interfaces.  Sure they had to 
> implement binary translation to get there, but as a result, they only 
> have to support one interface, all guests support it, and they can 
> drop it on newer hosts where it doesn't give them anything.

As a twist on this, the VMware paravirt driver interface is so 
hardware-like that they're getting hardware vendors to supply cards that 
implement it.  Try that with a pure software approach.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

