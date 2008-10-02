Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbYJBICZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbYJBICZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbYJBICF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:02:05 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:7451 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbYJBICC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:02:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=inCaGl5KcWJbZ+qc0J1pHSSF6HaL/707beoY3A2EqtIxahnDRKgE3ul4bFaLvSTY5N
         cO6N9w7LFkyZwpyGUAqcKEBiKAIdPBgb6lNKqvPboUOENWZ9kjEsnVe2q9J0+9+M+dL2
         zawLy6eN9vmqk6tRyzUWK0VkynO2toJQRw8xc=
Message-ID: <851fc09e0810020102j7c4f8896vd384f79617480317@mail.gmail.com>
Date: Thu, 2 Oct 2008 16:02:00 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Russ Anderson" <rja@sgi.com>
Subject: Re: [PATCH 2/4] x86: Add UV bios call infrastructure v2
Cc: "Huang Ying" <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
       "Jack Steiner" <steiner@sgi.com>
In-Reply-To: <20080928150106.GA204845@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080926200242.GC138671@sgi.com>
	 <1222478495.28661.19.camel@yhuang-dev.sh.intel.com>
	 <20080928150106.GA204845@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Russ,

On Sun, Sep 28, 2008 at 11:01 PM, Russ Anderson <rja@sgi.com> wrote:
> On Sat, Sep 27, 2008 at 09:21:35AM +0800, Huang Ying wrote:
>> On Fri, 2008-09-26 at 15:02 -0500, Russ Anderson wrote:
>> > Index: linux/include/asm-x86/efi.h
>> > ===================================================================
>> > --- linux.orig/include/asm-x86/efi.h        2008-09-26 14:13:24.000000000 -0500
>> > +++ linux/include/asm-x86/efi.h     2008-09-26 14:13:36.000000000 -0500
>> > @@ -49,6 +49,20 @@ extern u64 efi_call5(void *fp, u64 arg1,
>> >  extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
>> >                  u64 arg4, u64 arg5, u64 arg6);
>> >
>> > +
>> > +#ifndef CONFIG_EFI
>> > +/*
>> > + * IF EFI is not configured, have the EFI calls return -ENOSYS.
>> > + */
>> > +#define efi_call0(_f)                                      (-ENOSYS)
>> > +#define efi_call1(_f, _a1)                         (-ENOSYS)
>> > +#define efi_call2(_f, _a1, _a2)                            (-ENOSYS)
>> > +#define efi_call3(_f, _a1, _a2, _a3)                       (-ENOSYS)
>> > +#define efi_call4(_f, _a1, _a2, _a3, _a4)          (-ENOSYS)
>> > +#define efi_call5(_f, _a1, _a2, _a3, _a4, _a5)             (-ENOSYS)
>> > +#define efi_call6(_f, _a1, _a2, _a3, _a4, _a5, _a6)        (-ENOSYS)
>> > +#endif /* CONFIG_EFI */
>> > +
>> >  #define efi_call_phys0(f)                  \
>> >     efi_call0((void *)(f))
>> >  #define efi_call_phys1(f, a1)                      \
>>
>> efi_call_virt<n> and efi_call_phys<n> is the API instead of efi_call<n>.
>
> #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)                       \
>        efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
>                  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
>
> efi_call_virt6() uses efi.systab->runtime->f.
> My call needs to use uv_systab, not efi.systab.

Yes. efi_call_virt6() is tied with standard EFI runtime services, so
it may be not suitable for your need. What you need is just to do
calling convention converting, like efi_call6 does. So I think it is
better to just use your current implementation.

Acked-by: Huang Ying <ying.huang@intel.com>

Best Regards,
Huang Ying
