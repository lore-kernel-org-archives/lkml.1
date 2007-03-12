Return-Path: <linux-kernel-owner+w=401wt.eu-S965155AbXCLGS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965155AbXCLGS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 02:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965163AbXCLGS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 02:18:59 -0400
Received: from xenotime.net ([66.160.160.81]:45373 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965155AbXCLGS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 02:18:58 -0400
Date: Sun, 11 Mar 2007 23:18:55 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Cong WANG <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Style Question
In-Reply-To: <Pine.LNX.4.61.0703120638030.4339@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.58.0703112318240.30187@shark.he.net>
References: <2375c9f90703110715v4278f83flbc9fce6c542472a5@mail.gmail.com> 
 <Pine.LNX.4.61.0703112134180.16857@yvahk01.tjqt.qr>
 <2375c9f90703112237u4b27c530x34e310a93fd04ef0@mail.gmail.com>
 <Pine.LNX.4.61.0703120638030.4339@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007, Jan Engelhardt wrote:

>
> On Mar 12 2007 13:37, Cong WANG wrote:
> >
> > The following code is picked from drivers/kvm/kvm_main.c:
> >
> > static struct kvm_vcpu *vcpu_load(struct kvm *kvm, int vcpu_slot)
> > {
> > struct kvm_vcpu *vcpu = &kvm->vcpus[vcpu_slot];
> >
> > mutex_lock(&vcpu->mutex);
> > if (unlikely(!vcpu->vmcs)) {
> > mutex_unlock(&vcpu->mutex);
> > return 0;
> > }
> > return kvm_arch_ops->vcpu_load(vcpu);
> > }
> >
> > Obviously, it used 0 rather than NULL when returning a pointer to
> > indicate an error. Should we fix such issue?
>
> Indeed. If it was for me, something like that should throw a compile error.

At least it does throw a sparse warning, and yes, it should
be fixed.

> >>[...]
> > I think it's more clear to indicate we are using a pointer rather than
> > an integer when we use NULL in kernel. But in userspace, using NULL is
> > for portbility of the program, although most (*just* most, NOT all) of
> > NULL's defination is ((void*)0). ;-)
>
> NULL has the same bit pattern as the number zero. (I'm not saying the bit
> pattern is all zeroes. And I am not even sure if NULL ought to have the same
> pattern as zero.) So C++ could use (void *)0, if it would let itself :p
>
>
> >
> >
>
> Jan
>

-- 
~Randy
