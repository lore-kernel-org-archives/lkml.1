Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbYFJMUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbYFJMUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 08:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbYFJMUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 08:20:04 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:7430 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbYFJMUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 08:20:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FWTG3UvmKmeZRJMNBNA29cY1DkN4lJbKvMywz/BMBqo7F3ucG43Curv2YhiN77F63K
         8yZuV4Ez+quC5kmcoxhe2uVr2d07mr9IIFFGAHVv9fVoyDwOJ1trS9f0AIRZdjowBJs8
         pbvRGn/hMkN8fzWs8nuKEz+fFlah5ytGyFNZo=
Message-ID: <d1af83620806100520u4a0110e4y4db27c8fc412500b@mail.gmail.com>
Date: Tue, 10 Jun 2008 09:20:01 -0300
From: "Kevin Winchester" <kjwinchester@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH] Fix an incompatible pointer type warning on x86_64 compilations
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@redhat.com>
In-Reply-To: <20080607161840.4803.48478.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080607161840.4803.48478.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2008 at 1:18 PM, David Howells <dhowells@redhat.com> wrote:
> Fix an incompatible pointer type warning on x86_64 compilations.
> early_memtest() is passing a u64* to find_e820_area_size() which is expecting
> an unsigned long.  Change t_start and t_size to unsigned long as those are
> also 64-bit types on x88_64.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  arch/x86/mm/init_64.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
>
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 156e6d7..998a06e 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -506,7 +506,7 @@ early_param("memtest", parse_memtest);
>
>  static void __init early_memtest(unsigned long start, unsigned long end)
>  {
> -       u64 t_start, t_size;
> +       unsigned long t_start, t_size;
>        unsigned pattern;
>
>        if (!memtest_pattern)
> @@ -525,7 +525,7 @@ static void __init early_memtest(unsigned long start, unsigned long end)
>                        if (t_start + t_size > end)
>                                t_size = end - t_start;
>
> -                       printk(KERN_CONT "\n  %016llx - %016llx pattern %d",
> +                       printk(KERN_CONT "\n  %016lx - %016lx pattern %d",
>                                t_start, t_start + t_size, pattern);
>
>                        memtest(t_start, t_size, pattern);
>

This is essentially a revert of a patch I sent to Ingo for a warning I
saw in linux-next.  Has find_e820_area_size() changed in linux-next to
take u64 instead of unsigned long?  In any case, the patch should not
have been submitted to Linus, since it was only in next that I saw the
warning.  Sorry for the confusion.

-- 
Kevin Winchester
