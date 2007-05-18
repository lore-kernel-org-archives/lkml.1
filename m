Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbXERHQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbXERHQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 03:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbXERHQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 03:16:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59511
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754052AbXERHQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 03:16:02 -0400
Date: Fri, 18 May 2007 00:16:04 -0700 (PDT)
Message-Id: <20070518.001604.23011298.davem@davemloft.net>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 05/14] all-archs: consolidate .data section definition
 in asm-generic
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070518065257.GE12284@uranus.ravnborg.org>
References: <20070518064126.GA12193@uranus.ravnborg.org>
	<20070518065257.GE12284@uranus.ravnborg.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 18 May 2007 08:52:57 +0200

> >From 653bc43c6c2c292e6abc98860fd241eb12e2c80f Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Thu, 17 May 2007 13:38:44 +0200
> Subject: [PATCH 05/14] all-archs: consolidate .data section definition in asm-generic
> 
> With this consolidation we can now modify the .data
> section definition in one spot for all archs.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

Thanks for doing these kinds of consolidations Sam, most of
us arch maintainers really appreciate it.

Looking at these patches reminds me of a quirk in the generic
RODATA definition:

>  #define RODATA								\
>  	. = ALIGN(4096);						\
>  	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\

It uses ALIGN(4096) which is likely supposed to be something
like ALIGN(PAGE_SIZE).  Perhaps we should handle this by
definiting a LD_PAGE_SIZE at the top of vmlinux.ld.S files
that need a value other than 4096, and define the default of
4096 in asm-generic/vmlinux.lds.h?

If you could take care of this I'd really appreciate it.
