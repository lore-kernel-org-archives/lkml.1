Return-Path: <linux-kernel-owner+w=401wt.eu-S1761641AbYFLNVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761641AbYFLNVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759633AbYFLNVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:21:35 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:59470 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbYFLNVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:21:34 -0400
Subject: Re: [PATCH 3/5] mutex debug: add generic blocked_on usage
From: Daniel Walker <dwalker@mvista.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1213248327.31518.77.camel@twins>
References: <20080611204916.271608740@mvista.com>
	 <20080611204917.267412694@mvista.com>  <1213248327.31518.77.camel@twins>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 06:21:31 -0700
Message-Id: <1213276891.16459.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-12 at 07:25 +0200, Peter Zijlstra wrote:
> On Wed, 2008-06-11 at 13:49 -0700, Daniel Walker wrote:
> > plain text document attachment (blocked_on-mutex.patch)
> 
> > -#ifdef CONFIG_DEBUG_MUTEXES
> > -	/* mutex deadlock detection */
> > -	struct mutex_waiter *blocked_on;
> > -#endif
> > +	/*
> > +	 * Deadlock detection and priority inheritance handling,
> > +	 * and any other out of line mutex operations
> > +	 */
> > +	struct lock_waiter_state *blocked_on;
> 
> Now you grew task_struct unconditionally, how about
> 
> #if defined CONFIG_DEBUG_MUTEX || defined CONFIG_RT_MUTEXES || defined CONFIG_FUTEX
> 
> ?

Ok .. I didn't add it cause I wasn't convinced RT_MUTEXES was
optional .. There's a lot of PI futex related code that isn't ifdef'd
either..

Daniel

