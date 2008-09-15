Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbYIOQZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbYIOQZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 12:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYIOQZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 12:25:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:64187 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbYIOQZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 12:25:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gmqMxUVNVRCzFWTAe51thD+mczZFnPCeGf7Mj0F62SrmZlLISKhFSWLSLzyfYa2ZEg
         QQvWFxwDhphiSglhkNINmBv+Jj2aXnvmMLlFmoH/EhU9ZgVCkvIWKm6jdi7Nqt9/BoBs
         GCuganbUAAcAKKgJbP7AgtPkYpjK0AUjydb4Y=
Message-ID: <86802c440809150925y583916b9sf97d73cb630469bc@mail.gmail.com>
Date: Mon, 15 Sep 2008 09:25:14 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: do_boot_cpu - check for ESR apic register presence before touching
Cc: "Ingo Molnar" <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080915162240.GB23798@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080915150518.GA23798@lenovo>
	 <86802c440809150912r222b399eg552208646decd9d4@mail.gmail.com>
	 <20080915162240.GB23798@lenovo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 9:22 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> [Yinghai Lu - Mon, Sep 15, 2008 at 09:12:37AM -0700]
> | On Mon, Sep 15, 2008 at 8:05 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> | > We should check first if there is ESR register before read/write it.
> | >
> | > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> | > ---
> | >
> | > Please review and test if possible. Thanks.
> | >
> | > Index: linux-2.6.git/arch/x86/kernel/smpboot.c
> | > ===================================================================
> | > --- linux-2.6.git.orig/arch/x86/kernel/smpboot.c        2008-09-14 21:49:36.000000000 +0400
> | > +++ linux-2.6.git/arch/x86/kernel/smpboot.c     2008-09-15 18:30:37.000000000 +0400
> | > @@ -893,8 +893,10 @@ do_rest:
> | >                /*
> | >                 * Be paranoid about clearing APIC errors.
> | >                */
> | > -               apic_write(APIC_ESR, 0);
> | > -               apic_read(APIC_ESR);
> | > +               if (APIC_INTEGRATED(apic_version[phys_apicid])) {
> | > +                       apic_write(APIC_ESR, 0);
> | > +                       apic_read(APIC_ESR);
> | > +               }
> | >        }
> | >
> | >        /*
> | >
> |
> | maybe unrelated. Do we need to keep apic_version array?
> |
> | YH
> |
>
> as I see ACPI/MP parsing code use it - actually I think we could
> bring another variable - but don't think it worth it. Anyway
> we have to get APIC info from these tables and save it somwhere
> maybe in this array or maybe in another variable. Or you mean
> anything else that I missed?

one apic_version or boot_cpu_apic_version could be enough.

YH
