Return-Path: <linux-kernel-owner+w=401wt.eu-S1759071AbZFBPaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071AbZFBPaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbZFBPa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:30:29 -0400
Received: from www.tglx.de ([62.245.132.106]:46256 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457AbZFBPa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:30:27 -0400
Date: Tue, 2 Jun 2009 17:23:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: George Dunlap <george.dunlap@eu.citrix.com>
cc: David Miller <davem@davemloft.net>, "jeremy@goop.org" <jeremy@goop.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "avi@redhat.com" <avi@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
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
In-Reply-To: <4A1FCE8E.2060604@eu.citrix.com>
Message-ID: <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain>
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009, George Dunlap wrote:
> David Miller wrote:
> > I don't see Ingo's comments, whether I agree with them or not, as
> > an implication of Xen being niche.  Rather I see his comments as
> > an opposition to how Xen is implemented.
> >   
> It's in his definition of "improving Linux".  Jeremy is saying that allowing
> Linux to run as dom0 *is* improving Linux.  The lack of dom0 support is at
> this moment making life more difficult for a huge number of Linux users who

Exactly that's the point. Adding dom0 makes life easier for a group of
users who decided to use Xen some time ago, but what Ingo wants is
technical improvement of the kernel.

There are many features which have been wildly used in the distro
world where developers tried to push support into the kernel with the
same line of arguments.

The kernel policy always was and still is to accept only those
features which have a technical benefit to the code base.

I'm just picking a few examples:

Aside of the paravirt, which seems to expand through arch/x86 like a
hydra, the new patches sprinkle "if (xen_...)" all over the
place. These extra xen dependencies are no improvement, they are a
royal pain in the ... They are sticky once they got merged simply
because the hypervisor relies on them and we need to provide
compatibility for a long time.

Aside of that it grows interfaces like pat_disable() just because the
CPU model of Xen is obviously not able to kill the PAT flags in the
CPUid emulation. Why for heavens sake do we have a cpuid paravirt op
when we need to disable stuff seperately which can be disabled by
paravirt functionality already? I don't see this as an improvement
either, it's simple sloppy hackery.

The changelogs of the patches are partially confusing as hell:

commit 7d2b03ff4ae27b7c9e99a421a5b965f20e4bfaab

    x86: fix up flush_tlb_all
    
    - initialize the locks before the first use
    - make sure preemption is disabled
    
    [ Impact: Bug fixes: boot time warning, and crash ]

This patch is in the Xen queue and I assume it's XEN related as we
have not seen anywhere a boot time warning and crash with the current
code AFAICT, but the changelog reads like this is some generic BUG in
the SMP boot code. There is neither a hint to Xen nor to another patch
which caused that problem. While the patch itself is harmless I do not
see what is improved and why the change was necessary in the first
place.

That's what maintainers have to look at and not who is using the code
already and wants to see it merged.

> use Xen, including Mozilla, Debian, and Amazon. Adding dom0 support would
> make Linux even more useful to a wide variety of people not using Xen at the
> moment. 

I really have a hard time to see why dom0 support makes Linux more
useful to people who do not use it. It does not improve the Linux
experience of Joe User at all.

In fact it could be harmful to the average user, if it's merged in a
crappy way that increases overhead, has a performance cost and draws
away development and maintenance resources from other areas of the
kernel.

Aside of that it can also hinder the development of a properly
designed hypervisor in Linux: 'why bother with that new stuff, it
might be cleaner and nicer, but we have this Xen dom0 stuff
already?'.

Thanks,

	tglx
