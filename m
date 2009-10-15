Return-Path: <linux-kernel-owner+w=401wt.eu-S1763352AbZJOXp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763352AbZJOXp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 19:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763339AbZJOXp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 19:45:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758818AbZJOXp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 19:45:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1255359207.10420.31.camel@twins>
References: <1255359207.10420.31.camel@twins> <4AD0A0F7.9070700@clamav.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: dhowells@redhat.com, =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwin@clamav.net>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, aCaB <acab@clamav.net>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Mutex vs semaphores scheduler bug
Date: Fri, 16 Oct 2009 00:44:26 +0100
Message-ID: <24718.1255650266@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:

> The problem appears to be that rwsem doesn't allow lock-stealing

With good reason.  rwsems can be read or write locked for a long time - so if
readers can jump the queue on read-locked rwsems, then writer starvation is a
real possibility.  I carefully implemented it so that it is a strict FIFO to
avoid certain problems I was having.

David
