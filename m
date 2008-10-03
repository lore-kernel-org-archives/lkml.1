Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbYJCTPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbYJCTPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 15:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbYJCTPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 15:15:37 -0400
Received: from relais.videotron.ca ([24.201.245.36]:24329 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbYJCTPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 15:15:36 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 03 Oct 2008 15:15:24 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: David Howells <dhowells@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-am33-list@redhat.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] MN10300: Move asm-arm/cnt32_to_63.h to include/linux/
In-reply-to: <1703.1222986215@redhat.com>
Message-id: <alpine.LFD.2.00.0810031512420.3045@xanadu.home>
References: <alpine.LFD.2.00.0810011110440.3635@xanadu.home>
 <alpine.LFD.2.00.0809282123100.3635@xanadu.home>
 <20080924164826.14867.63020.stgit@warthog.procyon.org.uk>
 <1222426580.16700.258.camel@lappy.programming.kicks-ass.net>
 <alpine.LFD.2.00.0809260802310.3635@xanadu.home>
 <1222431635.16700.278.camel@lappy.programming.kicks-ass.net>
 <29968.1222871650@redhat.com> <1703.1222986215@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008, David Howells wrote:

> Nicolas Pitre <nico@cam.org> wrote:
> 
> > Oh, that's a possibility.  In that case __m_cnt_hi will be reverted to a 
> > previous state just like if cnt32_to_63() has not been called yet since 
> > the new half period.  And a subsequent call will fix that again.
> 
> Surely that's not good enough.  There's a 50% chance that reversion to a
> previous state will result in an extra increment of the __m_cnt_hi on the next
> call.

If so then you're using this interface in an inappropriate way.

The _absolute_ minimum frequency with which this should be fully 
executed is once per half period of the base counter.  I hope that in 
practice it happens far more often than that.


Nicolas
