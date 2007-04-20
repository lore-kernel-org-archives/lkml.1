Return-Path: <linux-kernel-owner+w=401wt.eu-S1766898AbXDTI7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766898AbXDTI7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766807AbXDTI7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:59:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766692AbXDTI7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:59:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <6d6a94c50704200139vb9b24f6y77a6d23544c8f7b9@mail.gmail.com> 
References: <6d6a94c50704200139vb9b24f6y77a6d23544c8f7b9@mail.gmail.com>  <200704091146.32346.rgetz@blackfin.uclinux.org> <1176112223.17975.8.camel@roc-desktop> <9561.1176209728@redhat.com> <200704101952.05380.rgetz@blackfin.uclinux.org> <6d6a94c50704170336l62fc9ael1e58197e6c3853ba@mail.gmail.com> <2817.1176910411@redhat.com> <6d6a94c50704192146k5bbe2aefr31fa5726bf1c1e54@mail.gmail.com> <1016.1177055893@redhat.com> 
To: "Aubrey Li" <aubreylee@gmail.com>
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>, uaca@alumni.uv.es,
       bryan.wu@analog.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       waltje@uwalt.nl.mugnet.org, netdev@vger.kernel.org,
       "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CONFIG_PACKET_MMAP should depend on MMU 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Fri, 20 Apr 2007 09:58:52 +0100
Message-ID: <2181.1177059532@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aubrey Li <aubreylee@gmail.com> wrote:

> as checked in packet_set_ring, buffer size must be a multiple of PAGE_SIZE,
> --------------------packet_set_ring------------------------
> if (unlikely(req->tp_block_size & (PAGE_SIZE - 1)))
> 
> So why not use __get_free_pages rather than kmalloc,

Because kmalloc() may be able to get us a smaller chunk of memory.  Actually,
calling __get_free_pages() might be a better, and then release the excess
pages.

> so that we have pagetables to count?

There are no pagetables in NOMMU-mode.

David
