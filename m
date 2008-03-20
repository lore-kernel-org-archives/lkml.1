Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbYCTWkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbYCTWkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759238AbYCTWj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:39:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758967AbYCTWjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:39:54 -0400
Date: Thu, 20 Mar 2008 15:39:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: dwmw2@infradead.org, greg@kroah.com, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       linux-mtd@vger.kernel.org
Subject: Re: [PATCH] 1/2 Maple: Update bus driver to allow support of VMU
 device
Message-Id: <20080320153944.75b6edc1.akpm@linux-foundation.org>
In-Reply-To: <1206051797.6274.17.camel@localhost.localdomain>
References: <1205879413.6250.13.camel@localhost.localdomain>
	<1205880554.6250.25.camel@localhost.localdomain>
	<20080320135618.1a283b3e.akpm@linux-foundation.org>
	<1206051797.6274.17.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008 22:23:17 +0000
Adrian McMenamin <adrian@newgolddream.dyndns.info> wrote:

> 
> > urgh, down_trylock().  And a secret, undocumented one too.
> > 
> > A trylock is always an exceptional thing.  How is *any* reader of this code
> > supposed to work out what the heck it's doing there?  Convert it into
> > down(), run the code and decrypt the lockdep warnings, I suspect.
> > 
> > <looks>
> > 
> > Nope, I can't see any other lock being held when we call this function.
> > 
> > The trylocks are an utter mystery to me.  Please don't write mysterious
> > code.
> > 
> 
> OK, I am sure this is my problem but I have no idea why you are
> describing down_trylock as undocumented

I'm describing your use of it!  I'm sitting here trying to work out why on
earth this code is using the highly unusual (and highly suspicious) trylock
idiom and this is far from clear.

And I assume that if I can't work out why code is doing unusual-looking
things, then other readers will not be able to do so either.  Hence for
maintainability, that code of yours needs documenting.  I think.

Now it's true that I am unfamilar witht he arcanery of the maple driver and
the interfaces which it calls into.  But an experienced kernel developer
should be able to pick up a piece of code and have a decent shot at
understanding it.  And being able to review it...

