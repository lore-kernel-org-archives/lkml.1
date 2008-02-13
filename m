Return-Path: <linux-kernel-owner+w=401wt.eu-S933610AbYBMQib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610AbYBMQib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933404AbYBMQiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:38:11 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:10809 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933547AbYBMQiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:38:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZYM9lhRuMaF085VwxvUEApTTgO+xvB/Ya+dj0becLKjzec2DV1mhz5uitGu3OSgM/8bFZDuXlvRO87vBkBo4ODbFvdshf9ojahgrj5A923K2aS+P+hp6HTF1tg9hnm5E8yWmLAV2F2yMxXBlJI1ew4l43z/e7erDbCtbvYRLrDE=
Message-ID: <c4e36d110802130838r88c6151kcc058f1f0806ee29@mail.gmail.com>
Date: Wed, 13 Feb 2008 17:38:06 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Marcelo Tosatti" <marcelo@kvack.org>
Subject: Re: Qemu & KVM bug
Cc: "Jiri Kosina" <jkosina@suse.cz>, "Avi Kivity" <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080213160905.GA8559@dmt>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110802130638i5057b49by280ab0b2c415064a@mail.gmail.com>
	 <Pine.LNX.4.64.0802131621440.7699@twin.jikos.cz>
	 <20080213160905.GA8559@dmt>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/2/13, Marcelo Tosatti <marcelo@kvack.org>:
> On Wed, Feb 13, 2008 at 04:24:53PM +0100, Jiri Kosina wrote:
> > On Wed, 13 Feb 2008, Zdenek Kabelac wrote:
> >
> > > I get this bug in my log whenever I start qemu-kvm - I do not use kqemu
> > > module - so it's with plain kernel modules. If more details are needed -
> > > just ask. (Cpu; C2D)
> > > BUG: sleeping function called from invalid context at kernel/rwsem.c:48
> > > in_atomic():1, irqs_disabled():0
> > > INFO: lockdep is turned off.
> > > Pid: 26600, comm: qemu-kvm Not tainted 2.6.25-rc1 #29
> >
> > This has been obviously caused by Marcelo's (added to CC) commit
> > 10589a4699b, which added down_write(mmap_sem) to alloc_apic_access_page(),
> > which is called with preempt disabled from vmx_create_vcpu().
>
> alloc_apic_access_page() called mutex_lock, so the warning would trigger
> before that change.
>
> I think it's fine to allocate the APIC page after put_cpu(), since no vcpu
> state is required.
>
> Avi?
>
>
> --- linux-2.6.orig/arch/x86/kvm/vmx.c
> +++ linux-2.6/arch/x86/kvm/vmx.c
> @@ -1601,9 +1601,6 @@ static int vmx_vcpu_setup(struct vcpu_vm

Hi

I've checked the patch myself - and looks like there is no BUG message
now - nice
thanks.

Zdenek
