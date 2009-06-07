Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbZFGKhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbZFGKhI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 06:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbZFGKg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 06:36:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54369 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619AbZFGKg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 06:36:57 -0400
Date: Sun, 7 Jun 2009 12:35:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20090607103547.GR31286@elte.hu>
References: <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain> <4A25564A.70608@eu.citrix.com> <alpine.LFD.2.01.0906021033230.3351@localhost.localdomain> <alpine.LFD.2.01.0906021053050.3351@localhost.localdomain> <4A257687.2030801@redhat.com> <20090607091349.GA26897@elte.hu> <4A2B9001.7090706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2B9001.7090706@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> Ingo Molnar wrote:
>>> There is in fact a way to get dom0 support with nearly no changes to 
>>> Linux, but it involves massive changes to Xen itself and requires 
>>> hardware support: run dom0 as a fully virtualized guest, and assign 
>>> it all the resources dom0 can access.  It's probably a massive effort 
>>> though.
>>>
>>> I've considered it for kvm when faced with the "I want a thin  
>>> hypervisor" question: compile the hypervisor kernel with PCI support 
>>> but nothing else (no CONFIG_BLOCK or CONFIG_NET, no device drivers), 
>>> load userspace from initramfs, and assign host devices to one or more 
>>> privileged guests.  You could probably run the host with a heavily 
>>> stripped configuration, and enjoy the slimness while every interrupt 
>>> invokes the scheduler, a context switch, and maybe an IPI for good 
>>> measure.
>>>     
>>
>> This would be an acceptable model i suspect, if someone wants a 'slim 
>> hypervisor'.
>>
>> We can context switch way faster than we handle IRQs. Plus in a  
>> slimmed-down config we could intentionally slim down aspects of the  
>> scheduler as well, if it ever became a measurable performance issue.  
>> The hypervisor would run a minimal user-space and most of the  
>> context-switching overhead relates to having a full-fledged user-space 
>> with rich requirements. So there's no real conceptual friction between 
>> a 'lean and mean' hypervisor and a full-featured native kernel.
>>   
>
> The context switch would be taken by the Xen scheduler, not the Linux  
> scheduler. [...]

The 'slim hypervisor' model i was suggesting was a slimmed down 
_Linux_ kernel.

	Ingo
