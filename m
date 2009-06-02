Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbZFBRyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbZFBRyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 13:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbZFBRy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 13:54:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753916AbZFBRy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 13:54:28 -0400
Date: Tue, 2 Jun 2009 10:46:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: George Dunlap <george.dunlap@eu.citrix.com>
cc: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>,
       "jeremy@goop.org" <jeremy@goop.org>, "mingo@elte.hu" <mingo@elte.hu>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "avi@redhat.com" <avi@redhat.com>,
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
In-Reply-To: <4A25564A.70608@eu.citrix.com>
Message-ID: <alpine.LFD.2.01.0906021033230.3351@localhost.localdomain>
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain>
 <4A25564A.70608@eu.citrix.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Jun 2009, George Dunlap wrote:
>
> idea that changes shouldn't introduce performance regressions.  But there are
> patchqueues that are ready, signed-off by other maintainers, and which Ingo
> admits that he has no technical objections to, but refuses to merge. 

I've seen technical objects in this thread. The whole thing _started_ with 
one, and Thomas brought up others.

As a top-level maintainer, I can also very much sympathise with the "don't 
merge new stuff if there are known problems and no known solutions to 
those issues". Is Ingo supposed to just continue to merge crap, when it's 
admitted that it has problems and pollutes code that he has to maintain?

The fact is (and this is a _fact_): Xen is a total mess from a development 
standpoint. I talked about this in private with Jeremy. Xen pollutes the 
architecture code in ways that NO OTHER subsystem does. And I have never 
EVER seen the Xen developers really acknowledge that and try to fix it.

Thomas pointed to patches that add _explicitly_ Xen-related special cases 
that aren't even trying to make sense. See the local apic thing. 

So quite frankly, I wish some of the Xen people looked themselves in the 
mirror, and then asked themselves "would _I_ merge something ugly like 
that, if it was filling my subsystem with totally unrelated hacks for some 
other crap"?

Seriously.

If it was just the local APIC, fine. But it may be just the local APIC 
code this time around, next time it will be something else. It's been TLB, 
it's been entry_*.S, it's been all over. Some of them are performance 
issues.

I dunno. I just do know that I pointed out the statistics for how 
mindlessly incestuous the Xen patches have historically been to Jeremy. He 
admitted it. I've not seen _anybody_ say that things will improve. 

Xen has been painful. If you give maintainers pain, don't expect them to 
love you or respect you.

So I would really suggest that Xen people should look at _why_ they are 
giving maintainers so much pain.

		Linus
