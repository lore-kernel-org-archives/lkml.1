Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbZJVQXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbZJVQXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 12:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756567AbZJVQXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 12:23:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755595AbZJVQXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 12:23:34 -0400
Message-ID: <4AE08708.6070302@redhat.com>
Date: Thu, 22 Oct 2009 18:23:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] allow userspace to adjust kvmclock offset
References: <1254849896-3947-1-git-send-email-glommer@redhat.com> <4AD2EE86.50807@redhat.com> <20091013122828.GZ8092@mothafucka.localdomain> <4AD4730C.9010305@redhat.com> <20091013124638.GC8092@mothafucka.localdomain> <4AD670FC.7010004@redhat.com> <20091015145855.GI8092@mothafucka.localdomain>
In-Reply-To: <20091015145855.GI8092@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2009 04:58 PM, Glauber Costa wrote:
>
>> The motivation for relative adjustment is when you have a jitter
>> resistant place to gather timing information (like the kernel, which can
>> disable interrupts and preemption), then pass it on to kvm without
>> losing information due to scheduling.  For migration there is no such
>> place since it involves two hosts, but it makes sense to support
>> relative adjustments.
>>      
> Since we added the padding you asked for, we could use that bit of information
> to define whether it will be a relative or absolute adjustment, then. Right now,
> I don't see the point of implementing a code path that will be completely untested.
>
> I'd leave it this way until someone comes up with a need.
>    

I agree with that, but padding by itself is insufficient.  You also need 
a flags field.

-- 
error compiling committee.c: too many arguments to function

