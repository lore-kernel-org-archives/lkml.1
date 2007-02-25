Return-Path: <linux-kernel-owner+w=401wt.eu-S933659AbXBYFpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659AbXBYFpu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 00:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933663AbXBYFpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 00:45:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37442 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933659AbXBYFpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 00:45:49 -0500
Date: Sun, 25 Feb 2007 05:45:48 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
Message-ID: <20070225054547.GB7941@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Artem Bityutskiy <dedekind@infradead.org>,
	David Woodhouse <dwmw2@infradead.org>, Theodore Tso <tytso@mit.edu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165449.5845.18238.sendpatchset@localhost.localdomain> <20070219105445.GA16930@infradead.org> <1171976753.4039.27.camel@sauron> <20070220145503.GC3170@thunk.org> <1171984555.3518.5.camel@hades.cambridge.redhat.com> <1171985055.4039.44.camel@sauron>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171985055.4039.44.camel@sauron>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 05:24:15PM +0200, Artem Bityutskiy wrote:
> On Tue, 2007-02-20 at 15:15 +0000, David Woodhouse wrote:
> > On Tue, 2007-02-20 at 09:55 -0500, Theodore Tso wrote:
> > > It appears that the reason why you are doing this is because you think
> > > you need the (packed) attribute.  Not needed; Linux assumes all over
> > > the place 16, 32, and 64 types are packed.  If Linux is ever compiled
> > > on an architecture where this isn't true, the compiler will probably
> > > need to be fixed so these assumptions are true, since all manner of
> > > things will break.
> > 
> > No, the packedness is irrelevant -- the reason is just to catch all the
> > places where you might otherwise forget to use byte-swapping accesses.
> 
> Bear in mind we share this header with user-space, so it is safer to use
> packed as well as C99 types.

It's definitively not safe for userspace - packed is not an ISO C thing
and there's no guarantee userspace compilers understand it.   Also you
really don't want to use packed in new code, if you really need oddly
aligned types it's much better to use byte arrays.
