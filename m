Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbZBEVpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbZBEVpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZBEVpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:45:09 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:38206 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbZBEVpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:45:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xgd2w3ux18yrJbTKP9JzdZGEEB4TmQtqbb6jIFAeGi/BBzwAsdN3lEgwCPUkKfzQ/3
         PJNm7FUkanE/WlWpywWt/7Ab2JQHEXnHvMCUCS+CW/0/Cs3emMxqbb30Z3711xac48dg
         1C+YFqEbIbj1UDI3wyFPXH5YyRCISdKSeqpIg=
MIME-Version: 1.0
In-Reply-To: <1233867944.4612.104.camel@pasglop>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	 <pWZw1SZjMCH.A.sIE.wuYiJB@chimera> <1233791329.4612.23.camel@pasglop>
	 <Pine.LNX.4.64.0902051713550.1445@blonde.anvils>
	 <1233867944.4612.104.camel@pasglop>
Date: Fri, 6 Feb 2009 07:45:05 +1000
Message-ID: <21d7e9970902051345h76fb26c1hc0397f6262f70eae@mail.gmail.com>
Subject: Re: [Bug #12608] 2.6.29-rc powerpc G5 Xorg legacy_mem regression
From: Dave Airlie <airlied@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hugh Dickins <hugh@veritas.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 6, 2009 at 7:05 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
>> Is it a really a bug in X, or a misunderstanding between X and
>> the kernel as to what existence of the legacy_mem file implies?
>>
>> I may have got this quite wrong, but to me it appears that X assumes
>> that existence of the legacy_mem file implies that it will be useful;
>> whereas the kernel thinks it can make the legacy_mem file available,
>> even if it cannot be used for mmapping mem - which is its sole purpose?
>>
>> What if pci_create_legacy_files() were to call some new verification
>> routine, and only create the legacy_mem file if it would be usable?
>> (But perhaps that cannot be known at the time it needs to be created.)
>
> Well, first X should certainly not -fail- to launch if it fails to map
> legacy memory, which is generally not useful anyway. That's where the
> bug is. Jesse, did you have a chance to fix that yet or should I give it
> a go ?
>
> The second problem is that if I just don't expose the legacy_mem file,
> then X has no way to know whether the kernel doesn't support the
> interface or whether the HW doesn't support legacy memory access. So X
> will fallback to whacking /dev/mem which is even more bogus. At least
> that's what I remember from last I looked at that part of X code.
>
> It should be a trivial fix on X side tho.

I think the correct answer is the ugly one, try again.

Add a new legacy_mem interface that works cleanly, update X to use it,
leave the old
broken one broken as it for older X to use.

Dave.

>
> Cheers,
> Ben.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
