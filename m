Return-Path: <linux-kernel-owner+w=401wt.eu-S965477AbXBRAr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965477AbXBRAr7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 19:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965485AbXBRAr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 19:47:59 -0500
Received: from thunk.org ([69.25.196.29]:46027 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965477AbXBRAr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 19:47:58 -0500
Date: Sat, 17 Feb 2007 17:59:08 -0500
From: Theodore Tso <tytso@mit.edu>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 07/44 take 2] [UBI] misc unit header
Message-ID: <20070217225908.GC16522@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165459.5845.18967.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217165459.5845.18967.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 06:54:59PM +0200, Artem Bityutskiy wrote:
> diff -auNrp tmp-from/drivers/mtd/ubi/misc.h tmp-to/drivers/mtd/ubi/misc.h
> --- tmp-from/drivers/mtd/ubi/misc.h	1970-01-01 02:00:00.000000000 +0200
> +++ tmp-to/drivers/mtd/ubi/misc.h	2007-02-17 18:07:26.000000000 +0200
> @@ -0,0 +1,146 @@
> +#define xquotise(s) #s
> +#define quotise(s) xquotise(s)

Nothing in your patch series uses this, and it's identical to
stringify().   Please remove?

> +/**
> + * rb_for_each_entry - walk an RB-tree.
> + *
> + * @rb: a pointer to type 'struct rb_node' to to use as a loop counter
> + * @pos: a pointer to RB-tree entry type to use as a loop counter
> + * @root: RB-tree's root
> + * @member: the name of the 'struct rb_node' within the RB-tree entry
> + */
> +#define rb_for_each_entry(rb, pos, root, member)...

Shouldn't this be added to include/linux/rbtree.h?

> +/**
> + * strdup_len - duplicate a string with known length.
> + *
> + * @str: original string
> + * @len: the length of the string
> + */
> +char *strdup_len(const char *str, int len);

I'm not sure this should be polluting the kernel symbol namespace,
especially since the implementation calls ubi_assert()....

It's not clear the assertion is all that useful, but if you must have
it, why not do the check as an inline (with the assertion normally
turned off), and then call out to kmemdup()?

						- Ted
