Return-Path: <linux-kernel-owner+w=401wt.eu-S1762986AbZJOTSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762986AbZJOTSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762977AbZJOTSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:18:12 -0400
Received: from claw.goop.org ([74.207.240.146]:44170 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762976AbZJOTSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:18:09 -0400
Message-ID: <4AD7754B.20701@goop.org>
Date: Thu, 15 Oct 2009 12:17:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@redhat.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock:	add	vsyscall	implementation
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>	<1254790211-15416-4-git-send-email-jeremy.fitzhardinge@citrix.com>	<4ACB0833.2050203@redhat.com>	<4ACB9074.1000804@goop.org>	<4ACC6C9C.7080707@redhat.com>	<4ACFD43E.6000506@goop.org>	<4AD0CDFB.9030704@redhat.com>	<4AD3738B.6050200@goop.org>	<4AD375A5.8050205@redhat.com> <4AD37FE3.1010002@goop.org>	<4AD420A4.7050508@redhat.com> <4AD4DC52.8090508@goop.org> <4AD5C4ED.3050809@redhat.com>
In-Reply-To: <4AD5C4ED.3050809@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/09 05:32, Avi Kivity wrote:
> On 10/14/2009 05:00 AM, Jeremy Fitzhardinge wrote:
>>
>>> So it's broken or disabled when that assumption is wrong?  We could
>>> easily fix that now.  Might even reuse the pvclock structures.
>>>      
>> Well, the kernel internally makes more or less the same assumption; the
>> vsyscall clocksource is the same as the kernel's internal one.  I think
>> idea is that it just drops back to something like hpet if the tsc
>> doesn't have very simple SMP characteristics.
>>
>> If the kernel could characterize the per-cpu properties of the tsc more
>> accurately, then it could use the pvclock mechanism on native.
>>    
>
> It does - that's how kvm implements pvclock on the host side.  See
> kvmclock_cpufreq_notifier() in arch/x86/kvm/x86.c.

The tsc clocksource currently seems a fair bit more picky though; it
doesn't attempt to sync tscs or work out their relative offsets or
rates.  Which seems a bit defeatist.

    J
