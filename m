Return-Path: <linux-kernel-owner+w=401wt.eu-S965111AbXCLFhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965111AbXCLFhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 01:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965119AbXCLFhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 01:37:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:48613 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965111AbXCLFhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 01:37:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IrK+NHL4WX9JEA8YVwclw1MybeBJZ5UL0pVQKLJzscnJ8P+58kGlAHcd9MDWa/iZymvXvggkfQoLnpPQhUVItBtBm/NVc52FnXjiICsGZSMmSMxYIF0LQ/iAdniojoLMIwQjxJ7Z5CqRfdgpGeZ/00DuuwvytaVM8XQK5vKPxgA=
Message-ID: <2375c9f90703112237u4b27c530x34e310a93fd04ef0@mail.gmail.com>
Date: Mon, 12 Mar 2007 13:37:43 +0800
From: "Cong WANG" <xiyou.wangcong@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: Style Question
In-Reply-To: <Pine.LNX.4.61.0703112134180.16857@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2375c9f90703110715v4278f83flbc9fce6c542472a5@mail.gmail.com>
	 <Pine.LNX.4.61.0703112134180.16857@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/12, Jan Engelhardt <jengelh@linux01.gwdg.de>:
>
> On Mar 11 2007 22:15, Cong WANG wrote:
> >
> > I have a question about coding style in linux kernel. In
> > Documention/CodingStyle, it is said that "Linux style for comments is
> > the C89 "/* ... */" style. Don't use C99-style "// ..." comments."
> > _But_ I see a lot of '//' style comments in current kernel code.
> >
> > Which is wrong? The documentions or the code, or neither? And why?
>
> The code. And because it's not always reviewed but silently pushed.
>
> > Another question is about NULL. AFAIK, in user space, using NULL is
> > better than directly using 0 in C. In kernel, I know it used its own
> > NULL, which may be defined as ((void*)0), but it's _still_ different
> > from raw zero.
>
> In what way?

The following code is picked from drivers/kvm/kvm_main.c:

static struct kvm_vcpu *vcpu_load(struct kvm *kvm, int vcpu_slot)
{
       struct kvm_vcpu *vcpu = &kvm->vcpus[vcpu_slot];

       mutex_lock(&vcpu->mutex);
       if (unlikely(!vcpu->vmcs)) {
               mutex_unlock(&vcpu->mutex);
               return 0;
       }
       return kvm_arch_ops->vcpu_load(vcpu);
}

Obviously, it used 0 rather than NULL when returning a pointer to
indicate an error. Should we fix such issue?

>
> >So can I say using NULL is better than 0 in kernel?
>
> On what basis? Do you even know what NULL is defined as in
> (C, not C++) userspace? Think about it.
>

I think it's more clear to indicate we are using a pointer rather than
an integer when we use NULL in kernel. But in userspace, using NULL is
for portbility of the program, although most (*just* most, NOT all) of
NULL's defination is ((void*)0). ;-)
