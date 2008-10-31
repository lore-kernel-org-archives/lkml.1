Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbYJaPgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbYJaPgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYJaPfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:35:51 -0400
Received: from lazybastard.de ([212.112.238.170]:33670 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbYJaPfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:35:51 -0400
Date: Fri, 31 Oct 2008 16:35:40 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Tim Gardner <tcanonical@tpi.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library
Message-ID: <20081031153539.GH18182@logfs.org>
References: <20081026124643.GA1328@logfs.org> <1225458974.5546.6.camel@johannes.berg> <490B21AE.9030406@tpi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <490B21AE.9030406@tpi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 October 2008 09:18:06 -0600, Tim Gardner wrote:
> Johannes Berg wrote:
> >> +static inline size_t btree_visitorl(struct btree_headl *head, long opaque,
> >> +		visitorl_t func2)
> >> +{
> >> +	return btree_visitor(&head->h, &btree_geo32, opaque, visitorl, func2);
> >> +}
> > 
> > Incidentally, do you think it would be possible to implement a kind of 
> > 
> > btree_for_each_entry(e, ...) {
> > 	do something with e
> > }
> > 
> > macro or function/macro combination? You seem to be doing a recursive
> > walk across the tree, would it be useful to have a linked list at the
> > lowest level of nodes to be able to iterate more easily?
> 
> What would you expect to be the behavior if you remove 'e' ? That might
> cause the tree to get re-ordered. Do you restart the list traversal?

BUG(), if you're lucky.  Silent data corruption, if you're not so lucky.

The btree_grim_visitor() exists to remove all element after being handed
to the visitor.  btree_visitor() removes none.  Either function requires
the caller to do proper locking.  Calling two functions from two threads
in parallel or calling a function from the visitor callback will give
you undefined results - with the exception of parallel lookups, which
are obviously fine.

Jörn

-- 
Beware of bugs in the above code; I have only proved it correct, but
not tried it.
-- Donald Knuth
