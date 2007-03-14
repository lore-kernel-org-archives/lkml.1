Return-Path: <linux-kernel-owner+w=401wt.eu-S1750791AbXCNPab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750791AbXCNPab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750726AbXCNPaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:30:30 -0400
Received: from mail.screens.ru ([213.234.233.54]:46905 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbXCNPa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:30:28 -0400
Date: Wed, 14 Mar 2007 18:33:41 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelianov <xemul@sw.ru>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [RFC] kernel/pid.c pid allocation wierdness
Message-ID: <20070314153341.GA770@tv-sign.ru>
References: <45F7A4B3.5040005@sw.ru> <m16493rk18.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m16493rk18.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14, Eric W. Biederman wrote:
> Pavel Emelianov <xemul@sw.ru> writes:
> 
> > Hi.
> >
> > I'm looking at how alloc_pid() works and can't understand
> > one (simple/stupid) thing.
> >
> > It first kmem_cache_alloc()-s a strct pid, then calls
> > alloc_pidmap() and at the end it taks a global pidmap_lock()
> > to add new pid to hash.

We need some global lock. pidmap_lock is already here, and it is
only used to protect pidmap->page allocation. Iow, it is almost
unused. So it was very natural to re-use it while implementing
pidrefs.

> > The question is - why does alloc_pidmap() use at least
> > two atomic ops and potentially loop to find a zero bit
> > in pidmap? Why not call alloc_pidmap() under pidmap_lock
> > and find zero pid in pidmap w/o any loops and atomics?

Currently we search for zero bit lockless, why do you want
to do it under spin_lock ?

Oleg.

