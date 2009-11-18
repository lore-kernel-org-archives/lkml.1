Return-Path: <linux-kernel-owner+w=401wt.eu-S932132AbZKRVcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbZKRVcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932088AbZKRVcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:32:21 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:40865 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbZKRVcU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:32:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZfandKRKubgaZVNoCZLRG9v275/MLPA4Dh1fpnl0gm4hoGibg8bUgcJQAZL3b+SSvE
         1wB3HYKHQ/x5pQ1JeeWr8Tb+riaJWBzGYXeF7sIfFPuTQO8LnJfKXxbZTe86kPtmwtHz
         Vm75HTKIHmRaBdxiWaMSEsptm5AMokASiRrdI=
MIME-Version: 1.0
In-Reply-To: <200910181655.40579.sfking00@yahoo.com>
References: <200910181655.40579.sfking00@yahoo.com>
Date: Wed, 18 Nov 2009 22:32:25 +0100
X-Google-Sender-Auth: 01942e9177b57edd
Message-ID: <10f740e80911181332u48f8e610o4354cfd3994c8510@mail.gmail.com>
Subject: Re: [PATCH] [Repost without wordwrapping] Merge m68k and m68knommu
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Steven King <sfking00@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       uclinux-dev@uclinux.org, Greg Ungerer <gerg@snapgear.com>,
       Roman Zippel <zippel@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 00:55, Steven King <sfking00@yahoo.com> wrote:
> This is a script and patch to merge the m68knommu arch into m68k.

Thanks, nice!

> The script was inspired by the script Sam Ravnborg used to merge the
> includes from m68knommu. For those files common to both arches but
> differing in content, the m68k version of the file is renamed to
> <file>_mm.<ext> and the m68knommu version of the file is moved into the
> corresponding m68k directory and renamed <file>_no.<ext> and a small
> wrapper file <file>.<ext> is used to select between the two version. Files
> that are common to both but don't differ are removed from the m68knommu
> tree and files and directories that are unique to the m68knommu tree are
> moved to the m68k tree. Finally, the arch/m68knommu tree is removed.
>
> To select between the the versions of the files, the wrapper uses
>
> #ifdef CONFIG_MMU
> #include <file>_mm.<ext>
> #else
> #include <file>_no.<ext>
> #endif
>
> The patch modifies the toplevel Makefile so that ARCH=m68knommu still works
> (by setting SRCARCH=m68k) and adds the m68knommu Kconfig and Makefile
> to the m68k Kconfig and Makefile, using the definition of ARCH to select
> which values to use.

(still dreaming of my pet Amiga-nommu project) I prefer to use
CONFIG_MMU as the selector...

> Thus when building for either a m68k or an m68knommu target, one still
> specifies either ARCH=m68k or ARCH=m68knommu and everything should
> build EXACTLY as it did pre-merge.  (I think).

... using CONFIG_MMU would change this?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
