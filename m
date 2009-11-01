Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbZKALbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbZKALbg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 06:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZKALbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 06:31:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbZKALbd (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 06:31:33 -0500
Message-ID: <4AED7178.2060906@redhat.com>
Date: Sun, 01 Nov 2009 13:31:04 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Theurer <habanero@linux.vnet.ibm.com>, kvm@vger.kernel.org,
       Linux-kernel@vger.kernel.org
Subject: Re: kernel bug in kvm_intel
References: <4ACF9745.3050902@linux.vnet.ibm.com> <4AD16ACE.6040903@redhat.com> <1255372957.4883.49.camel@twinturbo.austin.ibm.com> <4AD4231F.6040608@redhat.com> <1255442640.4883.56.camel@twinturbo.austin.ibm.com> <4AD6061D.5070306@redhat.com> <1255637909.4883.129.camel@twinturbo.austin.ibm.com> <1256926052.4883.203.camel@twinturbo.austin.ibm.com> <4AEC5C24.9080506@redhat.com> <4AEC64FC.7070908@linux.vnet.ibm.com> <4AEC6699.6000202@redhat.com> <4AEC6821.7010801@redhat.com> <4AED5C3F.9050506@kernel.org> <4AED6100.6040804@redhat.com> <4AED66D0.20704@kernel.org>
In-Reply-To: <4AED66D0.20704@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2009 12:45 PM, Tejun Heo wrote:
> Hello,
>
> Avi Kivity wrote:
>    
>> We get a page fault immediately (next instruction) after returning from
>> the guest when running with oprofile.  The page fault address does not
>> match anything the instruction does, so presumably it is one of the
>> accesses the processor performs in order to service an NMI (ordinary
>> interrupts are masked; and the fact that it happens with oprofile
>> strengthens this assumption).
>>      
> Ah... okay, that's tricky but IIRC faults like that can be
> distinguished from regular ones via processor state, right?
>    

Not on x86.  But given that the fault address is different from %rsp 
(which is what the instruction accesses) and %rip, there aren't many 
alternatives.

>> Here is the code in question:
>>
>>      
>>>      3ae7:       75 05                   jne    3aee<vmx_vcpu_run+0x26a>
>>>        3ae9:       0f 01 c2                vmlaunch
>>>        3aec:       eb 03                   jmp    3af1<vmx_vcpu_run+0x26d>
>>>        3aee:       0f 01 c3                vmresume
>>>        3af1:       48 87 0c 24             xchg   %rcx,(%rsp)
>>>        
>> ^^^ fault, but not at (%rsp)
>>      
> Can you please post the full oops (including kernel debug messages
> during boot) or give me a pointer to the original message?

http://www.mail-archive.com/kvm@vger.kernel.org/msg23458.html

> Also, does
> the faulting address coincide with any symbol?
>    

No (at least, not in System.map).

-- 
error compiling committee.c: too many arguments to function

