Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591Ab0AGCDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab0AGCDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 21:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559Ab0AGCDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 21:03:53 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:43667 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab0AGCDw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:03:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lRkt1EoWi5xKfdqpvMVQ9hU7ujh405N3VDB9AF4Xh79Al+NSuEn1VA/cb45v5vZdqg
         Co3BHQ5VEp7Fglw9bEG96axCAcUb9woooZOsYHtQPnfsTd5fkjM/4+wTAJ5w/FcHeUu8
         aet2ZWUvzf6MJ6m7xE+C0rNCQkVvdv16Vznds=
MIME-Version: 1.0
In-Reply-To: <1262651630-7354-59-git-send-email-gregkh@suse.de>
References: <20100105003133.GA7199@kroah.com> <1262651630-7354-59-git-send-email-gregkh@suse.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 6 Jan 2010 21:03:31 -0500
Message-ID: <8bd0f97a1001061803xe3cdd80l1a3c416902452134@mail.gmail.com>
Subject: Re: [PATCH 59/97] NOMMU: Optimise away the {dac_,}mmap_min_addr tests
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 4, 2010 at 19:33, Greg Kroah-Hartman wrote:
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1200,6 +1200,7 @@ static struct ctl_table vm_table[] = {
>                .extra2         = (void *)&hugetlb_infinity,
>        },
>  #endif
> +#ifdef CONFIG_MMU
>        {
>                .ctl_name       = VM_LOWMEM_RESERVE_RATIO,
>                .procname       = "lowmem_reserve_ratio",
> @@ -1353,6 +1354,7 @@ static struct ctl_table vm_table[] = {
>                .mode           = 0644,
>                .proc_handler   = &mmap_min_addr_handler,
>        },
> +#endif
>  #ifdef CONFIG_NUMA
>        {
>                .ctl_name       = CTL_UNNUMBERED,

seems there was a merge error here when adding the patch to the stable
branch.  this change disables a large number of things when it should
only be disabling mmap_min_addr.  notice how the first #ifdef appears
at line ~1200 while the second appears at line ~1353.  the original
commit was ~1214 to ~1221.
-mike
