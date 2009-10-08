Return-Path: <linux-kernel-owner+w=401wt.eu-S1757748AbZJHWmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748AbZJHWmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 18:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbZJHWmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 18:42:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:57742 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbZJHWmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 18:42:46 -0400
Subject: Re: [RFC][PATCH] kmap_atomic_push
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       David Howells <dhowells@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>, jim owens <jowens@hp.com>,
       David Howells <dhowells@redhat.com>
In-Reply-To: <1255016123.17055.17.camel@laptop>
References: <1255016123.17055.17.camel@laptop>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 00:42:00 +0200
Message-Id: <1255041720.17055.30.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just to make it clear, the stack design gets rid of crap like:

-#define __KM_PTE                       \
-       (in_nmi() ? KM_NMI_PTE :        \
-        in_irq() ? KM_IRQ_PTE :        \
-        KM_PTE0)

and

-static inline enum km_type crypto_kmap_type(int out)
-{
-       enum km_type type;
-
-       if (in_softirq())
-               type = out * (KM_SOFTIRQ1 - KM_SOFTIRQ0) + KM_SOFTIRQ0;
-       else
-               type = out * (KM_USER1 - KM_USER0) + KM_USER0;
-
-       return type;
-}



