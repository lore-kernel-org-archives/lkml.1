Return-Path: <linux-kernel-owner+w=401wt.eu-S1761011AbZE1NSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761011AbZE1NSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 09:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758021AbZE1NSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 09:18:15 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:58801 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455AbZE1NSO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 09:18:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eGnyhmah38pAE8MXuOZkvaqFsLceLm49JaWSPtO8juI8atnCRtfgtgLX3f63tY7RSt
         Vrq/oTyrRkZFcFz1MEyhp9Z7WLGQiFOzPtv5a6B8Lh5eNfZXF+kXNOdbmKDcEDglcwnn
         CKdcDkCefu4D3Z4G1kZTczlKdbniXJJE9NLEI=
MIME-Version: 1.0
In-Reply-To: <20090515075229.11346.6710.sendpatchset@localhost.localdomain>
References: <20090515075229.11346.6710.sendpatchset@localhost.localdomain>
Date: Thu, 28 May 2009 21:18:16 +0800
Message-ID: <3877989d0905280618idba1b35x72ecc222c5cf16a2@mail.gmail.com>
Subject: Re: [Patch] kbuild: fix a compile warning
From: Luming Yu <luming.yu@gmail.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 3:51 PM, Amerigo Wang <amwang@redhat.com> wrote:
>
> I got this warning:
>
>  HOSTCC  scripts/basic/fixdep
> scripts/basic/fixdep.c: In function 'traps':
> scripts/basic/fixdep.c:377: warning: dereferencing type-punned pointer will break strict-aliasing rules
> scripts/basic/fixdep.c:379: warning: dereferencing type-punned pointer will break strict-aliasing rules


these warnings can be supressed by adding a compile option -fno-strict-aliasing


>
> Patch below fixes it.
>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
>
> ---
> diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
> index 8912c0f..72c1520 100644
> --- a/scripts/basic/fixdep.c
> +++ b/scripts/basic/fixdep.c
> @@ -373,10 +373,11 @@ void print_deps(void)
>  void traps(void)
>  {
>        static char test[] __attribute__((aligned(sizeof(int)))) = "CONF";
> +       int *p = (int *)test;
>
> -       if (*(int *)test != INT_CONF) {
> +       if (*p != INT_CONF) {
>                fprintf(stderr, "fixdep: sizeof(int) != 4 or wrong endianess? %#x\n",
> -                       *(int *)test);
> +                       *p);
>                exit(2);
>        }
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
