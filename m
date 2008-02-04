Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbYBDVCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbYBDVCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYBDVCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:02:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:5255 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYBDVCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:02:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R8R1do8/plWGu3GLHKqd8fm+Fga0xm1rD0WjhDJf78p1w+TlReTh0A5v/4LOmK+CGTFwxqP7zxN+tSVYAzQCp0wpxiyXWJ3U0AOf8Lnk5FGVWaVnTwQyfb6LojSRtMR/mRnUB1Pd/0oHaaLXnKmaMLy2Eufu3yGjdLYzo5u5WzU=
Message-ID: <6101e8c40802041302l83b0b86n9646bdb9e820f6cd@mail.gmail.com>
Date: Mon, 4 Feb 2008 22:02:03 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: stable@kernel.org
Subject: Re: {2.6.22.y} CVE-2007-6434
Cc: linux-kernel@vger.kernel.org, "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "Greg KH" <gregkh@suse.de>, "Willy Tarreau" <w@1wt.eu>,
       "Adrian Bunk" <bunk@kernel.org>, "Nick Piggin" <npiggin@suse.de>
In-Reply-To: <6101e8c40802041213y4f3cb310qaff40052ed18d5df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40802041213y4f3cb310qaff40052ed18d5df@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry, drop this ..


/usr/data/source/oliver/build/linux-2.6.22.y-rcX-stable/mm/mmap.c: In
function 'do_brk':
/usr/data/source/oliver/build/linux-2.6.22.y-rcX-stable/mm/mmap.c:1889:
error: too many arguments to function 'security_file_mmap'
make[6]: *** [mm/mmap.o] Error 1
make[5]: *** [mm] Error 2


On 2/4/08, Oliver Pinter <oliver.pntr@gmail.com> wrote:
> mainline: ecaf18c15aac8bb9bed7b7aa0e382fe252e275d5
>
> --->8---
> commit ecaf18c15aac8bb9bed7b7aa0e382fe252e275d5
> Author: Eric Paris <eparis@redhat.com>
> Date:   Tue Dec 4 23:45:31 2007 -0800
>
>     VM/Security: add security hook to do_brk
>
>     Given a specifically crafted binary do_brk() can be used to get low
> pages
>     available in userspace virtual memory and can thus be used to circumvent
>     the mmap_min_addr low memory protection.  Add security checks in
> do_brk().
>
>     Signed-off-by: Eric Paris <eparis@redhat.com>
>     Acked-by: Alan Cox <alan@redhat.com>
>     Cc: Stephen Smalley <sds@tycho.nsa.gov>
>     Cc: James Morris <jmorris@namei.org>
>     Cc: Chris Wright <chrisw@sous-sol.org>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index facc1a7..acfc13f 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1934,6 +1934,10 @@ unsigned long do_brk(unsigned long addr, unsigned
> long le
>         if (is_hugepage_only_range(mm, addr, len))
>                 return -EINVAL;
>
> +       error = security_file_mmap(0, 0, 0, 0, addr, 1);
> +       if (error)
> +               return error;
> +
>         flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
>
>         error = arch_mmap_check(addr, len, flags);
> ---8<---
> --
> Thanks,
> Oliver
>


-- 
Thanks,
Oliver
