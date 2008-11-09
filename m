Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbYKILYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbYKILYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 06:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbYKILX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 06:23:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42530 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbYKILXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 06:23:55 -0500
Message-ID: <4916C822.4080609@redhat.com>
Date: Sun, 09 Nov 2008 13:23:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Eduardo Habkost <ehabkost@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/16] x86: Emergency virtualization disable function
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com> <1225810364-8990-9-git-send-email-ehabkost@redhat.com> <m1bpwu3wod.fsf@frodo.ebiederm.org> <20081105175235.GJ5247@blackpad> <4912BD67.8000704@redhat.com> <m1mygd2lxs.fsf@frodo.ebiederm.org> <4912C75B.8050508@redhat.com> <20081106174538.GU5247@blackpad>
In-Reply-To: <20081106174538.GU5247@blackpad>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo Habkost wrote:
> On Thu, Nov 06, 2008 at 12:30:51PM +0200, Avi Kivity wrote:
>   
>> Eric W. Biederman wrote:
>>     
>>>> If you want to be extra simple and safe, remove kvm from the equation.  Make the
>>>> disabling code part of kdump/emergency_restart and only rely on the convention
>>>> that cr3.vmxe == vmxon.
>>>>     
>>>>         
>>> Convention?
>>>   
>>>       
>> There is a de-facto convention supported by at least vmware and kvm.  If  
>> cr4.vmxe is 1, then we are in vmx operation.  If cr4.vmxe is 0, then we  
>> are not in vmx operation.  This allows us to determine whether we need  
>> to execute vmxoff without any APIs.
>>     
>
> I am just worried about the probing needed to make sure CR4 is available
> (and that the CR4.VMXE bit means what we expect it to mean),

That's cpu_has_kvm_support() in vmx.c.  Should compile to three 
instructions.

>  before we
> try to read it and check VMXE. The same for SVM and the MSRs we need to
> touch to disable SVM.
>   

That's has_svm() in svm.c; slightly longer but not any more dangerous.

> I prefer to reuse code that already exists on KVM and is working than
> adding new probing code that I won't be able to test on all hardware
> configurations.
>   

We could move the code to a header file, and so compile it both for kvm 
and for emergency_restart/kdump.

-- 
error compiling committee.c: too many arguments to function

