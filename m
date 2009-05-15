Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbZEOSgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbZEOSgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZEOSgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:36:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40092 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbZEOSgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:36:11 -0400
Date: Fri, 15 May 2009 20:35:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Olaf Kirch <okir@suse.de>
Subject: Re: Where do we stand with the Xen patches?
Message-ID: <20090515183550.GA20833@elte.hu>
References: <4A0C770E.2030305@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0C770E.2030305@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
>
> Over the last week or so, I've set out pull requests for the following  
> branches in git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git 
> :
>
> for-ingo/xen/dom0/core
>
>    You made two comments about the first post of this set:
>
>       1. The // comments in the mtrr code.  Now fixed.
>       2. A query about when Xen can support PAT.  In progress; when its
>          done, we can remove the unconditional PAT disable.
>
> for-ingo/xen/dom0/pci
> for-ingo/xen/dom0/swiotlb
>
>    Updated with Joerg Roedel, FUJITA Tomonori and Matthew Wilcox's
>    comments,  Acked-by and Reviewed-bys as appropriate.

These look fine but i still need to go over them one last time 
before pulling them.

> for-ingo/xen/dom0/apic-ops
>
>    After discussion between yourself and HPA, we resolved that using
>    io_apic_ops was the right way to go forward with this.  I replaced
>    for-ingo/xen/dom0/apic with the new branch
>    for-ingo/xen/dom0/apic-ops, which is identical aside from
>    implementing and using io_apic_ops.

Yes. Here too i still need to go over them once more before pulling 
them.

> for-ingo/xen/dom0/mtrr
>
>    You queried the value of "extending" this interface, given that its
>    considered to be deprecated.  These changes in no way extend the
>    interface, but just make the existing interface functional under
>    Xen.  And while we don't have PAT support, there's no other way of
>    setting cachability attributes on memory, so not supporting it has a
>    fairly severe performance impact on things like X.

Latest Xorg doesnt need /proc/mtrr. By the time this kernel (.31 or 
later) hits any distribution, /proc/mtrr using Xorg will be a 
distant memory. So i see no reason why to apply those bits at all, 
and i see a lot of reasons to not apply them.

> Aside from some whitespace issues around some Impact: lines, I 
> don't know of any outstanding problems.  (I just pushed an updates 
> to these branches to fix those, and fold a change to address 
> Jesse's comment.)
>
> Please tell me if you have any further issues which prevents you 
> from pulling these changes.  Otherwise I'd appreciate it if you 
> pulled them soon, as we're already on -rc5, and I have more 
> changes I'd like to prep for the next merge window.

As in the past, my main worry is performance overhead of paravirt in 
general.

The patches that dont affect any native kernel fast path are 
probably OK (but still pending final review).

Regarding patches that do change the fastpath i'll do a round of 
measurements of CONFIG_PARAVIRT against !CONFIG_PARAVIRT kernels, 
and make up my mind based on that.

You could accelerate this by sending some "perf stat" hard numbers 
to give us an idea about where we stand today.

	Ingo
