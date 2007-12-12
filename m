Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbXLLKv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbXLLKv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758164AbXLLKvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:51:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52042 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067AbXLLKvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:51:39 -0500
Subject: Re: 2.6.24-rc5 "videobuf_read_start"
	[drivers/media/video/videobuf-dvb.ko] undefined!
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Shane <gnome42@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>,
       Soeren Sonnenburg <kernel@nn7.de>
In-Reply-To: <fa4052ef0712112120l1165af5btc108ea2131760328@mail.gmail.com>
References: <fa4052ef0712112120l1165af5btc108ea2131760328@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 12 Dec 2007 08:51:24 -0200
Message-Id: <1197456684.4807.27.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Em Qua, 2007-12-12 às 00:20 -0500, Shane escreveu:
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
Thanks for reporting.

The patch is incomplete. I've just sent Linus the complete fix for this.

The issue here is that videobuf_read_start were replaced by
__videobuf_read_start, but mutex is missing at the last.

The patch I've just sent adds a mutex-safe version of
videobuf_read_start, adding the proper EXPORT_SYMBOL_GPL().
 
Cheers,
Mauro

