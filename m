Return-Path: <linux-kernel-owner+w=401wt.eu-S932710AbZJNMe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbZJNMe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 08:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbZJNMe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 08:34:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbZJNMe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 08:34:26 -0400
Message-ID: <4AD5C4ED.3050809@redhat.com>
Date: Wed, 14 Oct 2009 21:32:45 +0900
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Zach Brown <zach.brown@oracle.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add	vsyscall	implementation
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>	<1254790211-15416-4-git-send-email-jeremy.fitzhardinge@citrix.com>	<4ACB0833.2050203@redhat.com>	<4ACB9074.1000804@goop.org>	<4ACC6C9C.7080707@redhat.com>	<4ACFD43E.6000506@goop.org> <4AD0CDFB.9030704@redhat.com>	<4AD3738B.6050200@goop.org> <4AD375A5.8050205@redhat.com> <4AD37FE3.1010002@goop.org> <4AD420A4.7050508@redhat.com> <4AD4DC52.8090508@goop.org>
In-Reply-To: <4AD4DC52.8090508@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2009 05:00 AM, Jeremy Fitzhardinge wrote:
>
>> So it's broken or disabled when that assumption is wrong?  We could
>> easily fix that now.  Might even reuse the pvclock structures.
>>      
> Well, the kernel internally makes more or less the same assumption; the
> vsyscall clocksource is the same as the kernel's internal one.  I think
> idea is that it just drops back to something like hpet if the tsc
> doesn't have very simple SMP characteristics.
>
> If the kernel could characterize the per-cpu properties of the tsc more
> accurately, then it could use the pvclock mechanism on native.
>    

It does - that's how kvm implements pvclock on the host side.  See 
kvmclock_cpufreq_notifier() in arch/x86/kvm/x86.c.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

