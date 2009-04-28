Return-Path: <linux-kernel-owner+w=401wt.eu-S932177AbZD1Hjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbZD1Hjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 03:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760655AbZD1HjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 03:39:10 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:43363 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760621AbZD1HjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 03:39:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=h2EPu3AtZE/sqUNdsOt2SREf1wpc2bOuyvqjLk8pUcVHbT2KbCA5CCHQgtaQ0lT5VW
         MY8quL2arH2EgkC//uoWGsDAeAcLxGuhB8KInV9C3BzJNe2kv2ijtfGQYRIG8eb4/VPS
         h+GkhCURDPzNzVPG+XXXW/XFOa75P+9+2pTs8=
MIME-Version: 1.0
In-Reply-To: <1240864388-26315-10-git-send-email-tabbott@mit.edu>
References: <1240864388-26315-1-git-send-email-tabbott@mit.edu>
	 <1240864388-26315-2-git-send-email-tabbott@mit.edu>
	 <1240864388-26315-3-git-send-email-tabbott@mit.edu>
	 <1240864388-26315-4-git-send-email-tabbott@mit.edu>
	 <1240864388-26315-5-git-send-email-tabbott@mit.edu>
	 <1240864388-26315-6-git-send-email-tabbott@mit.edu>
	 <1240864388-26315-7-git-send-email-tabbott@mit.edu>
	 <1240864388-26315-8-git-send-email-tabbott@mit.edu>
	 <1240864388-26315-9-git-send-email-tabbott@mit.edu>
	 <1240864388-26315-10-git-send-email-tabbott@mit.edu>
Date: Tue, 28 Apr 2009 11:39:07 +0400
X-Google-Sender-Auth: 8e1d7a8c316d255f
Message-ID: <aa79d98a0904280039l3eef7e76g3994018c2e9d42eb@mail.gmail.com>
Subject: Re: [PATCH 09/14] s390: Use macros for .data.page_aligned.
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Tim Abbott <tabbott@mit.edu>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@mit.edu>, Paul Mundt <lethal@linux-sh.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/09, Tim Abbott <tabbott@mit.edu> wrote:
> .data.page_aligned should not need a separate output section, so as
> part of this cleanup I moved into the .data output section in the
> linker scripts in order to eliminate unnecessary references to the
> section name.
>
> Remove the reference to .data.idt, since nothing is put into the
> .data.idt section on the s390 architecture.  It looks like Cyrill
> Gorcunov posted a patch to remove the .data.idt code on s390
> previously:
>
> <http://lkml.indiana.edu/hypermail/linux/kernel/0802.2/2536.html>
>
> CCing him and the people who acked that patch in case there's a reason
> it wasn't applied.
>

It was not applied case of being a bit buggy.
You've fixed it as well. Thanks and my ack if needed.

> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/s390/kernel/vdso.c                  |    2 +-
>  arch/s390/kernel/vdso32/vdso32_wrapper.S |    3 ++-
>  arch/s390/kernel/vdso64/vdso64_wrapper.S |    3 ++-
>  arch/s390/kernel/vmlinux.lds.S           |    6 +-----
>  4 files changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
> index 89b2e7f..eff6fba 100644
> --- a/arch/s390/kernel/vdso.c
> +++ b/arch/s390/kernel/vdso.c
> @@ -64,7 +64,7 @@ __setup("vdso=", vdso_setup);
>  static union {
>  	struct vdso_data	data;
>  	u8			page[PAGE_SIZE];
> -} vdso_data_store __attribute__((__section__(".data.page_aligned")));
> +} vdso_data_store __page_aligned_data
>  struct vdso_data *vdso_data = &vdso_data_store.data;
>
>  /*
> diff --git a/arch/s390/kernel/vdso32/vdso32_wrapper.S
> b/arch/s390/kernel/vdso32/vdso32_wrapper.S
> index 61639a8..ae42f8c 100644
> --- a/arch/s390/kernel/vdso32/vdso32_wrapper.S
> +++ b/arch/s390/kernel/vdso32/vdso32_wrapper.S
> @@ -1,7 +1,8 @@
>  #include <linux/init.h>
> +#include <linux/linkage.h>
>  #include <asm/page.h>
>
> -	.section ".data.page_aligned"
> +	__PAGE_ALIGNED_DATA
>
>  	.globl vdso32_start, vdso32_end
>  	.balign PAGE_SIZE
> diff --git a/arch/s390/kernel/vdso64/vdso64_wrapper.S
> b/arch/s390/kernel/vdso64/vdso64_wrapper.S
> index d8e2ac1..c245842 100644
> --- a/arch/s390/kernel/vdso64/vdso64_wrapper.S
> +++ b/arch/s390/kernel/vdso64/vdso64_wrapper.S
> @@ -1,7 +1,8 @@
>  #include <linux/init.h>
> +#include <linux/linkage.h>
>  #include <asm/page.h>
>
> -	.section ".data.page_aligned"
> +	__PAGE_ALIGNED_DATA
>
>  	.globl vdso64_start, vdso64_end
>  	.balign PAGE_SIZE
> diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
> index 89399b8..d552089 100644
> --- a/arch/s390/kernel/vmlinux.lds.S
> +++ b/arch/s390/kernel/vmlinux.lds.S
> @@ -59,6 +59,7 @@ SECTIONS
>  	} :data
>
>  	.data : {		/* Data */
> +		PAGE_ALIGNED_DATA
>  		DATA_DATA
>  		CONSTRUCTORS
>  	}
> @@ -71,11 +72,6 @@ SECTIONS
>  	. = ALIGN(PAGE_SIZE);
>  	__nosave_end = .;
>
> -	. = ALIGN(PAGE_SIZE);
> -	.data.page_aligned : {
> -		*(.data.idt)
> -	}
> -
>  	. = ALIGN(0x100);
>  	.data.cacheline_aligned : {
>  		*(.data.cacheline_aligned)
> --
> 1.6.2.1
>
>
