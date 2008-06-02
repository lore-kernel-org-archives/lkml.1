Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYFBTJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYFBTJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 15:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYFBTJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 15:09:36 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:37134 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbYFBTJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 15:09:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OpMlehfwS4Q9DoySq8aDKR7gpA2kKalcjkqtVanJB099M2GZ0XAduMMPJsYRkMq924EoRPjni0mRCIGFIdAUb3ET3gZ+k5xT08SHsWT1rrAKiGvg+f6wO/IeWUG34hFvc/2mkHtqm5YP/VfoPKcgl3DE+cbE1A8Gf/Z8sdeW4B8=
Message-ID: <b637ec0b0806021209m3798a5c4o72008e48d04c1202@mail.gmail.com>
Date: Mon, 2 Jun 2008 21:09:14 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Section mismatch on latest git
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org
In-Reply-To: <20080529000128.a106a7b1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b637ec0b0805260103w62c03d07ic7bcd0ed0d9c9941@mail.gmail.com>
	 <20080529000128.a106a7b1.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yes, your patch fixes the warning, thanks.

(by the way, I just pulled linus' tree and it seems that the patch
it's still not included and the warning is still present without it).

cheers,
fabio




On Thu, May 29, 2008 at 9:01 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 26 May 2008 10:03:21 +0200 "Fabio Comolli" <fabio.comolli@gmail.com> wrote:
>
>> Hi.
>> I don't know it it has been reported already:
>>
>> WARNING: vmlinux.o(.text+0x114bb): Section mismatch in reference from
>> the function nopat() to the function .cpuinit.text:pat_disable()
>> The function nopat() references
>> the function __cpuinit pat_disable().
>> This is often because nopat lacks a __cpuinit
>> annotation or the annotation of pat_disable is wrong.
>>
>> Config is in attachment.
>>
>
> This should fix it:
>
> --- a/arch/x86/mm/pat.c~arch-x86-mm-patc-nopat-should-be-__init
> +++ a/arch/x86/mm/pat.c
> @@ -34,7 +34,7 @@ void __cpuinit pat_disable(char *reason)
>        printk(KERN_INFO "%s\n", reason);
>  }
>
> -static int nopat(char *str)
> +static int __init nopat(char *str)
>  {
>        pat_disable("PAT support disabled.");
>        return 0;
> _
>
>
> It turns out that this was harmless.  However it might not have been -
> I think that adding the ability to suppress all these warnings was a
> mistake.
>
