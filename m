Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbZHLNAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbZHLNAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 09:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZHLNAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 09:00:19 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:59720 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbZHLNAS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 09:00:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ProXmWb5+c8FQQFxQFjB2b4T7K8LITAIIBvopcx3DuvnyF1+OwJVTqFF+NrWlFFVlR
         7+uTkX7BilSJzas0gBvf2Y6up3TdcOVqfc7ZHao3neNu+Y75TtcrEPbDJY5U91BUnOs3
         VEJDEMW/Ah8IBA3iF62Yu1sFeqe2nUp8AfLKM=
MIME-Version: 1.0
In-Reply-To: <87skfxfh1g.fsf@basil.nowhere.org>
References: <d67deb790908120227s7816a02cr1ea173a4358fa301@mail.gmail.com>
	 <87skfxfh1g.fsf@basil.nowhere.org>
Date: Wed, 12 Aug 2009 21:00:19 +0800
Message-ID: <d67deb790908120600s1b307fc2j21d4622584ee63d1@mail.gmail.com>
Subject: Re: Is compat_sys_ioctl called when both kernel and userland are 
	64bit ?
From: april <aapril03@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/12 Andi Kleen <andi@firstfloor.org>:
> april <aapril03@gmail.com> writes:
>>
>> it seems when a kernel is built to x86_64, whenever a ioctl called
>> ,the call flow will be ia32_syscall -->compat_sys_ioctl->compat
>> ioctl(if provided)
>
> Only for syscalls throught int 0x80 (or 32bit SYSCALL/SYSENTER), which normally
> only come from 32bit processes. In theory 64bit processes
> could use them, but they normally don't.
>

so you mean in 64bit process with a 64bit Linux kernel, system call is
not through int 0x80 ?
I know little about x86_64 arch, so I suppose it still through INT 0x80
can you tell me more about this? or where to get more information abort it?

>> but I have some doubt:
>>
>> My question is:
>> 1.  Is compat_sys_ioctl called when both kernel and userland are 64bit
>> (suppose I provide those compat ioctl functions)?
>
> No.
>
>>      If not, how kernel knows the driver is 32bit or 64bit?
>
> There are no 32bit drivers on a 64bit kernel, all drivers are 64bit.
>
> For 32bit processes running on a 64bit kernel it depends on the
> entry points (int 0x80 or SYSENTER/SYSCALL)
>
>> 2. when using mmap, the 64bit kernel will return a 64bit address, and
>> a userland(32bit) application can only get the lower 32bit,
>> it can work when the memory is not large.
>
> The kernel makes sure to only hand out 32bit addresses to 32bit
> processes.
>
I am using a 64bit kernel ,32bit Ubuntu9.04 which kernel was replaced
by a 64bit one,
and add some compat ioctl to make drm module work(on VIA platform),X
can work well(only 512M ram)
I am not test but guess it will has problem is memory is large (for
example ,over 4G)

> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only.
>
