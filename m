Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbYCYCX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbYCYCX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 22:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757508AbYCYCWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 22:22:44 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:53649 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504AbYCYCWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 22:22:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CSw/CwfzF50TgzC+ewVVO/LNAnm0OpQnT5gAd51MCfQCnF6qYrgyMd8uMDZlkTsLDCdb/sUUu7WvSWVo6S7d9L1t9iKTTXMY7VUlh9DgLnBoi97xSNsAqsyqqw4o0uWL+Hn5efWxSZlu4WmNLMh5kquMwrpaJGrjch37e2QK+BE=
Message-ID: <86802c440803241922u50fb33f8xb33118e22c2f7ad2@mail.gmail.com>
Date: Mon, 24 Mar 2008 19:22:42 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: enable PAT for amd k8 and fam10h
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <47E85593.4030104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803241602.01957.yhlu.kernel@gmail.com>
	 <47E85593.4030104@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 6:29 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>  > [PATCH] x86: enable PAT for amd k8 and fam10h
>  >
>  > make known_pat_cpu to think amd k8 and fam10h is ok too.
>  >
>  > also make tom2 below to be WRBACK
>  >
>
> > diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
>  > index f74505f..a9e1a27 100644
>  > --- a/arch/x86/mm/pat.c
>  > +++ b/arch/x86/mm/pat.c
>  > @@ -49,6 +49,12 @@ static int pat_known_cpu(void)
>  >                       return 1;
>  >               }
>  >       }
>  > +     if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
>  > +          boot_cpu_data.x86 >= 0xf && boot_cpu_data.x86 <= 0x11) {
>  > +             if (cpu_has_pat) {
>  > +                     return 1;
>  > +             }
>  > +     }
>  >
>  >       pat_wc_enabled = 0;
>  >       printk(KERN_INFO "CPU and/or kernel does not support PAT.\n");
>
>  This really should be handled through a CPU flag.  Specifically, it
>  should be handled by disabling the PAT flag if PAT is unusable or
>  suspect of being unusable; it should *NOT* be stashed away in a
>  completely separate piece of code.

PAT patches in x86.git latest, only support some intel CPUs.

        if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
            (boot_cpu_data.x86 == 0xF ||
             (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model >= 15))) {
                if (cpu_has_pat) {
                        return 1;
                }
        }

should be moved to setup_64.c?

YH
