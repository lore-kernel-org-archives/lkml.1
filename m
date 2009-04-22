Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbZDVNcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbZDVNcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 09:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZDVNcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 09:32:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:3090 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZDVNcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:32:22 -0400
Message-ID: <49EF1C5F.3070805@codemonkey.ws>
Date: Wed, 22 Apr 2009 08:32:15 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Huang Ying <ying.huang@intel.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] Add MCE support to KVM
References: <1239953345.6842.3.camel@yhuang-dev.sh.intel.com> <49E9F7BE.4090904@codemonkey.ws> <49EAE334.9020803@redhat.com> <49EDF057.9060501@codemonkey.ws> <49EDF287.9020908@redhat.com> <49EE2497.3060009@codemonkey.ws> <49EE25CB.6070709@redhat.com> <49EE27C2.3060505@codemonkey.ws> <49EE304D.5060108@redhat.com> <49EE3794.1070904@codemonkey.ws> <49EEB1BC.7020709@redhat.com>
In-Reply-To: <49EEB1BC.7020709@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>
> The refactoring, absolutely.  But if I have kernel support for zero 
> copy tomorrow, do I wait until qemu completes refactoring the VLAN 
> API, or do I hack something in so I can test it and get the benefit to 
> users?

Why can't we do this in upstream QEMU though?  Part of the point I'm 
trying to make here is that what QEMU is can be flexible.  We can find 
ways to include functionality that might not be ready for prime time by 
making it conditionally compiled, only available when using KVM, etc.  
It's all open for discussion.  So I'll be quite blunt about it, what 
needs to change about what QEMU takes and doesn't take in order to get 
rid of kvm-userspace?

Experimentation is a good thing.  It's also important to do things the 
right way as early as possible though because the longer users depend on 
something, the harder it is to change later.  I think it's easier to 
strike that balance in upstream QEMU than trying to port things from 
kvm-userspace over to QEMU after the fact.

>>
>> The only reasonable things to do IMHO is for as much as humanly 
>> possible to be deferred to QEMU or for you to comes to terms with 
>> your role as a defacto QEMU maintainer and start pushing back more on 
>> patch sets that don't take into consideration TCG/non-KVM 
>> environments :-)
>
> I do that whenever possible -- and it most often is possible.
>
> But neither kvm nor tcg are not going to be supersets of the other.  
> Of course qemu is not a subset of kvm as it has a much wider 
> target/host variety.  But also kvm will always have features that tcg 
> does not have.  For example AVX is easy to implement with a few lines 
> in the kernel and qemu, but would take a massive effort in tcg.  It 
> would have a large performance impact for AVX-enabled 
> apps/guests/hosts combinations, not so much for tcg.
>
> kvm wants features for large-scale production deployment.  This means 
> focus on performance and managebility.  qemu/tcg is more for hobbyist 
> use or as a developer tool for developing operating system kernels.  
> This means more focus on ease of use.

We can have KVM specific features in QEMU when that makes sense.  In the 
case of MCE, it doesn't make any sense because it's relatively simple 
and the implementation can be common given the right interfaces.

>>
>> MCE is a perfect example of something that really has no reason to go 
>> in via kvm-userspace since we have enough KVM support in upstream QEMU. 
>
> I agree.  But the requirement that everything in kvm have a 
> counterpart in tcg is not realistic.  The primary use of MCE for 
> example is used to allow a guest to survive bad hardware.  I don't see 
> this as being useful in any way on qemu/tcg.  A secondary is is to 
> debug mce handling in guests OSes; now this is useful with tcg, but 
> I'd hesitate to call it a requirement, it's more of a nice to have.

There is no requirement that everything have a counter part in TCG.

Regards,

Anthony Liguori
