Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbZFGMsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbZFGMsh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 08:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbZFGMsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:48:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46038 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216AbZFGMsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:48:19 -0400
Message-ID: <4A2BB6B1.4040805@redhat.com>
Date: Sun, 07 Jun 2009 15:46:41 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       George Dunlap <george.dunlap@eu.citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, "jeremy@goop.org" <jeremy@goop.org>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
       ksrinivasan <ksrinivasan@novell.com>,
       "EAnderson@novell.com" <EAnderson@novell.com>,
       "wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: Xen is a feature
References: <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain> <4A25564A.70608@eu.citrix.com> <alpine.LFD.2.01.0906021033230.3351@localhost.localdomain> <alpine.LFD.2.01.0906021053050.3351@localhost.localdomain> <4A257687.2030801@redhat.com> <20090607091349.GA26897@elte.hu> <4A2B9001.7090706@redhat.com> <20090607103547.GR31286@elte.hu>
In-Reply-To: <20090607103547.GR31286@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@redhat.com> wrote:
>
>   
>> Ingo Molnar wrote:
>>     
>>>> There is in fact a way to get dom0 support with nearly no changes to 
>>>> Linux, but it involves massive changes to Xen itself and requires 
>>>> hardware support: run dom0 as a fully virtualized guest, and assign 
>>>> it all the resources dom0 can access.  It's probably a massive effort 
>>>> though.
>>>>
>>>> I've considered it for kvm when faced with the "I want a thin  
>>>> hypervisor" question: compile the hypervisor kernel with PCI support 
>>>> but nothing else (no CONFIG_BLOCK or CONFIG_NET, no device drivers), 
>>>> load userspace from initramfs, and assign host devices to one or more 
>>>> privileged guests.  You could probably run the host with a heavily 
>>>> stripped configuration, and enjoy the slimness while every interrupt 
>>>> invokes the scheduler, a context switch, and maybe an IPI for good 
>>>> measure.
>>>>     
>>>>         
>>> This would be an acceptable model i suspect, if someone wants a 'slim 
>>> hypervisor'.
>>>
>>> We can context switch way faster than we handle IRQs. Plus in a  
>>> slimmed-down config we could intentionally slim down aspects of the  
>>> scheduler as well, if it ever became a measurable performance issue.  
>>> The hypervisor would run a minimal user-space and most of the  
>>> context-switching overhead relates to having a full-fledged user-space 
>>> with rich requirements. So there's no real conceptual friction between 
>>> a 'lean and mean' hypervisor and a full-featured native kernel.
>>>   
>>>       
>> The context switch would be taken by the Xen scheduler, not the Linux  
>> scheduler. [...]
>>     
>
> The 'slim hypervisor' model i was suggesting was a slimmed down 
> _Linux_ kernel.
>   

Yeah, I lost the context.  I should reduce my own context switching.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

