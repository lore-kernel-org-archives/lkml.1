Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbZELQbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbZELQbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbZELQbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:31:09 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:46239 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZELQbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:31:08 -0400
Date: Tue, 12 May 2009 18:31:05 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: tom.leiming@gmail.com, arjan@infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/async.c:introduce async_schedule*_atomic
Message-ID: <20090512183105.09e628f0@gondolin>
In-Reply-To: <20090512160434.GD6255@nowhere>
References: <1242141222-8454-1-git-send-email-tom.leiming@gmail.com>
	<20090512154456.GC6255@nowhere>
	<20090512160434.GD6255@nowhere>
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

On Tue, 12 May 2009 18:04:35 +0200,
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, May 12, 2009 at 05:44:58PM +0200, Frederic Weisbecker wrote:
> > On Tue, May 12, 2009 at 11:13:42PM +0800, tom.leiming@gmail.com wrote:
> > >   * Returns an async_cookie_t that may be used for checkpointing later.
> > > - * Note: This function may be called from atomic or non-atomic contexts.
> > > + * Note:This function may be called from non-atomic contexts,and not
> > > + * 	called from atomic contexts with safety. Please use
> > > + * 	async_schedule_atomic in atomic contexts.
> 
> 
> I suggest to add a comment which explains the reason for which it is unsafe
> to call it in atomic context: because the scheduled work might be synchronously
> executed.
> 
> One could believe this is because async_schedule() internally uses
> a function which might sleep whereas the actual problem may come
> from the scheduled function.

I'm wondering whether this is not mixing two different things up:
- Making async_schedule_* safe from an atomic context.
- Disallowing calling the function synchronously if asynchronous
  scheduling failed.

Perhaps we want async_schedule_nosync() in addition?

> 
> BTW, now that we have an atomic safe version, may be we could
> also adapt the kmalloc GFP flags subsequently?

Yes, that would make sense.
