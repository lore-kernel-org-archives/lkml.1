Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbXFJRNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbXFJRNQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 13:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbXFJRNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 13:13:00 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:23266 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbXFJRNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 13:13:00 -0400
Date: Sun, 10 Jun 2007 10:13:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] struct list_node
Message-Id: <20070610101314.cd63dec2.randy.dunlap@oracle.com>
In-Reply-To: <1181452290.16428.7.camel@localhost.localdomain>
References: <1181452290.16428.7.camel@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2007 15:11:30 +1000 Rusty Russell wrote:

> The current list.h has the same type for list elements and list heads
> even though most code and coders treat them as distinct.
> 
> I've had a version of list.h (for userspace work) for about a year
> which uses a different type for nodes and it works very well: code is
> clearer, and mistakes like list_add() argument reversal are detected.
> Code which really wants to treat a list node as a head can append ".h".
> 
> To avoid a massive flag day, this patch uses gcc's "cast to union" to
> allow either list_head or list_node in various places.
> 
> Notes:
> 1) A new function in_list() is introduced, equivalent to "list_empty(&e)"
>    but for nodes.

in_list() sounds like it would scan an entire list and return true
if &e is found, false if &e is not found...

and that's what the short description sounds like to me as well...

I'm just confuzed.  And you aren't supposed to write confuzing
interfaces.  :)

> +/**
> + * in_list - tests whether element is in a list.
> + * @entry: the entry to test
> + *
> + * Returns false if the list elem was deleted from list (except __list_del)

What is "elem"?  How can this function determine is a list element was
deleted vs. was never added?

> + */
> +static inline int in_list(const struct list_node *entry)
> +{
> +	return entry->h.next == &entry->h;
>  }


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
