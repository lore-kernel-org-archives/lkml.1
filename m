Return-Path: <linux-kernel-owner+w=401wt.eu-S1752121AbYJaN3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbYJaN3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbYJaN3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:29:32 -0400
Received: from lazybastard.de ([212.112.238.170]:35494 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbYJaN3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:29:31 -0400
Date: Fri, 31 Oct 2008 14:29:22 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library
Message-ID: <20081031132921.GG18182@logfs.org>
References: <20081026124643.GA1328@logfs.org> <1225458974.5546.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1225458974.5546.6.camel@johannes.berg>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 October 2008 14:16:14 +0100, Johannes Berg wrote:
> 
> > +static inline size_t btree_visitorl(struct btree_headl *head, long opaque,
> > +		visitorl_t func2)
> > +{
> > +	return btree_visitor(&head->h, &btree_geo32, opaque, visitorl, func2);
> > +}
> 
> Incidentally, do you think it would be possible to implement a kind of 
> 
> btree_for_each_entry(e, ...) {
> 	do something with e
> }
> 
> macro or function/macro combination? You seem to be doing a recursive
> walk across the tree, would it be useful to have a linked list at the
> lowest level of nodes to be able to iterate more easily?

Maybe.  On the whole, I've tried hard not to optimize much.  The idea
was that a simple design can still receive some fundamental changes.
But once a number of neat tricks like a linked list at the lowest level
are used, the code becomes more resistent to changes.

That being said, the maze of function pointer around btree_visitor()
does not make me very proud.  Might be worth it.

Jörn

-- 
Prosperity makes friends, adversity tries them.
-- Publilius Syrus
