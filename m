Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbYGIUFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbYGIUFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbYGIUFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:05:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:46740 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbYGIUFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:05:03 -0400
Date: Wed, 9 Jul 2008 13:05:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Bruno Santos <bsantos@av.it.pt>
Cc: linux-kernel@vger.kernel.org
Subject: Re: semaphore: lockless fastpath using atomic_{inc,dec}_return
Message-ID: <20080709130504.728f37d8@infradead.org>
In-Reply-To: <4874EDB5.7030007@av.it.pt>
References: <4874DBBF.1000907@av.it.pt>
	<20080709085018.3a76d1e0@infradead.org>
	<4874EDB5.7030007@av.it.pt>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >   
>  From your words if we do:
> 
> spin_lock()
> val = --foo;
> spin_unlock();
> 
> Has the same cost than:
> 
> val = atomic_dec_return(&foo);

yes


> How come I have the same number of atomic ops?
> 
> Let's consider the fast case scenario (semaphore is unlocked for the 
> 'down' and has no waiters for 'up') in x86:
> - with the spinlock only approach we have 2 atomic ops, xadd for
> lock, inc for unlock. The unlock doesn't come for free in x86 after
> all.

the unlock does not use an atomic operation.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
