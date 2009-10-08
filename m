Return-Path: <linux-kernel-owner+w=401wt.eu-S1759975AbZJHWaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975AbZJHWaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 18:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbZJHWaC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 18:30:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:46137 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbZJHWaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 18:30:00 -0400
Subject: Re: [RFC][PATCH] kmap_atomic_push
From: Peter Zijlstra <peterz@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
In-Reply-To: <13417.1255039961@redhat.com>
References: <1255016123.17055.17.camel@laptop> <13417.1255039961@redhat.com>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 00:29:02 +0200
Message-Id: <1255040942.17055.21.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 23:12 +0100, David Howells wrote:
> Do we have any code that uses two slots and then calls more code that
> ultimately requires further slots?  In other words, do we need more than two
> slots?

I can think of code that does a lot more than that, suppose you have
both KM_USER[01], get an interrupt that takes KM_IRQ[01], take an NMI
that takes KM_NMI.

Maybe we can stack the SOFTIRQ ones in as well ;-)

