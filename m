Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZERLa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZERLa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 07:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbZERLaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 07:30:08 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:41083 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZERLaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 07:30:06 -0400
Date: Mon, 18 May 2009 13:29:08 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ming Lei <tom.leiming@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/async.c:introduce async_schedule*_atomic
Message-ID: <20090518132908.3cf40630@gondolin>
In-Reply-To: <20090517135940.42cb30a0@infradead.org>
References: <1242141222-8454-1-git-send-email-tom.leiming@gmail.com>
	<20090512154456.GC6255@nowhere>
	<20090512160434.GD6255@nowhere>
	<20090512183105.09e628f0@gondolin>
	<20090512165227.GE6255@nowhere>
	<20090512191848.25764af6@gondolin>
	<d82e647a0905121728m278b604bn9a0f5122b964978a@mail.gmail.com>
	<20090513012011.GA32518@nowhere>
	<20090513094728.59d10898@gondolin>
	<20090517135940.42cb30a0@infradead.org>
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

On Sun, 17 May 2009 13:59:40 -0700,
Arjan van de Ven <arjan@infradead.org> wrote:

> On Wed, 13 May 2009 09:47:28 +0200
> Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> 
> > On Wed, 13 May 2009 03:20:13 +0200,
> > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > On Wed, May 13, 2009 at 08:28:15AM +0800, Ming Lei wrote:
> > 
> > > > Also we still allow async_schedule*()  to run a job synchronously
> > > > if out of memory
> > > > or other failure. This can keep consistency with before.
> > > 
> > > 
> > > Yes, but also most of the current users of async_schedule() could
> > > call it with GFP_KERNEL. For now it's not an issue because it is
> > > not widely used, but who knows how that will evolve...
> > 
> > Well, if we want to change the interface, now would be a good time
> > since there are still few callers.
> 
> I would prefer it that if we make a more complex interface, we keep the
> current simple interface as a wrapper, so that the simple case can
> remain simple.

Of course. I was just thinking about changing the semantics of
async_schedule() to doing GFP_KERNEL allocation - now it's still easy
to audit all callers.
