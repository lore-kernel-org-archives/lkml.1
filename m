Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbZANKZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbZANKZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbZANKY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:24:56 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:38957 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbZANKYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:24:54 -0500
Date: Wed, 14 Jan 2009 11:24:50 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] async: Add some documentation.
Message-ID: <20090114112450.1a1af271@gondolin>
In-Reply-To: <20090114024952.GS8071@disturbed>
References: <20090113174306.0f620476@gondolin>
	<20090114024952.GS8071@disturbed>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 13:49:52 +1100,
Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Jan 13, 2009 at 05:43:06PM +0100, Cornelia Huck wrote:
> > Add some kerneldoc to the async interface.
> > 
> > Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> > +/**
> > + * async_schedule_special - schedule a function for asynchronous execution with a special running queue
> > + * @ptr: function to execute asynchronously
> > + * @data: data pointer to pass to the function
> > + * @running: list head to add to while running
> > + *
> > + * Returns an async_cookie_t that may be used for checkpointing later.
> > + * @running may be used in the async_synchronize_*_special() functions
> > + * to wait on a special running queue rather than on the global running
> > + * queue.
> > + * Note: This function may be called from atomic or non-atomic contexts.
> > + */
> >  async_cookie_t async_schedule_special(async_func_ptr *ptr, void *data, struct list_head *running)
> 
> Rather than polishing a turd, can we rename this "special" stuff to
> something more descriptive? I'm not the only person to complain
> about this. How about async_schedule_list()?
> 
> After all, async_schedule_list() describes *exactly* how it is
> different to async_schedule(), while the "_special" keywords really
> suck when you consider code is supposed to be self documenting....

async_schedule_list() sounds better, agreed, but I'd prefer to change
that in a seperate patch.
