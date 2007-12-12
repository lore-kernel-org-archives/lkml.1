Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbXLLJHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbXLLJHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 04:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756176AbXLLJHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 04:07:10 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:45487 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754479AbXLLJHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 04:07:09 -0500
Date: Wed, 12 Dec 2007 10:07:09 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Shane <gnome42@gmail.com>, Brandon Philips <brandon@ifup.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>
Subject: Re: 2.6.24-rc5 "videobuf_read_start"
	[drivers/media/video/videobuf-dvb.ko] undefined!
Message-ID: <20071212090709.GF14204@stusta.de>
References: <fa4052ef0712112120l1165af5btc108ea2131760328@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fa4052ef0712112120l1165af5btc108ea2131760328@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch looks good, it seems a merge conflict of
commit 19bc5133dae9562e8824ef101464061f9854c1d8
was resolved the wrong way.

@Mauro:
Any objections against a later path that changes the exports to the 
general "immediately after the function" convention?
It would have avoided at least two such bugs in this file alone since 
2.6.23...

cu
Adrian


On Wed, Dec 12, 2007 at 12:20:31AM -0500, Shane wrote:
> In 2.6.24-rc5+, I hit this problem with videobuf_read_start
> not being exported. Patch attached, only compile tested.
> 
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   CC [M]  drivers/media/video/videobuf-core.o
>   Building modules, stage 2.
> Kernel: arch/x86/boot/bzImage is ready  (#1)
>   MODPOST 202 modules
> ERROR: "videobuf_read_start" [drivers/media/video/videobuf-dvb.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> Shane

> diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
> index de2f56b..44fa76b 100644
> --- a/drivers/media/video/videobuf-core.c
> +++ b/drivers/media/video/videobuf-core.c
> @@ -1058,6 +1058,7 @@ EXPORT_SYMBOL_GPL(videobuf_dqbuf);
>  EXPORT_SYMBOL_GPL(videobuf_streamon);
>  EXPORT_SYMBOL_GPL(videobuf_streamoff);
>  
> +EXPORT_SYMBOL_GPL(videobuf_read_start);
>  EXPORT_SYMBOL_GPL(videobuf_read_stop);
>  EXPORT_SYMBOL_GPL(videobuf_stop);
>  EXPORT_SYMBOL_GPL(videobuf_read_stream);


