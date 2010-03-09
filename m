Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab0CIHJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 02:09:15 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:40124 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab0CIHJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 02:09:12 -0500
Date: Tue, 9 Mar 2010 08:09:21 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, sivanich@sgi.com, torvalds@linux-foundation.org,
       mingo@elte.hu, peterz@infradead.org, dipankar@in.ibm.com,
       josh@freedesktop.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 2/4] stop_machine: reimplement using cpuhog
Message-ID: <20100309070921.GA2360@osiris.boeblingen.de.ibm.com>
References: <1268063603-7425-1-git-send-email-tj@kernel.org>
 <1268063603-7425-3-git-send-email-tj@kernel.org>
 <20100308171020.GC2557@osiris.boeblingen.de.ibm.com>
 <20100308182708.GA8504@redhat.com>
 <20100308193737.GA2466@osiris.boeblingen.de.ibm.com>
 <4B958ABC.3010401@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B958ABC.3010401@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 08:39:40AM +0900, Tejun Heo wrote:
> Hello,
> 
> On 03/09/2010 04:37 AM, Heiko Carstens wrote:
> >> How cpuhog can make a difference? Afaics, we shouldn't pass a
> >> blocking callback to hog_cpus/hog_one_cpu.
> > 
> > Well, it might me true that this shouldn't be done. But I don't see
> > a reason why in general it wouldn't work to pass a function that
> > would block.  So it's just a matter of time until somebody uses it
> > for such a purpose.  For the current stop_machine implementation it
> > would be broken to pass a blocking function (preemption disabled,
> > interrupts disabled).
> 
> Well, all current users don't block and it definitely can be enforced
> by turning off preemption around the callback.  stop_machine() uses
> busy waiting for every state transition so something else blocking on
> a cpu could waste a lot of cpu cycles on other cpus even if the wait
> is guaranteed to be finite.  Would that sooth your concern?

Yes, enforcing non blocking functions would be good.

Thanks!
