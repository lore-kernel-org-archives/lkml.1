Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbYG3QLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbYG3QLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 12:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbYG3QLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 12:11:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:41219 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbYG3QLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 12:11:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=G0ByAU9NHEYMC+qXaprzmTrr/qW9Bw+h21iwhw2ffXA5+z/tNCprOZ4iZ35XASNOez
         PixpXRfzkUQm0/6ZeVyHJ90kF//j1sGraFEL+gg+o86BxGLZ5fWRq6HRAGWfzxc3Vhkx
         oVT+2N9lhh7DxEl+jV9a4jaUxxONsmPSvLXEI=
Message-ID: <8bd0f97a0807300911n4ae81b70v97276abf612f6b3e@mail.gmail.com>
Date: Wed, 30 Jul 2008 12:11:37 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Yoshinori Sato" <ysato@users.sourceforge.jp>
Subject: Re: [PATCH] blackfin / h8300 build error fix
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <87provuzwk.wl%ysato@users.sourceforge.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87provuzwk.wl%ysato@users.sourceforge.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 11:58 AM, Yoshinori Sato wrote:
> init/main.c:781: undefined reference to `___early_initcall_end'
>
> Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
>
> ---
>  include/asm-generic/vmlinux.lds.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 6d88a92..07b2784 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -362,7 +362,7 @@
>
>  #define INITCALLS                                                      \
>        *(.initcallearly.init)                                          \
> -       __early_initcall_end = .;                                       \
> +       VMLINUX_SYMBOL(__early_initcall_end) = .;                       \
>        *(.initcall0.init)                                              \
>        *(.initcall0s.init)                                             \
>        *(.initcall1.init)                                              \
> --
> 1.5.6.3

nice catch, thanks ... looks like BUG_TABLE, TRACEDATA, and PERCPU are
also broken, but blackfin/etc... arent using those which is why we
havent noticed yet ...
-mike
