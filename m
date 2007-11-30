Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbXK3I7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbXK3I7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 03:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbXK3I72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 03:59:28 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:17161 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbXK3I71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 03:59:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DIxpZotijhU4DbA+XVSmk1nl8flVFoBMm3g+roJfou+gdqLe+Dp/tD2D/NfZ1fw/n86l0+o+U2lQf7ttcR6cACkQykhpLS5lniH6irZ1Hmo99eSJL+zRRi0uYM8AKUgYdZg+DUit+mcJiZEdlkcsePeEXJlFYk4UQBwoN3O0qAM=
Message-ID: <86802c440711300059tb8bf924i72a9eca29723499f@mail.gmail.com>
Date: Fri, 30 Nov 2007 00:59:26 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Cc: "Ben Woodard" <woodard@redhat.com>, "Vivek Goyal" <vgoyal@redhat.com>,
       "Neil Horman" <nhorman@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>,
       hbabu@us.ibm.com, "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <m1sl2oa1ev.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <m1y7cjkec2.fsf@ebiederm.dsl.xmission.com>
	 <20071127200011.GA3703@redhat.com>
	 <20071127222408.GH24223@one.firstfloor.org>
	 <474CA733.9050908@redhat.com> <20071128153649.GC3192@redhat.com>
	 <20071128160206.GA21286@hmsendeavour.rdu.redhat.com>
	 <20071128190525.GD3192@redhat.com>
	 <m1d4tudun5.fsf@ebiederm.dsl.xmission.com>
	 <474F7290.8010504@redhat.com>
	 <m1sl2oa1ev.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2007 6:54 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Ben Woodard <woodard@redhat.com> writes:
>
>
> > Eric W. Biederman wrote:
> >> Vivek Goyal <vgoyal@redhat.com> writes:
> >>
> >>> Ok. Got it. So in this case we route the interrupts directly through LAPIC
> >>> and put LVT0 in ExtInt mode and IOAPIC is bypassed.
> >>>
> >>> I am looking at Intel Multiprocessor specification v1.4 and as per figure
> >>> 3-3 on page 3-9, 8259 is connected to LINTIN0 line, which in turn is
> >>> connected to LINTIN0 pin on all processors. If that is the case, even in
> >>> this mode, all the CPU should see the timer interrupts (which is coming
> >>> from 8259)?
> >>

there is two mode for mcp55. bios should have one option about virtul
wired to LVT0 of BSP or IOAPIC pin 0.
or the option like hpet route to ioapic pin 2.

for kdump fix, could enable LVT0 of CPU for kdump and disable that for BSP?

ben,
can you send out
lspci -vvxxx -s 00:1.0

YH
