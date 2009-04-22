Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbZDVOCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbZDVOCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 10:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbZDVN6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 09:58:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43856 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709AbZDVN6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:58:37 -0400
Message-ID: <49EF227E.4020501@redhat.com>
Date: Wed, 22 Apr 2009 16:58:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Huang Ying <ying.huang@intel.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] Add MCE support to KVM
References: <1239953345.6842.3.camel@yhuang-dev.sh.intel.com> <49E9F7BE.4090904@codemonkey.ws> <49EAE334.9020803@redhat.com> <49EDF057.9060501@codemonkey.ws> <49EDF287.9020908@redhat.com> <49EE2497.3060009@codemonkey.ws> <49EE25CB.6070709@redhat.com> <49EE27C2.3060505@codemonkey.ws> <49EE304D.5060108@redhat.com> <49EE3794.1070904@codemonkey.ws> <49EEB1BC.7020709@redhat.com> <49EF1C5F.3070805@codemonkey.ws>
In-Reply-To: <49EF1C5F.3070805@codemonkey.ws>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Avi Kivity wrote:
>>
>> The refactoring, absolutely.  But if I have kernel support for zero 
>> copy tomorrow, do I wait until qemu completes refactoring the VLAN 
>> API, or do I hack something in so I can test it and get the benefit 
>> to users?
>
> Why can't we do this in upstream QEMU though?  Part of the point I'm 
> trying to make here is that what QEMU is can be flexible.  

If we do it the right way, it takes time, and we serialize development 
(for example, we don't find and fix bugs in the kernel).
We don't want to do it the wrong way.

> We can find ways to include functionality that might not be ready for 
> prime time by making it conditionally compiled, only available when 
> using KVM, etc.  It's all open for discussion.  So I'll be quite blunt 
> about it, what needs to change about what QEMU takes and doesn't take 
> in order to get rid of kvm-userspace?

#ifdefs in master, an experimental branch, and kvm-userspace (soon, 
qemu-kvm) are all equivalent.

There's even an option to diff(1) to generate #ifdefs instead of the 
traditional diff markers.

> Experimentation is a good thing.  It's also important to do things the 
> right way as early as possible though because the longer users depend 
> on something, the harder it is to change later.  I think it's easier 
> to strike that balance in upstream QEMU than trying to port things 
> from kvm-userspace over to QEMU after the fact.

Well, let's take it on a case by case basis.  I certainly prefer to see 
everything go to qemu.git.  If we find a case where it isn't workable, 
qemu-kvm.git can be a temporary home.

> We can have KVM specific features in QEMU when that makes sense.  In 
> the case of MCE, it doesn't make any sense because it's relatively 
> simple and the implementation can be common given the right interfaces.

The kvm kernel module doesn't have common implementation for qemu/tcg 
and qemu/kvm as one of its goals.  It doesn't know anything about qemu.  
It wants to export an interface that makes sense (is as close to the cpu 
model as possible).

The few places that we inadvertently let qemuisms slip through turned 
out to be mistakes.

I agree that MCE is simple so it's easy to implement in both.  But the 
other features may be different.

-- 
error compiling committee.c: too many arguments to function

