Return-Path: <linux-kernel-owner+w=401wt.eu-S1765049AbXHWUGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765049AbXHWUGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 16:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbXHWUGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 16:06:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568AbXHWUGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 16:06:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <e8b5ee6194ed619c245eb884c5ae6b11@kernel.crashing.org>
References: <e8b5ee6194ed619c245eb884c5ae6b11@kernel.crashing.org> <46C03885.7000109@redhat.com> <20070813112452.GK24018@shell.boston.redhat.com> <swfhcmswcux.wl%takata.hirokazu@renesas.com> <swfejhww4cs.wl%takata.hirokazu@renesas.com> <46CC42EF.3030602@redhat.com> <8fc86c23579e12b012891d6e69b1b107@kernel.crashing.org> <alpine.LFD.0.999.0708221116310.30176@woody.linux-foundation.org> 
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Hirokazu Takata <takata@linux-m32r.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, "Luck, Tony" <tony.luck@intel.com>,
       akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       Chris Snook <csnook@redhat.com>, Chris Friesen <cfriesen@nortel.com>
Subject: Re: [PATCH 11/23] make atomic_read() and atomic_set() behavior consistent on m32r
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Thu, 23 Aug 2007 21:05:40 +0100
Message-ID: <14578.1187899540@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool <segher@kernel.crashing.org> wrote:

> This simply isn't true.  The compiler *can* combine asm stuff:
> 
> 
> typedef struct { int counter; } atomic_t;
> 
> static inline __attribute__((pure)) int atomic_read(const atomic_t *v)
> {
>         int x;
>         asm("ld %0,@%1" : "=r"(x) : "r"(&v->counter), "m"(v->counter));
>         return x;
> }

That's not precisely combining asm stuff.  The compiler is ditching a whole
function because you've told it it can cache the result.

David
