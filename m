Return-Path: <linux-kernel-owner+w=401wt.eu-S932475AbXIOAWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475AbXIOAWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 20:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbXIOAV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 20:21:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53447 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518AbXIOAV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 20:21:56 -0400
Date: Fri, 14 Sep 2007 17:21:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: Matthew Helsley <matthltc@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] State limits to safety of _safe iterators
Message-Id: <20070914172151.818e32fe.akpm@linux-foundation.org>
In-Reply-To: <20070913152107.GC12806@linux.vnet.ibm.com>
References: <20070913010140.GA21306@linux.vnet.ibm.com>
	<1189675366.5518.12.camel@localhost.localdomain>
	<20070913152107.GC12806@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 08:21:07 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Thu, Sep 13, 2007 at 02:22:45AM -0700, Matthew Helsley wrote:
> > On Wed, 2007-09-12 at 18:01 -0700, Paul E. McKenney wrote:
> > > The _safe list iterators make a blanket statement about how they are
> > > safe against removal.  This patch, inspired by private conversations
> > > with people who unwisely but perhaps understandably took this blanket
> > > statement at its word, adds comments stating limits to this safety.
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > ---
> > > 
> > >  list.h |   42 ++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 42 insertions(+)
> > > 
> > > diff -urpNa -X dontdiff linux-2.6.22/include/linux/list.h linux-2.6.22-safedoc/include/linux/list.h
> > > --- linux-2.6.22/include/linux/list.h	2007-07-08 16:32:17.000000000 -0700
> > > +++ linux-2.6.22-safedoc/include/linux/list.h	2007-09-12 17:45:38.000000000 -0700
> > > @@ -472,6 +472,12 @@ static inline void list_splice_init_rcu(
> > >   * @pos:	the &struct list_head to use as a loop cursor.
> > >   * @n:		another &struct list_head to use as temporary storage
> > >   * @head:	the head for your list.
> > > + *
> > > + * Please note that this is safe only against removal by the code in
> > 
> > I'm not trying to be snarky but how far should we go before expecting
> > folks to read the macros? Depending on the answer you may also want to
> > mention that without additional additional code it's safe only against
> > removal of the list element at pos.
> 
> Good question.  In fact, I would have agreed with you before coming
> across people who in my experience are generally reasonably well clued
> in who were confused about this.
> 

hmm, yes, I must say, one would need to be fairly thick to expect a little
helper macro to protect you from activity on other CPUs.

