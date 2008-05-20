Return-Path: <linux-kernel-owner+w=401wt.eu-S933819AbYETQQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819AbYETQQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759588AbYETQQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:16:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56475 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbYETQQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:16:28 -0400
Date: Tue, 20 May 2008 09:15:44 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make
Message-ID: <20080520091544.464dc19c@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0805200752580.32253@woody.linux-foundation.org>
References: <20080502182745.GL14976@parisc-linux.org>
	<20080501133209.2c04dad0@infradead.org>
	<20080502184922.GM14976@parisc-linux.org>
	<20080520032448.GA19348@redhat.com>
	<20080520071458.707d6e90@infradead.org>
	<20080520142727.GC4843@redhat.com>
	<alpine.LFD.1.10.0805200752580.32253@woody.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 07:54:10 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 20 May 2008, Dave Jones wrote:
> > 
> > Like this ?  (I don't have a -mm handy, so guessed based on
> > mm-commits mail, patch uncompiled, but should dtrt if I understood
> > your diff correctly)
> > 
> > diff --git a/lib/list_debug.c b/lib/list_debug.c
> > index 4350ba9..d8dee53 100644
> > --- a/lib/list_debug.c
> > +++ b/lib/list_debug.c
> > @@ -21,16 +21,14 @@ void __list_add(struct list_head *new,
> >  			      struct list_head *next)
> >  {
> >  	if (unlikely(next->prev != prev)) {
> > -		printk(KERN_ERR "list_add corruption. next->prev
> > should be "
> > +		WARN(1, "list_add corruption. next->prev should be
> > " "prev (%p), but was %p. (next=%p).\n",
> >  			prev, next->prev, next);
> > -		BUG();
> >  	}
> 
> I think Arjan meant like
> 
> 	WARN(next->prev != prev,
> 		"list_add corruption. next->prev should be "
> 		"prev (%p), but was %p. (next=%p).\n",
> 		prev, next->prev, next);
> 
> without any "if()" statement at all.

Dave...what Linus said ;)


would be nice to get WARN() into mainline soon... ;)
