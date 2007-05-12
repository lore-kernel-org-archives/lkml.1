Return-Path: <linux-kernel-owner+w=401wt.eu-S1762289AbXELBS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762289AbXELBS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 21:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759520AbXELBSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 21:18:20 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755433AbXELBSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 21:18:20 -0400
Date: Fri, 11 May 2007 18:17:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>, rlove@rlove.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: 2.6.21-mm2: HDAPS? BUG: at kernel/mutex.c:311
Message-Id: <20070511181756.fa3762a1.akpm@linux-foundation.org>
In-Reply-To: <20070511175335.092aa0af.akpm@linux-foundation.org>
References: <20070512002115.GZ11166@waste.org>
	<20070511175335.092aa0af.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 17:53:35 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> And indeed that's buggy - the non-debug version of spin_lock_mutex() is not
> irq-safe.
> 
> I'd say that's pretty dumb of the mutex interface, really.  Doing a
> mutex_trylock() should be OK from all contexts.

We can fix this in a low-impact fashion by making mutex_trylock() do a
spin_trylock() on mutex->wait_lock, no?

