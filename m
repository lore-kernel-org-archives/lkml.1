Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbZLWNbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbZLWNbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 08:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbZLWNbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 08:31:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917AbZLWNbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 08:31:32 -0500
Message-ID: <4B321B9F.6030707@redhat.com>
Date: Wed, 23 Dec 2009 15:31:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Anthony Liguori <anthony@codemonkey.ws>,
       Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <4B30F214.80206@codemonkey.ws> <20091223065129.GA19600@elte.hu> <200912231407.20130.bzolnier@gmail.com>
In-Reply-To: <200912231407.20130.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 03:07 PM, Bartlomiej Zolnierkiewicz wrote:
>
>> That is a very different situation from the AlacrityVM patches, which:
>>
>>   - Are a pure software concept and any compatibility mismatch is
>>     self-inflicted. The patches are in fact breaking the ABI to KVM
>>     intentionally (for better or worse).
>>      
> Care to explain the 'breakage' and why KVM is more special in this regard
> than other parts of the kernel (where we don't keep any such requirements)?
>    

The device model is exposed to the guest.  If you change it, the guest 
breaks.

So we have two options:
  - phase out virtio, users don't see new improvements, ask them to 
change to vbus/venet
  - maintain the two in parallel

Neither appeals to me.

> Truth to be told KVM is just another driver/subsystem and Gregory's changes
> are only 4KLOC of clean and easily maintainable code..
>    

This 4K is only the beginning.  There are five more virtio drivers, plus 
features in virtio-net not ported to venet, plus the host support, plus 
qemu support, plus Windows drivers, plus adapters for non-pci (lguest 
and s390), plus live migration support.  vbus itself still has scaling 
issues.

Virtio was under development for years.  Sure you can focus on one 
dimension only (performance) and get good results but real life is more 
complicated.

> I certainly missed the time when KVM became officially part of core ABI..
>    

It's more akin to the hardware interface.  We don't change the hardware 
underneath the guest.

>> Overlap and forking can still be done in special circumstances, when a project
>> splits and a hostile fork is inevitable due to prolongued and irreconcilable
>> differences between the parties and if there's no strong technical advantage
>> on either side. I havent seen evidence of this yet though: Gregory claims that
>> he wants to 'work with the community' and the KVM guys seem to agree violently
>> that performance can be improved - and are doing so (and are asking Gregory to
>> take part in that effort).
>>      
> How it is different from any past forks?
>
> The odium of proving that the existing framework is sufficient was always on
> original authors or current maintainers.
>
> KVM guys were offered assistance from Gregory and had few months to prove that
> they can get the same kind of performance using existing architecture and they
> DID NOT do it.
>    

Look at the results from Chris Wright's presentation.  Hopefully in a 
few days some results from vhost-net.

> Then please try harder.  Gregory posted his initial patches in August,
> it is December now and we only see artificial road-blocks instead of code
> from KVM folks.
>    

What artificial road blocks?

-- 
error compiling committee.c: too many arguments to function

