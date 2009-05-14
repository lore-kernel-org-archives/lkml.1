Return-Path: <linux-kernel-owner+w=401wt.eu-S1761191AbZENQAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761191AbZENQAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 12:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbZENQAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 12:00:30 -0400
Received: from mail.fieldses.org ([141.211.133.115]:38150 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbZENQA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 12:00:29 -0400
Date: Thu, 14 May 2009 12:00:30 -0400
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/sunrpc/svc.c: fix sparse warning
Message-ID: <20090514160030.GA5675@fieldses.org>
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8D20@mi8nycmail19.Mi8.com> <20090416190601.GA1145@fieldses.org> <BD79186B4FD85F4B8E60E381CAEE1909015F8F97@mi8nycmail19.Mi8.com> <20090511230541.GL793@fieldses.org> <BD79186B4FD85F4B8E60E381CAEE19090179A55B@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090179A55B@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 11:58:37AM -0400, H Hartley Sweeten wrote:
> On Monday, May 11, 2009 4:06 PM, J. Bruce Fields wrote:
> > On Thu, Apr 16, 2009 at 03:15:17PM -0400, H Hartley Sweeten wrote:
> >> On Thursday, April 16, 2009 12:06 PM, J. Bruce Fields wrote:
> >>> On Wed, Apr 15, 2009 at 03:46:13PM -0400, H Hartley Sweeten wrote:
> >>>> Fix sparse warning in net/sunrpc/svc.c.
> >>>> 
> >>>> 	warning: symbol 'node' shadows an earlier one
> >>>
> >>> What's the other symbol?
> >>
> >> Sorry. Left that out...
> >> 
> >> include/linux/nodemask.h
> >> 
> >> #define any_online_node(mask)			\
> >> ({						\
> >> 	int node;				\
> >> 	for_each_node_mask(node, (mask))	\
> >> 		if (node_online(node))		\
> >> 			break;			\
> >> 	node;					\
> >> })
> >> 
> >> arch/powerpc/mm/numa.c is the only other user of that macro. In that
> >> file the local variable is called nid, hence the name change in this
> >> patch.
> >
> > Stupid question (and sorry for the delay): any reason that macro
> > couldn't just be a static inline function?
> >
> > I'm sort of resistant to the idea that the caller should have to care
> > what local variable names the implementation uses.
> 
> That would probably be cleaner and it would prevent the same warning
> from possibly occurring in the future.  I just assumed it was originally
> made a macro for a good reason.
> 
> Should I submit an updated patch changing the macro into an static
> inline function?

I'd be for it.  If nothing else that'll probably be the fastest way to
find out if there was a good reason!

--b.
