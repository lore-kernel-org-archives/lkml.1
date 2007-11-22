Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbXKVTBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbXKVTBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 14:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbXKVTB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 14:01:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbXKVTB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 14:01:26 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071122153359.GA7268@elte.hu>
References: <20071122153359.GA7268@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [build bug] ./net/rxrpc/ar-key.c fails to build
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 22 Nov 2007 19:01:05 +0000
Message-ID: <29413.1195758065@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> on the latest kernel (2.6.24-rc3-git1) the attached config triggers the 
> following build error:
> 
> net/built-in.o: In function `rxrpc_destroy_s':
> ar-key.c:(.text+0x9c50d): undefined reference to `crypto_free_tfm'
> net/built-in.o: In function `rxrpc_instantiate_s':
> ar-key.c:(.text+0x9c613): undefined reference to `crypto_alloc_base'

I see it.  The simplest answer is just to make AF_RXRPC select CRYPTO.
However, that's probably not the right solution in the long run (the common
secret key management code assumes stuff about the key payload and the crypto
algorithms used that it shouldn't).

David
