Return-Path: <linux-kernel-owner+w=401wt.eu-S2993155AbXDTNOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993155AbXDTNOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 09:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992675AbXDTNOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 09:14:45 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:29205 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767089AbXDTNOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 09:14:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nTa1rbiDYLdjockq9mersIph+VSswa9URjbCECSqe30UAi1WVfzR8zE9hGJVxEDu01it5igr5paMkIHhn+ivj230cmST4woz6Z1NiP2QgDlAvT3bUd9Hs04hsgdJZ9siBfYbeoxRquDxpO/h+PnZCvC8pNasS5B6KAySIgvm8pg=
Message-ID: <6d6a94c50704200614n3e258142n4008029171656d23@mail.gmail.com>
Date: Fri, 20 Apr 2007 21:14:43 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH] CONFIG_PACKET_MMAP should depend on MMU
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>, uaca@alumni.uv.es,
       bryan.wu@analog.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       waltje@uwalt.nl.mugnet.org, netdev@vger.kernel.org,
       "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <2181.1177059532@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704091146.32346.rgetz@blackfin.uclinux.org>
	 <1176112223.17975.8.camel@roc-desktop> <9561.1176209728@redhat.com>
	 <200704101952.05380.rgetz@blackfin.uclinux.org>
	 <6d6a94c50704170336l62fc9ael1e58197e6c3853ba@mail.gmail.com>
	 <2817.1176910411@redhat.com>
	 <6d6a94c50704192146k5bbe2aefr31fa5726bf1c1e54@mail.gmail.com>
	 <1016.1177055893@redhat.com>
	 <6d6a94c50704200139vb9b24f6y77a6d23544c8f7b9@mail.gmail.com>
	 <2181.1177059532@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/07, David Howells <dhowells@redhat.com> wrote:
> Aubrey Li <aubreylee@gmail.com> wrote:
>
> > as checked in packet_set_ring, buffer size must be a multiple of PAGE_SIZE,
> > --------------------packet_set_ring------------------------
> > if (unlikely(req->tp_block_size & (PAGE_SIZE - 1)))
> >
> > So why not use __get_free_pages rather than kmalloc,
>
> Because kmalloc() may be able to get us a smaller chunk of memory.  Actually,
> calling __get_free_pages() might be a better, and then release the excess
> pages.
>

>> so that we have pagetables to count?

>There are no pagetables in NOMMU-mode.

Hmm..., I'm thinking some codes in memory reclaim depend on
NR_FILE_MMAPED like follows
----snip----
if (zone_page_state(zone, NR_FILE_PAGES) -
                        zone_page_state(zone, NR_FILE_MAPPED) >
                        zone->min_unmapped_pages)
----snip----
Since we are enabling packet mmap feature, we should take its mapped
pages into count of NR_FILE_MAPPED.

-Aubrey
