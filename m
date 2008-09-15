Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYIOQMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYIOQMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 12:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbYIOQMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 12:12:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:51588 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbYIOQMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 12:12:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sIN8fXbZNc1Fb9Z1haZTZwsyBgy+TR54iMtDhx5+GPCy3dpmbzN/yIeqbgQr2fYWEQ
         a4gDljXmd/HtawHDopuIV1T8qGddDCKZWu4lp/UmleBJB6iA13Q2lwvNwFj1fLbTNSue
         P+3x+4k4ZO4/KqqBGesbBy+3JWTqvdT3/+u5k=
Message-ID: <86802c440809150912r222b399eg552208646decd9d4@mail.gmail.com>
Date: Mon, 15 Sep 2008 09:12:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: do_boot_cpu - check for ESR apic register presence before touching
Cc: "Ingo Molnar" <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080915150518.GA23798@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080915150518.GA23798@lenovo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 8:05 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> We should check first if there is ESR register before read/write it.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
>
> Please review and test if possible. Thanks.
>
> Index: linux-2.6.git/arch/x86/kernel/smpboot.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/smpboot.c        2008-09-14 21:49:36.000000000 +0400
> +++ linux-2.6.git/arch/x86/kernel/smpboot.c     2008-09-15 18:30:37.000000000 +0400
> @@ -893,8 +893,10 @@ do_rest:
>                /*
>                 * Be paranoid about clearing APIC errors.
>                */
> -               apic_write(APIC_ESR, 0);
> -               apic_read(APIC_ESR);
> +               if (APIC_INTEGRATED(apic_version[phys_apicid])) {
> +                       apic_write(APIC_ESR, 0);
> +                       apic_read(APIC_ESR);
> +               }
>        }
>
>        /*
>

maybe unrelated. Do we need to keep apic_version array?

YH
