Return-Path: <linux-kernel-owner+w=401wt.eu-S965119AbXCLFki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965119AbXCLFki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 01:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965138AbXCLFki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 01:40:38 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:37281 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965119AbXCLFkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 01:40:37 -0400
Date: Mon, 12 Mar 2007 06:40:18 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Cong WANG <xiyou.wangcong@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Style Question
In-Reply-To: <2375c9f90703112237u4b27c530x34e310a93fd04ef0@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0703120638030.4339@yvahk01.tjqt.qr>
References: <2375c9f90703110715v4278f83flbc9fce6c542472a5@mail.gmail.com> 
 <Pine.LNX.4.61.0703112134180.16857@yvahk01.tjqt.qr>
 <2375c9f90703112237u4b27c530x34e310a93fd04ef0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 12 2007 13:37, Cong WANG wrote:
>
> The following code is picked from drivers/kvm/kvm_main.c:
>
> static struct kvm_vcpu *vcpu_load(struct kvm *kvm, int vcpu_slot)
> {
> struct kvm_vcpu *vcpu = &kvm->vcpus[vcpu_slot];
>
> mutex_lock(&vcpu->mutex);
> if (unlikely(!vcpu->vmcs)) {
> mutex_unlock(&vcpu->mutex);
> return 0;
> }
> return kvm_arch_ops->vcpu_load(vcpu);
> }
>
> Obviously, it used 0 rather than NULL when returning a pointer to
> indicate an error. Should we fix such issue?

Indeed. If it was for me, something like that should throw a compile error.

>>[...]
> I think it's more clear to indicate we are using a pointer rather than
> an integer when we use NULL in kernel. But in userspace, using NULL is
> for portbility of the program, although most (*just* most, NOT all) of
> NULL's defination is ((void*)0). ;-)

NULL has the same bit pattern as the number zero. (I'm not saying the bit
pattern is all zeroes. And I am not even sure if NULL ought to have the same
pattern as zero.) So C++ could use (void *)0, if it would let itself :p


>
>

Jan
-- 
