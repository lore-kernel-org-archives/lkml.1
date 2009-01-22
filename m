Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbZAVU37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbZAVU37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 15:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZAVU3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 15:29:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:50360 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZAVU3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 15:29:50 -0500
Subject: Re: [RFC PATCH 01/19] lockdep: annotate reclaim context
 (__GFP_NOFS)
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1232653234.4890.135.camel@laptop>
References: <20090122173701.674448070@chello.nl>
	 <20090122174052.061744802@chello.nl>  <1232653234.4890.135.camel@laptop>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 21:29:47 +0100
Message-Id: <1232656187.4890.136.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-22 at 20:40 +0100, Peter Zijlstra wrote:
> > +               return;
> > +       if (DEBUG_LOCKS_WARN_ON(irqs_disabled()))
> > +               return;
> > +
> > +       mark_held_locks(curr, RECLAIM_FS);
> > +}
> 
> Not quite seeing how this happens though...
> 
> [    6.998258] WARNING: at /usr/src/linux-2.6/kernel/lockdep.c:2266
> lockdep_trace_alloc+0x58/0x69() 

Doh, its getting there without __GFP_WAIT...



