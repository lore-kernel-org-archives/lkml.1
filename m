Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbXFVM70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbXFVM70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 08:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbXFVM7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 08:59:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbXFVM7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 08:59:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <46695F6D.5050600@t-online.de>
References: <46695F6D.5050600@t-online.de>
To: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Wu, Bryan" <Bryan.Wu@analog.com>
Subject: Re: [PATCH, RFD]: Unbreak no-mmu mmap
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Fri, 22 Jun 2007 13:59:10 +0100
Message-ID: <13681.1182517150@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schmidt <bernds_cb1@t-online.de> wrote:

> +					 MAP_PRIVATE | MAP_ANONYMOUS
> +					 | MAP_GROWSDOWN | MAP_SPLIT_PAGES, 0);

The OR-operator should end the first line.

> diff --git a/include/asm-blackfin/mman.h b/include/asm-blackfin/mman.h
> index 4d504f9..07057b6 100644
> --- a/include/asm-blackfin/mman.h
> +++ b/include/asm-blackfin/mman.h
> @@ -24,6 +24,7 @@
>  #define MAP_NONBLOCK	0x10000	/* do not block on IO */
>  #define MAP_UNINITIALIZE 0x4000000  /* For anonymous mmap, memory could
>                                      be uninitialized. */
> +#define MAP_SPLIT_PAGES  0x8000000  /* Conserve memory (nommu only). */

Blackfin should really use asm-generic/mman.h if it can.

I'll produce my own version of the patch and pass it back to you once I've got
FRV compiling with it.

David
