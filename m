Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbXFYHKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbXFYHKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 03:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbXFYHJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 03:09:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbXFYHJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 03:09:54 -0400
Date: Mon, 25 Jun 2007 03:09:38 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Matt Mackall <mpm@selenic.com>, Alexander Gabert <pappy@gentoo.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       libc-alpha@sourceware.org, hardened@gentoo.org
Subject: Re: [PATCH] get_random_long() and AT_ENTROPY for auxv, kernel 2.6.21.5
Message-ID: <20070625070938.GN7012@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <4675C678.3080807@gentoo.org> <1182128803.22999.9.camel@laptopd505.fenrus.org> <20070620203022.GO11166@waste.org> <467EADA0.9020101@gentoo.org> <20070625034508.GE11115@waste.org> <1182746583.26621.5.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182746583.26621.5.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 09:43:03PM -0700, Arjan van de Ven wrote:
> > - something to do with aux vector headers
> 
> the primary goal is to pass a random value to userspace at process
> start; this to save glibc from having to open /dev/urandom on ever
> program start (which it does now for all apps compiled with
> -fstack-protector, which in various distros is "everything").

There are 2 ways to compile -fstack-protector supporting glibc actually,
only one opens /dev/urandom on every program initialization, the other
computes the stack guard from some bits of the stack address (so indirectly
depends on get_random_int() in stack randomization).
Nevertheless, having one random long (32-bit for 32-bit arches, 64-bit
otherwise) in aux vector would be useful.

	Jakub
