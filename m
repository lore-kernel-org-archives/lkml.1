Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbYFLFZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbYFLFZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 01:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYFLFZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 01:25:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45595 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbYFLFZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 01:25:31 -0400
Subject: Re: [PATCH 3/5] mutex debug: add generic blocked_on usage
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20080611204917.267412694@mvista.com>
References: <20080611204916.271608740@mvista.com>
	 <20080611204917.267412694@mvista.com>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 07:25:27 +0200
Message-Id: <1213248327.31518.77.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-11 at 13:49 -0700, Daniel Walker wrote:
> plain text document attachment (blocked_on-mutex.patch)

> -#ifdef CONFIG_DEBUG_MUTEXES
> -	/* mutex deadlock detection */
> -	struct mutex_waiter *blocked_on;
> -#endif
> +	/*
> +	 * Deadlock detection and priority inheritance handling,
> +	 * and any other out of line mutex operations
> +	 */
> +	struct lock_waiter_state *blocked_on;

Now you grew task_struct unconditionally, how about

#if defined CONFIG_DEBUG_MUTEX || defined CONFIG_RT_MUTEXES || defined CONFIG_FUTEX

?

