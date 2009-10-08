Return-Path: <linux-kernel-owner+w=401wt.eu-S933134AbZJHXAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134AbZJHXAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 19:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932819AbZJHXAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 19:00:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932635AbZJHXAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 19:00:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1255040942.17055.21.camel@laptop>
References: <1255040942.17055.21.camel@laptop> <1255016123.17055.17.camel@laptop> <13417.1255039961@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [RFC][PATCH] kmap_atomic_push
Date: Thu, 08 Oct 2009 23:58:30 +0100
Message-ID: <13794.1255042710@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:

> I can think of code that does a lot more than that, suppose you have
> both KM_USER[01], get an interrupt that takes KM_IRQ[01], take an NMI
> that takes KM_NMI.

But whilst the interrupt might want to use two slots, it's probably a bug for
it to want to access the mappings set up by whatever called KM_USER[01] - so
it can probably reuse those slots, provided it puts them back again.

Similarly for NMI taking KM_NMI - it probably shouldn't be attempting to
access the mappings set up by the normal mode or the interrupt mode - in which
case, why can't it reuse those slots?

> Maybe we can stack the SOFTIRQ ones in as well ;-)

Ditto.

David
