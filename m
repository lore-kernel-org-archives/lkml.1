Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbYJAPFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbYJAPFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 11:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYJAPFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 11:05:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbYJAPFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 11:05:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1222818570.13453.5.camel@calx>
References: <1222818570.13453.5.camel@calx>
To: Matt Mackall <mpm@selenic.com>
Cc: dhowells@redhat.com, Hugh Dickins <hugh@veritas.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: unify shmem and tiny-shmem
Date: Wed, 01 Oct 2008 16:00:01 +0100
Message-ID: <5183.1222873201@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall <mpm@selenic.com> wrote:

> (This applies on top of Nick's second tiny-shmem patch, which hasn't
> made it to mainline yet(!). But as this deletes tiny-shmem.c, you can
> probably ignore the rejects.)
> 
> tiny-shmem shares most of its 130 lines of code with shmem and tends
> to break when particular bits of shmem get modified. Unifying saves
> code and makes keeping these two in sync much easier.
> 
> before:
>   14367	    392	     24	  14783	   39bf	mm/shmem.o
>     396      72       8     476	    1dc	mm/tiny-shmem.o
> 
> after:
>   14367	    392	     24	  14783	   39bf	mm/shmem.o
>     412	     72       8     492	    1ec	mm/shmem.o tiny
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>

Works with my test program:

	http://people.redhat.com/~dhowells/doshm.c

Compile and run:

	doshm sysv

warthog>size mm/tiny-shmem.o
   text    data     bss     dec     hex filename
    788      36       4     828     33c mm/tiny-shmem.o
warthog>size mm/shmem.o
   text    data     bss     dec     hex filename
    832      36       4     872     368 mm/shmem.o


Acked-by: David Howells <dhowells@redhat.com>
