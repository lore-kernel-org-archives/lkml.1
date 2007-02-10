Return-Path: <linux-kernel-owner+w=401wt.eu-S932417AbXBJOlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbXBJOlf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 09:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932435AbXBJOlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 09:41:35 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:61464 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417AbXBJOle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 09:41:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LoDfZFNI8ughsMFig67lMHxNuC3CXfD1y4zH+Hry7OChT+MrhhwOkLDISJnAknKrOXFj4X6P/AW1HKX4XUeezTPyX5cs39W+QqjmP7JUopxUsDplAS3QuqHcACm4N97SXIAufcSr5zekptgC4ol60PFJWMpXFhVaYMF8yMH+XI4=
Message-ID: <82e4877d0702100641h7b479c95mce3dfa65b0e6c779@mail.gmail.com>
Date: Sat, 10 Feb 2007 09:41:34 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] Make aout executables work again
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       joerg@hydrops.han.de, dsd@gentoo.org, paulus@samba.org,
       benh@kernel.crashing.org, lethal@linux-sh.org
In-Reply-To: <200702101524.56098.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702092100540.3984@localhost.localdomain>
	 <p73y7n6goey.fsf@bingen.suse.de>
	 <82e4877d0702100550ld369c8an2982a64dcc920169@mail.gmail.com>
	 <200702101524.56098.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Is there a reason why we specifically want to make a distinction
> > between binfmts having and not having VDSOs and do we want aout to
> > have the possibility of NOT having VDSO when a) It used to have it
> > unconditionally b) nothing special is needed in arch or common code to
> > have it and c) Not letting have it requires special arch-specific
> > code* ?
>
> I mainly did it this way because it was quite a lot simpler.
> I'm not worrying too much about other strange binfmts to be honest
>

Well with your suggestion of using weak definition (BTW, I find that
thing cool :))  for arch_setup_additional_pages() I think my patch is
simpler and it preserves existing behavior - it just boils down to
actually calling the already existing function in binfmt_aout.c.


> > [*] I see the patch handles i386 and x86_64 - but I am not sure if
> > something similar will be needed for the other arches to allow aout
> > executables in absence of VDSO (powerpc, sh).
>
> Neither powerpc nor sh support a.out.
>

Ok, that's not a concern then. Not that I care about aout but if a
simple fix can let it have VDSO and prevent special casing, I would
prefer to let it have VDSO and still work - at least in the interest
of preserving existing behavior.

Parag
