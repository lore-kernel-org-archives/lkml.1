Return-Path: <linux-kernel-owner+w=401wt.eu-S937478AbYEBXk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937478AbYEBXk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765132AbYEBXkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:40:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763477AbYEBXkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:40:13 -0400
Date: Fri, 2 May 2008 16:39:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [PATCH] Extend list debugging to cover hlists
Message-Id: <20080502163941.e2afd851.akpm@linux-foundation.org>
In-Reply-To: <20080502231727.GQ14976@parisc-linux.org>
References: <20080502182745.GL14976@parisc-linux.org>
	<20080502161403.fe596cca.akpm@linux-foundation.org>
	<20080502231727.GQ14976@parisc-linux.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008 17:17:27 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Fri, May 02, 2008 at 04:14:03PM -0700, Andrew Morton wrote:
> > linux-next is a better tree against which to prepare 2.6.x+1 patches.
> 
> Is there a reason to wait for 2.6.x+1?  People are having problems today
> with corrupt hlists.

dunno, really.  Merging it would bust git-sched and linux-next, which is of
course solveable, but a hassle.  If there are bugs in there then linux-next
and -mm testing will pick up some of them.  Mainline testing would pick up
more.  Is that delta worth it?  dunno, really.

Experience tells us that decent testing of new debug infrastructure
(especially that which goes BUG) before it goes mainline is a good idea.

<looks at the patch>

diff --git a/include/linux/list.h b/include/linux/list.h
> index 08cf4f6..a325d9f 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -714,10 +714,17 @@ static inline int hlist_empty(const struct hlist_head *h)
>  	return !h->first;
>  }
>  
> +#ifdef CONFIG_DEBUG_LIST
> +extern void hlist_check(struct hlist_node *n);
> +#else
> +#define hlist_check(n)		do { } while (0)

a static inline would be better.

- It matches the other version, which is aesthetically pleasing

- It provides type-checking when CONFIG_DEBUG_LIST=n


