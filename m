Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbZB1HCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbZB1HCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 02:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbZB1HCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 02:02:10 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:23052 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbZB1HCJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 02:02:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vlfAbVZhNpp5c8/OqWww9E7Zp7qIqP6zjwIgWlXR77rHOQotfuJQndesC4kBPepzP4
         M00wTWEEkQOKreZaziXEo3wHIUzJusOT9aaegsdD7d0PmKHtR5VcKWBZNlOjc0BBo0EL
         LE40VPg6L8k2JB0Ezf/y1OSKhihL5fLQOBT6E=
MIME-Version: 1.0
In-Reply-To: <1235785882-17580-4-git-send-email-jeremy@goop.org>
References: <1235785882-17580-1-git-send-email-jeremy@goop.org>
	 <1235785882-17580-4-git-send-email-jeremy@goop.org>
Date: Fri, 27 Feb 2009 23:02:06 -0800
X-Google-Sender-Auth: f624969a73395c95
Message-ID: <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com>
Subject: Re: [PATCH] x86-32: use brk segment for allocating initial kernel 
	pagetable
From: Yinghai Lu <yinghai@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 5:51 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>
> Rather than having special purpose init_pg_table_start/end variables
> to delimit the kernel pagetable built by head_32.S, just use the brk
> mechanism to extend the bss for the new pagetable.
>
> This patch removes init_pg_table_start/end and pg0, defines __brk_base
> (which is page-aligned and immediately follows _end), initializes
> the brk region to start there, and uses it for the 32-bit pagetable.
...

> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index c246dc4..ed02176 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -113,8 +113,10 @@
>  #endif
>
>  unsigned int boot_cpu_id __read_mostly;
> -__initdata unsigned long _brk_start = (unsigned long)&_end;
> -__initdata unsigned long _brk_end = (unsigned long)&_end;
> +
> +extern char __brk_base[];
> +__initdata unsigned long _brk_start = (unsigned long)__brk_base;
> +__initdata unsigned long _brk_end = (unsigned long)&__brk_base;

?

YH
