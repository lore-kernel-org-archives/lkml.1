Return-Path: <linux-kernel-owner+w=401wt.eu-S1762159AbYDBSnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762159AbYDBSnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761591AbYDBSnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:43:16 -0400
Received: from smtp-out.google.com ([216.239.33.17]:37578 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760508AbYDBSnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:43:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=tz4NJ3MReU1E44h0g9GmpYUoQlPM0SlGvkWbGsdkSv6f2IV0TTKeWsDVg9X6IKDJ7
	9cvHTO86cvzb886QUVQ7A==
Subject: Re: posix-cpu-timers revamp
From: Frank Mayhar <fmayhar@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080402020707.151E126F8DC@magilla.localdomain>
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
Content-Type: text/plain
Organization: Google, Inc.
Date: Wed, 02 Apr 2008 11:42:40 -0700
Message-Id: <1207161760.11976.37.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-01 at 19:07 -0700, Roland McGrath wrote:
> > To deal with the need for bookkeeping with multiple threads in the SMP
> > case (where there isn't a per-cpu structure until it's needed), I'll
> > allocate the per-cpu structure in __exit_signal() where the relevant
> > fields are updated.  I'll also allocate it where I do now, in
> > do_setitimer(), when needed.  The allocation will be a "return 0" for UP
> > and a call to "thread_group_times_alloc_smp()" (which lives in sched.c)
> > for SMP.
> 
> By do_setitimer, you mean set_process_cpu_timer and posix_cpu_timer_set.

And another quick note:  It appears that with the "allocate percpu
storage in copy_signal CLONE_THREAD case" mechanism, I don't need to
worry about allocating it anywhere else.  If I need it (which is only in
the case of multiple threads and an interval timer) then I'll have it
because it was allocated with the second thread.  So I just eliminate
the allocation in do_setitimer() entirely.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

