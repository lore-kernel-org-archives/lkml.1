Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbZFGJOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbZFGJOw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 05:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbZFGJOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 05:14:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37328 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbZFGJOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 05:14:41 -0400
Date: Sun, 7 Jun 2009 11:13:49 +0200
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
Message-ID: <20090607091349.GA26897@elte.hu>
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain> <4A25564A.70608@eu.citrix.com> <alpine.LFD.2.01.0906021033230.3351@localhost.localdomain> <alpine.LFD.2.01.0906021053050.3351@localhost.localdomain> <4A257687.2030801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A257687.2030801@redhat.com>
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

> Linus Torvalds wrote:
>> The point? Xen really is horribly badly separated out. It gets way more 
>> incestuous with other systems than it should. It's entirely possible 
>> that this is very fundamental to both paravirtualization and to 
>> hypervisor behavior, but it doesn't matter - it just measn that I can 
>> well see that Xen is a f*cking pain to merge.
>>
>> So please, Xen people, look at your track record, and look at the 
>> issues from the standpoint of somebody merging your code, rather 
>> than just from the standpoint of somebody who whines "I want my 
>> code to be merged".
>>
>> IOW, if you have trouble getting your code merged, ask yourself 
>> what _you_ are doing wrong.
>
> There is in fact a way to get dom0 support with nearly no changes 
> to Linux, but it involves massive changes to Xen itself and 
> requires hardware support: run dom0 as a fully virtualized guest, 
> and assign it all the resources dom0 can access.  It's probably a 
> massive effort though.
>
> I've considered it for kvm when faced with the "I want a thin 
> hypervisor" question: compile the hypervisor kernel with PCI 
> support but nothing else (no CONFIG_BLOCK or CONFIG_NET, no device 
> drivers), load userspace from initramfs, and assign host devices 
> to one or more privileged guests.  You could probably run the host 
> with a heavily stripped configuration, and enjoy the slimness 
> while every interrupt invokes the scheduler, a context switch, and 
> maybe an IPI for good measure.

This would be an acceptable model i suspect, if someone wants a 
'slim hypervisor'.

We can context switch way faster than we handle IRQs. Plus in a 
slimmed-down config we could intentionally slim down aspects of the 
scheduler as well, if it ever became a measurable performance issue. 
The hypervisor would run a minimal user-space and most of the 
context-switching overhead relates to having a full-fledged 
user-space with rich requirements. So there's no real conceptual 
friction between a 'lean and mean' hypervisor and a full-featured 
native kernel.

This would certainly be an utterly clean design, and it would be 
interesting to see a Linux/Xen + Linux/Dom0 combo engineered in such 
a way - if people really find this layered kernel approach 
interesting. So the door is not closed to dom0 at all - but it has 
to be designed cleanly without messing up the native kernel.

	Ingo
