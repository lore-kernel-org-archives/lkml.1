Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbZDNHpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbZDNHpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbZDNHpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:45:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33549 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbZDNHpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:45:45 -0400
Subject: Re: [PATCH] tracing/lockdep: turn lock->name into an array
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090413224219.GK5977@nowhere>
References: <1239662166-13208-1-git-send-email-fweisbec@gmail.com>
	 <20090413224219.GK5977@nowhere>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Apr 2009 09:48:15 +0200
Message-Id: <1239695296.21985.6725.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 00:42 +0200, Frederic Weisbecker wrote:
> > +#define LOCK_NAME_SIZE       25
> 
> 
> 
> This constant may look a bit weird.
> I just started with the assumption that a full lock name
> will rarely exceed this length.
> 
> If you agree with it, I will expand the conversion of lockdep
> TRACE_FORMAT to TRACE_EVENTS with the same assumption.
> So that we will be able to use filters with locks events.

I really really hate this.

if you pick a size on the top end so that all lock->name's fit in,
you're wasting heaps of space, if you pick a median length, everything
will get truncated.

If you're going to do a copy, just do the print into the buffer by using
_FORMAT and be done with it.
