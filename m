Return-Path: <linux-kernel-owner+w=401wt.eu-S932891AbXCPL6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbXCPL6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 07:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933589AbXCPL6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 07:58:52 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48278 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932891AbXCPL6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 07:58:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Zachary Amsden <zach@vmware.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [RFC, PATCH] Fixup COMPAT_VDSO to work with CONFIG_PARAVIRT
References: <45FA054F.6020107@vmware.com>
Date: Fri, 16 Mar 2007 05:56:00 -0600
In-Reply-To: <45FA054F.6020107@vmware.com> (Zachary Amsden's message of "Thu,
	15 Mar 2007 18:47:43 -0800")
Message-ID: <m17itho10v.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden <zach@vmware.com> writes:

> Paravirt-ops guests which move the fixmap also end up moving the syscall VDSO.
> This fails if it is prelinked at a fixed address, which is why COMPAT_VDSO is
> broken under CONFIG_VMI (and also under CONFIG_XEN).  Several options are
> available to try to address this.  Jan had cooked up a patch for Xen that used
> build magic to find the parts of the VDSO that need relocation.  I don't like
> the idea of having auto-generated relocations, as someday something could change
> between two linked objects (timestamp, elf notes perhaps) that is not a
> relocation.  So I prefer human supervision over the relocation and explicitly
> fixing everything by hand.  I'm not necessarily advocating one solution over the
> other; my way is more code to maintain if the VDSO linkage changes.  I'm looking
> for feedback about which way is best.
>
> Also, it appears that COMPAT_VDSO could disappear entirely.  Since this approach
> should work with older broken ld.so (2.3.2 is the version, I believe), we should
> be able to switch over completely to using the gate vma style of linking the
> vdso.  One can even get the address randomization benefits by simply running
> fixup on the vdso if you are prepared to take the cost of allocating an extra
> page per process.  Or you could randomize just once at boot, which makes the
> randomization per-machine, still sufficient to slow network based worm attacks
> which might rely on a fixed VDSO address.
>
> Clearly this patch needs more testing and feedback, which I'm sure it will
> get...
>
> <zach ducks>
>
> Zach
>
> P.S. - Eric, I've copied you as you appear to be an ELF expert, or at least have
> a greater grasp of Elven Magic than me, and I'm hoping I got all the dynamic
> tags which need relocation right.
> Invoke black magic to relocate the VDSO even when COMPAT_VDSO is enabled
> by fixing up the ELF object.

I'm not quite familiar with the context.  And I'm to lazy to look right now.
What is the difference with COMPAT_VDSO that it doesn't do relocation?
What are we preserving?

The practical question here is if we already have all of the relocation logic
for the VDSO why do we need to add more?

I'm tempted to rant on the pure insanity of address space randomization but
that is a whole other issue...

Eric
