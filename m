Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbXITAYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbXITAYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 20:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbXITAYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 20:24:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37967 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214AbXITAYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 20:24:36 -0400
Date: Wed, 19 Sep 2007 17:24:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Antonino Daplas <adaplas@pol.net>, linux-fbdev-devel@lists.sourceforge.net,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/video/pmag-ba-fb.c: Improve diagnostics
Message-Id: <20070919172412.725508d0.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64N.0709181314300.9650@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0709171736580.17606@blysk.ds.pg.gda.pl>
	<Pine.LNX.4.64N.0709181314300.9650@blysk.ds.pg.gda.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 13:18:34 +0100 (BST)
"Maciej W. Rozycki" <macro@linux-mips.org> wrote:

>  Add error messages to the probe call.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
>  While they may rarely trigger, they may be useful when something weird is 
> going on.  Also this is good style.
> 
>  This is an updated version that addresses an issue raised by Mariusz 
> Kozlowski for the sibling patch.  Checked with checkpatch.pl.
> 
>  Please apply.
> 
>   Maciej
> 
> patch-mips-2.6.23-rc5-20070904-pmag-ba-err-2
> diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/drivers/video/pmag-ba-fb.c linux-mips-2.6.23-rc5-20070904/drivers/video/pmag-ba-fb.c
> --- linux-mips-2.6.23-rc5-20070904.macro/drivers/video/pmag-ba-fb.c	2007-02-21 05:56:47.000000000 +0000
> +++ linux-mips-2.6.23-rc5-20070904/drivers/video/pmag-ba-fb.c	2007-09-18 10:56:51.000000000 +0000
> @@ -147,16 +147,23 @@ static int __init pmagbafb_probe(struct 
>  	resource_size_t start, len;
>  	struct fb_info *info;
>  	struct pmagbafb_par *par;
> +	int err = 0;

This initialisation to zero is not good.

Because if some error-path code forgot to do `err = -EFOO' then probe()
will return zero and the driver will leave things in half-initialised state
and will then proceed as if things had succeeded.  It will crash.

So it's better to leave this local uninitialised, because we really want to
get that compiler warning if someone forgot to set the return value.

I made that change, but am too stupid to be able to work out how to create
a config which will let me compile this thing.

akpm:/usr/src/25> grep PMAG arch/arm/configs/*
akpm:/usr/src/25> 

bah.
