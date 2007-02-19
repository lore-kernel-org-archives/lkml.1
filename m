Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbXBSLQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbXBSLQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932110AbXBSLQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:16:43 -0500
Received: from smtp.nokia.com ([131.228.20.172]:57638 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbXBSLQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:16:42 -0500
Subject: Re: [PATCH 07/44 take 2] [UBI] misc unit header
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Theodore Tso <tytso@mit.edu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070217225908.GC16522@thunk.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165459.5845.18967.sendpatchset@localhost.localdomain>
	 <20070217225908.GC16522@thunk.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 19 Feb 2007 13:13:02 +0200
Message-Id: <1171883582.13817.9.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Feb 2007 11:13:01.0832 (UTC) FILETIME=[EB605080:01C75416]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070219131029-375CDBB0-1BB55557/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-17 at 17:59 -0500, Theodore Tso wrote:
> > +#define xquotise(s) #s
> > +#define quotise(s) xquotise(s)
> 
> Nothing in your patch series uses this, and it's identical to
> stringify().   Please remove?

Done, thanks.

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

Not sure, probably for generic we want to have several of these
depending on how the tree is traversed. But I could try to submit it to
generic code if you think it makes sens.

> > +char *strdup_len(const char *str, int len);
> 
> I'm not sure this should be polluting the kernel symbol namespace,
> especially since the implementation calls ubi_assert()....
> 
> It's not clear the assertion is all that useful, but if you must have
> it, why not do the check as an inline (with the assertion normally
> turned off), and then call out to kmemdup()?

Got rid of it and use kmemdup() directly, thanks.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

