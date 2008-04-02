Return-Path: <linux-kernel-owner+w=401wt.eu-S1760278AbYDBTsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278AbYDBTsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758089AbYDBTsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:48:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758064AbYDBTsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:48:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: posix-cpu-timers revamp
In-Reply-To: Frank Mayhar's message of  Wednesday, 2 April 2008 10:42:44 -0700 <1207158164.11976.32.camel@bobble.smo.corp.google.com>
References: <bug-9906-10286@http.bugzilla.kernel.org/>
	<20080206165045.89b809cc.akpm@linux-foundation.org>
	<1202345893.8525.33.camel@peace.smo.corp.google.com>
	<alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net>
	<20080207162203.3e3cf5ab@Varda>
	<alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net>
	<alpine.LRH.1.00.0802071054160.29320@mini.warudkars.net>
	<20080207165455.04ec490b@Varda>
	<alpine.LRH.1.00.0802071100230.29369@mini.warudkars.net>
	<alpine.LRH.1.00.0802071153130.15220@mini.warudkars.net>
	<1204314904.4850.23.camel@peace.smo.corp.google.com>
	<20080304070016.903E127010A@magilla.localdomain>
	<1204660376.9768.1.camel@bobble.smo.corp.google.com>
	<20080305040826.D0E6127010A@magilla.localdomain>
	<1204830243.20004.31.camel@bobble.smo.corp.google.com>
	<20080311075020.A93DB26F991@magilla.localdomain>
	<1205269507.23124.57.camel@bobble.smo.corp.google.com>
	<20080311213507.5BCDF26F991@magilla.localdomain>
	<1205455050.19551.16.camel@bobble.smo.corp.google.com>
	<20080321071846.1B22B26F9A7@magilla.localdomain>
	<1206122240.14638.31.camel@bobble.smo.corp.google.com>
	<20080322215829.D69D026F9A7@magilla.localdomain>
	<1206380079.21896.20.camel@bobble.smo.corp.google.com>
	<20080331054404.78CDB26F8E9@magilla.localdomain>
	<1206995072.14649.41.camel@bobble.smo.corp.google.com>
	<20080402020707.151E126F8DC@magilla.localdomain>
	<1207158164.11976.32.camel@bobble.smo.corp.google.com>
X-Shopping-List: (1) Epic dirt ants
   (2) Libelous ladder chasers
   (3) Convalescent deriders
   (4) Aristocratic bracelets
Message-Id: <20080402194836.4933026F98A@magilla.localdomain>
Date: Wed,  2 Apr 2008 12:48:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One quick note:  this inline isn't needed for the 2b solution (allocate
> percpu storage in copy_signal CLONE_THREAD case), since if there's more
> than one thread there'll always be a percpu area and if there's only one
> thread the summation code won't be entered.

That's true.  I still think it's a good idea to have it, even if it winds
up being empty in the variants we really use.  The principle is that the
new set of types/functions could be used to implement exactly what we have
now.  In fact, it's usually best to do a series of small patches that start
with introducing the abstraction while not changing anything.

> And another quick note:  It appears that with the "allocate percpu
> storage in copy_signal CLONE_THREAD case" mechanism, I don't need to
> worry about allocating it anywhere else.  If I need it (which is only in
> the case of multiple threads and an interval timer) then I'll have it
> because it was allocated with the second thread.  

That's correct.

> So I just eliminate the allocation in do_setitimer() entirely.

Again, I'd leave the call to the inline that would do it.
For this implementation plan, its body is:
	BUG_ON(!task->signal->cputime.totals && !thread_group_empty(task));


Thanks,
Roland
