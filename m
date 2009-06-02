Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbZFBTGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbZFBTGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 15:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbZFBTG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 15:06:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55997 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbZFBTG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 15:06:26 -0400
Message-ID: <4A257687.2030801@redhat.com>
Date: Tue, 02 Jun 2009 21:59:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: George Dunlap <george.dunlap@eu.citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, "jeremy@goop.org" <jeremy@goop.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
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
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain> <4A25564A.70608@eu.citrix.com> <alpine.LFD.2.01.0906021033230.3351@localhost.localdomain> <alpine.LFD.2.01.0906021053050.3351@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906021053050.3351@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> The point? Xen really is horribly badly separated out. It gets way more 
> incestuous with other systems than it should. It's entirely possible that 
> this is very fundamental to both paravirtualization and to hypervisor 
> behavior, but it doesn't matter - it just measn that I can well see that 
> Xen is a f*cking pain to merge.
>
> So please, Xen people, look at your track record, and look at the issues 
> from the standpoint of somebody merging your code, rather than just from 
> the standpoint of somebody who whines "I want my code to be merged".
>
> IOW, if you have trouble getting your code merged, ask yourself what _you_ 
> are doing wrong.
>   

There is in fact a way to get dom0 support with nearly no changes to 
Linux, but it involves massive changes to Xen itself and requires 
hardware support: run dom0 as a fully virtualized guest, and assign it 
all the resources dom0 can access.  It's probably a massive effort though.

I've considered it for kvm when faced with the "I want a thin 
hypervisor" question: compile the hypervisor kernel with PCI support but 
nothing else (no CONFIG_BLOCK or CONFIG_NET, no device drivers), load 
userspace from initramfs, and assign host devices to one or more 
privileged guests.  You could probably run the host with a heavily 
stripped configuration, and enjoy the slimness while every interrupt 
invokes the scheduler, a context switch, and maybe an IPI for good measure.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

