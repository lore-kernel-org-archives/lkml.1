Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905Ab0CMIVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 03:21:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758877Ab0CMIVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 03:21:17 -0500
Message-ID: <4B9B4AF4.60306@redhat.com>
Date: Sat, 13 Mar 2010 10:21:08 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Poor KVM guest performance on an HP rack server
References: <4B243B2B.806@pardus.org.tr> <4B24856A.4020507@goop.org> <4B24BE17.805@pardus.org.tr> <4B2532A0.2070001@goop.org> <4B9A775D.5070303@pardus.org.tr>
In-Reply-To: <4B9A775D.5070303@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2010 07:18 PM, Ozan Çağlayan wrote:
> Jeremy Fitzhardinge wrote:
>    
>> On 12/13/09 02:12, Ozan Çağlayan wrote:
>>      
>>> Hmm, that's because we're using/developing a Linux distribution which
>>> doesn't have 64-bit support yet. But since the guest will be a
>>> compile-farm for our needs, it's worth trying to run an 64-bit distro on
>>> the host to see the difference, thanks for the tip but how much should
>>> this affect the performance?
>>>        
>> 32-bit PAE is marginal above 4G of memory and the limit is at about 8G.
>> Above that, so much lowmem (<~1GB) is occupied by page and other kernel
>> structures that there's barely any memory to do any real work.  If this
>> is what's happening, you'd expect to see poor host performance, and slow
>> guest performance would be secondary to that.
>>      
> Updates on the issue after 3 months:
> ------------------------------------
>
> The host is now running an x86_64 2.6.32.9 kernel with kvm-2.6.32.7 built as an external module.
> The guest is 32-bit 2.6.32.9.
>    

You're running an old kvm on a new kernel.  It's simpler and better to 
run the kvm that came with 2.6.32.9.

> I've booted the guest with -smp 4 -m 4096
>
> and I'm seeing the same slowness that I've mentioned in this thread during CUPS configuration.
> I'll try to send kvm_stat output in this week and try the same configure on another guest OS to see if it differs or not.
>
> I'm also thinking to build an optimized 2.6.33 for that rack server to see if things get better or not.
>    

Better to find out what's wrong first and build kernels later.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

