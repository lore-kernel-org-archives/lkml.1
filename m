Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbZLEPQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbZLEPQr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 10:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbZLEPQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 10:16:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877AbZLEPQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 10:16:45 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4B19A92A.5030804@analog.com>
References: <4B19A92A.5030804@analog.com> <1244854869-2563-1-git-send-email-vapier@gentoo.org> <14959.1259948697@redhat.com>
To: Jie Zhang <jie.zhang@analog.com>
Cc: dhowells@redhat.com, uClinux development list <uclinux-dev@uclinux.org>,
       linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
Subject: Re: [uClinux-dev] [PATCH/RFC] FDPIC: add hook for arches to customize program header parsing
Date: Sat, 05 Dec 2009 15:14:34 +0000
Message-ID: <643.1260026074@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jie Zhang <jie.zhang@analog.com> wrote:

> > There needs to be a mapping covering the SRAM region for the purposes of the
> 
> Our GDB is still lack of the feature to debug applications using SRAM. So this
> part of code was not got exercised. So if we remove this line, can this patch
> got merged?

No.  Firstly, the piece of storage that gets munmapped isn't used, so unmapping
it isn't wrong.  What you need to do is to put a mapping over the bit of the
SRAM you wish to use and then fill it and use it.  Ideally, you'd do this
inside of do_mmap_pgoff() - that way those bits of the SRAM can be shared, but
I'm not sure how best to do that.

But you need to stick a VMA over it so that various checks don't spit
EFAULT/EIO at you.

David
