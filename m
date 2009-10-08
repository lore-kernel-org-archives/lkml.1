Return-Path: <linux-kernel-owner+w=401wt.eu-S932671AbZJHQ0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671AbZJHQ0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932538AbZJHQ0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:26:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454AbZJHQ0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:26:00 -0400
Message-ID: <4ACE127A.6040304@redhat.com>
Date: Thu, 08 Oct 2009 18:25:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] KVM: SVM: Notify nested hypervisor of lost event
 injections
References: <1254996199-17667-1-git-send-email-joerg.roedel@amd.com> <1254996199-17667-2-git-send-email-joerg.roedel@amd.com> <4ACE0F6C.3060103@redhat.com> <20091008162222.GG14073@amd.com>
In-Reply-To: <20091008162222.GG14073@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2009 06:22 PM, Joerg Roedel wrote:
> On Thu, Oct 08, 2009 at 06:12:28PM +0200, Avi Kivity wrote:
>    
>> On 10/08/2009 12:03 PM, Joerg Roedel wrote:
>>      
>>> From: Alexander Graf<agraf@suse.de>
>>>
>>> If event_inj is valid on a #vmexit the host CPU would write
>>> the contents to exit_int_info, so the hypervisor knows that
>>> the event wasn't injected.
>>>
>>> We don't do this in nested SVM by now which is a bug and
>>> fixed by this patch.
>>>        
>> We need to start thinking about regression tests for these bugs.  It
>> would be relatively easy to set up something with save->cr3 == cr3
>> (i.e. no isolation, mmu virtualization, etc.).
>>      
> Should be doable with a in-kernel regression test-suite module, I think.
> Triggering such (race-condition like) test cases from userspace is
> somewhat hard.
>
>    

Isn't it sufficient, for this case, to inject a nested interrupt when 
the nested idt is not mapped?

-- 
error compiling committee.c: too many arguments to function

