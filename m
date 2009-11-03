Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbZKCMah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbZKCMah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 07:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbZKCMag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 07:30:36 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:34982 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZKCMaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 07:30:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rItWGrdDfuIuIh/K+Y5FfNElPARqn+XuozRLsAoF4VMk6+9A31EuB1HRM4A4LSeO8a
         kwy7598E1brwOO47kRfRxY5eHk+Kp4gzHQxUl+Zq5jbzk5mGaGJstaT4nDnND8Otk7r0
         +OtLJ6uF/OnPhGFTC1cj+VuKcbFnL++vC77qo=
MIME-Version: 1.0
In-Reply-To: <4AF01F18.8040807@tuffmail.co.uk>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com> 
	<1257242782-10496-5-git-send-email-alan-jenkins@tuffmail.co.uk> 
	<8bd0f97a0911030219y685a1dafy2a8e066d7132ac45@mail.gmail.com> 
	<4AF01F18.8040807@tuffmail.co.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 3 Nov 2009 07:30:20 -0500
Message-ID: <8bd0f97a0911030430s3ecb2467hc52ebac658c39ccd@mail.gmail.com>
Subject: Re: [PATCH 04/10] module: make MODULE_SYMBOL_PREFIX into a CONFIG 
	option
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: greg@kroah.com, linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 3, 2009 at 07:16, Alan Jenkins wrote:
> Mike Frysinger wrote:
>> On Tue, Nov 3, 2009 at 05:06, Alan Jenkins wrote:
>>> The next commit will require the use of MODULE_SYMBOL_PREFIX in
>>> .tmp_exports-asm.S.  Currently it is mixed in with C structure
>>> definitions in "asm/module.h".  Move the definition of this arch option
>>> into Kconfig, so it can be easily accessed by any code.
>>>
>>> This also lets modpost.c use the same definition.  Previously modpost
>>> relied on a hardcoded list of architectures in mk_elfconfig.c.
>>
>> this should also let us push VMLINUX_SYMBOL() out of
>> arch/*/kernel/vmlinux.lds.S and into asm-generic/vmlinux.lds.h ...
>
> I don't think that's possible.
>
>   #define VMLINUX_SYMBOL(_sym_) _##_sym_
>
> I don't know any "unstringify" operation.  So I can't convert a string value
> of CONFIG_SYMBOL_PREFIX to the unquoted underscore we neeed for this macro.
>  The same applies for the SYM() macro I use.

let the build system do the unstringify operation.
qstrip = $(strip $(subst ",,$(1)))
CPPFLAGS_vmlinux.lds += -DVMLINUX_SYMBOL_PREFIX=$(call
qstrip,CONFIG_SYMBOL_PREFIX)

> If we positively want to keep the generality, I guess I should put
> MODULE_SYMBOL_PREFIX in a header file of it's own.  The disadvantage is that
> it makes it inaccessible to host programs again, like modpost (which
> currently hardcodes the list of affected architectures in mk_elfconfig.c).

having it in the arch Kconfig removes any and all possible
limitations, and it keeps the cruft out of the common init/Kconfig and
in the arch-specific Kconfig, and avoids a dead symbol
(HAVE_SYMBOL_PREFIX)
-mike
