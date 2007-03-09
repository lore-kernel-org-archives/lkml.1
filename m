Return-Path: <linux-kernel-owner+w=401wt.eu-S1767640AbXCIXT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767640AbXCIXT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767642AbXCIXT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:19:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767640AbXCIXT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:19:26 -0500
Message-ID: <45F1EA32.8080108@redhat.com>
Date: Fri, 09 Mar 2007 18:13:54 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org> <20070309210430.GA14905@elte.hu> <20070309212714.GU10574@sequoia.sous-sol.org> <20070309214704.GA20988@elte.hu> <20070309221046.GV10574@sequoia.sous-sol.org> <20070309222435.GB24341@elte.hu>
In-Reply-To: <20070309222435.GB24341@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> ok, sure, how about the one i mentioned: long-term i'd like to have a 
> paravirt model where the guest does not store /any/ page tables - all 
> paging is managed by the hypervisor. The guest has a vma tree, but 
> otherwise it does not process pagefaults, has no concept of a pte (if in 
> paravirt mode), has no concept of kernel page tables either: there are 
> hypercalls to allocate/free guest-kernel memory, etc. This needs some 
> (serious) MM surgery but it's doable and it's interesting as well.  How
> would you map this to the VMI backend?

Ugh!

In a situation like that, how does the guest handle pageouts?

What about the dirty and accessed bits?

I'm guessing VMI would deal with this kind of abstraction in
exactly the same way we do the "native hardware" layer behind
paravirt_ops.  Ie. this example is a red herring.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
