Return-Path: <linux-kernel-owner+w=401wt.eu-S935921AbYEBScw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935921AbYEBScw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932429AbYEBSck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:32:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42168 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765907AbYEBScj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:32:39 -0400
Date: Thu, 1 May 2008 13:32:09 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Extend list debugging to cover hlists
Message-ID: <20080501133209.2c04dad0@infradead.org>
In-Reply-To: <20080502182745.GL14976@parisc-linux.org>
References: <20080502182745.GL14976@parisc-linux.org>
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

On Fri, 2 May 2008 12:27:46 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> +void hlist_check(struct hlist_node *n)
> +{
> +	if (unlikely(*n->pprev != n)) {
> +		printk(KERN_ERR "hlist corruption. *pprev should be
> %p, "
> +				"but was %p\n", n, *n->pprev);
> +		BUG();
> +	}
> +	if (unlikely(n->next != NULL && n->next->pprev != &n->next))
> {
> +		printk(KERN_ERR "hlist corruption. n->next->pprev
> should be"
> +				"%p, but was %p\n", &n->next,
> n->next->pprev);
> +		BUG();
> +	}
> +}
> +EXPORT_SYMBOL(hlist_check);
> 


Hi,
I like the concept of the patch; however...
BUG() is a tad on the rude side... how about WARN_ON(1) ?
