Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbYIOQWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbYIOQWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 12:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbYIOQW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 12:22:29 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:56856 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbYIOQW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 12:22:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Wjmbv32re1+5EwrBTrUqlAnd9ApFUBN61Q0/4LmhVUuIb1crYeQOAlLS80Tonzk7mP
         oGGXmJERcsaKFBmiXcjArqhTFeMuiBJJu5GavjwAOtct9myBVZQgS09/VNaGlJzeVOAO
         3iQa3TvY6RkmKvGegPsUAxA5z9MpOsZc2tnAY=
Date: Mon, 15 Sep 2008 20:22:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: do_boot_cpu - check for ESR apic register
	presence before touching
Message-ID: <20080915162240.GB23798@lenovo>
References: <20080915150518.GA23798@lenovo> <86802c440809150912r222b399eg552208646decd9d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809150912r222b399eg552208646decd9d4@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Mon, Sep 15, 2008 at 09:12:37AM -0700]
| On Mon, Sep 15, 2008 at 8:05 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > We should check first if there is ESR register before read/write it.
| >
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > ---
| >
| > Please review and test if possible. Thanks.
| >
| > Index: linux-2.6.git/arch/x86/kernel/smpboot.c
| > ===================================================================
| > --- linux-2.6.git.orig/arch/x86/kernel/smpboot.c        2008-09-14 21:49:36.000000000 +0400
| > +++ linux-2.6.git/arch/x86/kernel/smpboot.c     2008-09-15 18:30:37.000000000 +0400
| > @@ -893,8 +893,10 @@ do_rest:
| >                /*
| >                 * Be paranoid about clearing APIC errors.
| >                */
| > -               apic_write(APIC_ESR, 0);
| > -               apic_read(APIC_ESR);
| > +               if (APIC_INTEGRATED(apic_version[phys_apicid])) {
| > +                       apic_write(APIC_ESR, 0);
| > +                       apic_read(APIC_ESR);
| > +               }
| >        }
| >
| >        /*
| >
| 
| maybe unrelated. Do we need to keep apic_version array?
| 
| YH
|

as I see ACPI/MP parsing code use it - actually I think we could
bring another variable - but don't think it worth it. Anyway
we have to get APIC info from these tables and save it somwhere
maybe in this array or maybe in another variable. Or you mean
anything else that I missed?
 
		- Cyrill -
