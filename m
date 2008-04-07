Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbYDGN5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbYDGN5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 09:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757494AbYDGN4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 09:56:52 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:49665 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbYDGN4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 09:56:51 -0400
To: dwalker@mvista.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp,
       haradats@nttdata.co.jp
Subject: Re: [TOMOYO #7 02/30] Internal functions prototypes for SAKURA andTOMOYO.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20080404122242.867070732@I-love.SAKURA.ne.jp><20080404122357.420668479@I-love.SAKURA.ne.jp><1207322973.21308.52.camel@localhost.localdomain>
In-Reply-To: <1207322973.21308.52.camel@localhost.localdomain>
Message-Id: <200804072256.FCJ21869.MJFFOVQtFOHSOL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 7 Apr 2008 22:56:47 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> > +/**
> > + * list1_entry - get the struct for this entry
> > + * @ptr:        the &struct list1_head pointer.
> > + * @type:       the type of the struct this is embedded in.
> > + * @member:     the name of the list1_struct within the struct.
> > + */
> > +#define list1_entry(ptr, type, member) container_of(ptr, type,
> > member)
> > +
> > +/**
> > + * list1_for_each        -       iterate over a list
> > + * @pos:        the &struct list1_head to use as a loop cursor.
> > + * @head:       the head for your list.
> > + */
> > +#define list1_for_each(pos,
> > head)                                      \
> > +       for (pos = (head)->next; prefetch(pos->next), pos !=
> > (head);    \
> > +            pos = pos->next)
> > +
> 
> These should go into include/linux/list.h .. It looks like you are
> duplicate at least some of what is already in there..

I see. I'll move it on next posting.
Although people advised me to use standard doubly linked list,
TOMOYO wants to use singly linked list because the elements are append only.
If TOMOYO is allowed to use singly linked list, it can make the source code read lock free.

Thank you.
