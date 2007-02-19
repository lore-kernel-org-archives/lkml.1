Return-Path: <linux-kernel-owner+w=401wt.eu-S932074AbXBSLAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbXBSLAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932073AbXBSLAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:00:24 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55015 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbXBSLAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:00:23 -0500
Date: Mon, 19 Feb 2007 11:00:17 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@mit.edu>, Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 07/44 take 2] [UBI] misc unit header
Message-ID: <20070219110017.GC16930@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Theodore Tso <tytso@mit.edu>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165459.5845.18967.sendpatchset@localhost.localdomain> <20070217225908.GC16522@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217225908.GC16522@thunk.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 05:59:08PM -0500, Theodore Tso wrote:
> On Sat, Feb 17, 2007 at 06:54:59PM +0200, Artem Bityutskiy wrote:
> > diff -auNrp tmp-from/drivers/mtd/ubi/misc.h tmp-to/drivers/mtd/ubi/misc.h
> > --- tmp-from/drivers/mtd/ubi/misc.h	1970-01-01 02:00:00.000000000 +0200
> > +++ tmp-to/drivers/mtd/ubi/misc.h	2007-02-17 18:07:26.000000000 +0200
> > @@ -0,0 +1,146 @@
> > +#define xquotise(s) #s
> > +#define quotise(s) xquotise(s)
> 
> Nothing in your patch series uses this, and it's identical to
> stringify().   Please remove?
> 
> > +/**
> > + * rb_for_each_entry - walk an RB-tree.
> > + *
> > + * @rb: a pointer to type 'struct rb_node' to to use as a loop counter
> > + * @pos: a pointer to RB-tree entry type to use as a loop counter
> > + * @root: RB-tree's root
> > + * @member: the name of the 'struct rb_node' within the RB-tree entry
> > + */
> > +#define rb_for_each_entry(rb, pos, root, member)...
> 
> Shouldn't this be added to include/linux/rbtree.h?
> 
> > +/**
> > + * strdup_len - duplicate a string with known length.
> > + *
> > + * @str: original string
> > + * @len: the length of the string
> > + */
> > +char *strdup_len(const char *str, int len);
> 
> I'm not sure this should be polluting the kernel symbol namespace,
> especially since the implementation calls ubi_assert()....
> 
> It's not clear the assertion is all that useful, but if you must have
> it, why not do the check as an inline (with the assertion normally
> turned off), and then call out to kmemdup()?

Agreement to all of the above.  And _please_ move all kdoc comments to
the implementation files.
