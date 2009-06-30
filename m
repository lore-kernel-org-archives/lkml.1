Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbZF3RO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbZF3RO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 13:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZF3ROs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 13:14:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35877 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbZF3ROr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 13:14:47 -0400
Message-ID: <4A4A4812.4070804@redhat.com>
Date: Tue, 30 Jun 2009 20:14:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Gleb Natapov <gleb@redhat.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4] enable x2APIC without interrupt remapping under KVM
References: <20090630064515.GG20289@redhat.com>	<86802c440906300018p8c5156dy3e8d84b8c263797e@mail.gmail.com>	<20090630155820.GC8122@redhat.com> <m11vp18xmp.fsf@fess.ebiederm.org>
In-Reply-To: <m11vp18xmp.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2009 08:00 PM, Eric W. Biederman wrote:
> Gleb Natapov<gleb@redhat.com>  writes:
>
>    
>> On Tue, Jun 30, 2009 at 12:18:19AM -0700, Yinghai Lu wrote:
>>      
>>> how about kexec second kernel in KVM ?
>>>
>>> x2apic_preenabled will be set in second kernel.
>>>
>>>        
>> By the way anybody knows why kexec does not use BIOS reset code
>> (cmos 0xf offset) to jump into new kernel after hard reset?
>>      
>
> After a hard reset.  That simply isn't possible. A hard
> reset clears everything even memory.
>
>    

So the jump-to-vector reset code cannot work on real hardware?  It works 
in qemu, but of course that's easy.

> You might be able to get a full cpu reset but not a reset of the I/O
> devices.
>
> The premise of kexec is that we are doing things on our own, and don't
> get a 3rd piece of software involved that has not been heavily tested
> on the path we want to use.  Occassionally it is a pain to do everything
> ourselves but at least when we do and we test it we know it is going
> to work.
>
> Cpu designers lately seem fond of adding features that require all
> kind of coordination to turn on and off.  We handle the hardware
> virtualization mode features now, and if x2apic has similar problems
> being turned on and off I am certain we can handle that case in a
> similar fashion.
>
> When we can my preference is to keep code like that out of the
> kexec on panic path if we can figure out how to write the software
> to do something reasonable.
>
> Once we figure out how to work without putting the interrupt controllers
> in legacy mode to handle the timer interrupts I expect all kinds of
> things will become simpler.
>    

I think it makes sense to add full reset support as a non-default 
option.  Leaving hardware running and dmaing left and right has its risks.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

