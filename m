Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab0COMg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 08:36:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756734Ab0COMg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 08:36:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4B9B5A37.2010206@s5r6.in-berlin.de>
References: <4B9B5A37.2010206@s5r6.in-berlin.de> <4B9A6033.8010705@s5r6.in-berlin.de> <20100311172055.7328.51353.stgit@warthog.procyon.org.uk> <18180.1268437268@redhat.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       sgruszka@redhat.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Document Linux's circular buffering capabilities
Date: Mon, 15 Mar 2010 12:36:05 +0000
Message-ID: <30121.1268656565@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Would you agree to add a quick note that these examples are simple
> enough to not strictly require ACCESS_ONCE but are meant to show what
> more general code would have to do?  Else a reader might be left puzzled
> why he can't see in the example code the circumstances which require
> ACCESS_ONCE and may remain unsure about where to use it in his own works...

How about adding a bit:

 Note the use of ACCESS_ONCE() in both algorithms to read the opposition index.
 This prevents the compiler from discarding and reloading its cached value -
-which some compilers will do across smp_read_barrier_depends().
+which some compilers will do across smp_read_barrier_depends().  This isn't
+strictly needed if you can be sure that the opposition index will _only_ be
+used the once.

David
