Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbYIKDnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbYIKDnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 23:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYIKDnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 23:43:33 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:3340 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbYIKDnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 23:43:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=DE3v2M3kbhKGg98HPMr7nlp/UqucrkHPP9GnWnaPqTiS8L9gocTYAt8sXvDEGsg75R
         fRoK8iaAF5j7r0R3Z5i1BuOxM2WO+PyRhPLXNbiNkrvVKh3aFwQNEaKCfzd54VI/u8ut
         GOxiaLqdtDF2Y+GUqJsNGUieatfOAdzao1M2Y=
Message-ID: <386072610809102043ie1107dp45e46889483048e7@mail.gmail.com>
Date: Thu, 11 Sep 2008 11:43:31 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] fastboot: fix blackfin breakage due to vmlinux.lds change
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, vapier.adi@gmail.com
In-Reply-To: <20080910082534.12344a1c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080910082534.12344a1c@infradead.org>
X-Google-Sender-Auth: 32731c16165af042
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 11:25 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> Hi,
>
> the patch below fixes the fastboot bug as reported by Mike Frysinger;
> I've commited this to
> git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-fastboot.git
>
> Ingo, please also add to -tip
>
>
> From 16aeda33acbb711863d8fff78c15b32ad0d4aa89 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Wed, 10 Sep 2008 08:22:26 -0700
> Subject: [PATCH] fastboot: fix blackfin breakage due to vmlinux.lds change
>
> As reported by Mike Frysinger, the vmlinux.lds changes should
> have used VMLINUX_SYMBOL()...
>

Thanks a lot, Mike and Arjan. This issue was found by Mike's auto
nightly building machine.

Acked-by: Bryan Wu <cooloney@kernel.org>

> Reported-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  include/asm-generic/vmlinux.lds.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 020c641..f32418f 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -373,11 +373,11 @@
>        *(.initcall5s.init)                                             \
>        *(.initcallrootfs.init)                                         \
>        *(.initcall6s.init)                                             \
> -       __async_initcall_start = .;                                     \
> +       VMLINUX_SYMBOL(__async_initcall_start) = .;                     \
>        *(.initcall6a.init)                                             \
> -       __async_initcall_end = .;                                       \
> +       VMLINUX_SYMBOL(__async_initcall_end) = .;                       \
>        *(.initcall6.init)                                              \
> -       __device_initcall_end = .;                                      \
> +       VMLINUX_SYMBOL(__device_initcall_end) = .;                      \
>        *(.initcall7.init)                                              \
>        *(.initcall7s.init)
>
> --
> 1.5.5.1
>
>
>
>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
