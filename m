Return-Path: <linux-kernel-owner+w=401wt.eu-S965154AbXCLFwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965154AbXCLFwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 01:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965148AbXCLFwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 01:52:55 -0400
Received: from sccrmhc11.comcast.net ([204.127.200.81]:38238 "EHLO
	sccrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965154AbXCLFwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 01:52:54 -0400
Subject: Re: Style Question
From: Nicholas Miell <nmiell@comcast.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Cong WANG <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0703120638030.4339@yvahk01.tjqt.qr>
References: <2375c9f90703110715v4278f83flbc9fce6c542472a5@mail.gmail.com>
	 <Pine.LNX.4.61.0703112134180.16857@yvahk01.tjqt.qr>
	 <2375c9f90703112237u4b27c530x34e310a93fd04ef0@mail.gmail.com>
	 <Pine.LNX.4.61.0703120638030.4339@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Sun, 11 Mar 2007 22:52:51 -0700
Message-Id: <1173678771.2964.18.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 06:40 +0100, Jan Engelhardt wrote:
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
> 
> >>[...]
> > I think it's more clear to indicate we are using a pointer rather than
> > an integer when we use NULL in kernel. But in userspace, using NULL is
> > for portbility of the program, although most (*just* most, NOT all) of
> > NULL's defination is ((void*)0). ;-)
> 
> NULL has the same bit pattern as the number zero. (I'm not saying the bit
> pattern is all zeroes. And I am not even sure if NULL ought to have the same
> pattern as zero.) So C++ could use (void *)0, if it would let itself :p

Not necessarily. You can use 0 at the source level, but the compiler has
to convert it to the actual NULL pointer bit pattern, whatever it may
be.

In C++, NULL is typically defined to 0 (with no void* cast) by most
compilers because 0 (and only 0) can be implicitly converted to to null
pointer of any ponter type without a cast. 

GCC introduced the __null extension so that NULL still works correctly
in C++ when passed to a varargs function on 64-bit platforms.

(This just works in C because C makes NULL ((void*)0) is thus is the
right size. In C++, the 0 ends up being an int instead of a pointer when
passed to a varargs function, and things tend to blow up when they read
the garbage high bits. Of course, nobody else does this, so you still
have to use (void*)NULL to be portable.)

-- 
Nicholas Miell <nmiell@comcast.net>

