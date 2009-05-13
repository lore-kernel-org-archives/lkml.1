Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbZEMHrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbZEMHrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 03:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZEMHrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 03:47:33 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:55272 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZEMHrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 03:47:32 -0400
Date: Wed, 13 May 2009 09:47:28 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ming Lei <tom.leiming@gmail.com>, arjan@infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/async.c:introduce async_schedule*_atomic
Message-ID: <20090513094728.59d10898@gondolin>
In-Reply-To: <20090513012011.GA32518@nowhere>
References: <1242141222-8454-1-git-send-email-tom.leiming@gmail.com>
	<20090512154456.GC6255@nowhere>
	<20090512160434.GD6255@nowhere>
	<20090512183105.09e628f0@gondolin>
	<20090512165227.GE6255@nowhere>
	<20090512191848.25764af6@gondolin>
	<d82e647a0905121728m278b604bn9a0f5122b964978a@mail.gmail.com>
	<20090513012011.GA32518@nowhere>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 03:20:13 +0200,
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, May 13, 2009 at 08:28:15AM +0800, Ming Lei wrote:

> > Also we still allow async_schedule*()  to run a job synchronously if
> > out of memory
> > or other failure. This can keep consistency with before.
> 
> 
> Yes, but also most of the current users of async_schedule() could call
> it with GFP_KERNEL. For now it's not an issue because it is not widely
> used, but who knows how that will evolve...

Well, if we want to change the interface, now would be a good time
since there are still few callers.

> 
> 
> > Any sugesstions or objections?
> 
> 
> I have shared feelings. I don't know if the dual sense of
> this new helper deserves enough disambiguation and granularity
> to be split up in two parts:
> 
> - adding an async_schedule_nosync() helper
> - add a new gfpflag_t parameter
> 
> 
> Or should we just do:
> 
> - adding async_schedule_inatomic() which is a merge of nosync + GFP_ATOMIC
> - use GFP_KERNEL in async_schedule()
> 
> 
> It depends on the future users. Will someone ever accept to schedule a job
> that could end up running synchronously in the worst case?

The current callers all look simple enough, it may be that all other
cases besides inatomic+nosync would be overkill (and a too complex api
may lead to confusion).

Do people have candidates for conversion to the async api in mind that
would need one of the complex atomic/sync or non-atomic/non-sync
versions? If no, maybe we should just use the second approach and make
sure that the semantics are well documented.
