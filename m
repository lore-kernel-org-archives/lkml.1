Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbYJ1B0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbYJ1B0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 21:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYJ1B0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 21:26:04 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:28366 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbYJ1B0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 21:26:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4DAM8S9kh5LE2tgWdsb2JhbACTYAEBFiKuDIFr
X-IronPort-AV: E=Sophos;i="4.33,495,1220193000"; 
   d="scan'208";a="219469203"
Date: Tue, 28 Oct 2008 12:25:57 +1100
From: Dave Chinner <david@fromorbit.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library
Message-ID: <20081028012557.GP18495@disturbed>
Mail-Followup-To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	linux-kernel@vger.kernel.org
References: <20081026124643.GA1328@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081026124643.GA1328@logfs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 01:46:44PM +0100, Jörn Engel wrote:
> The idea of using btrees in the kernel is not exactly new.  They have a
> number of advantages over rbtrees and hashtables, but also a number of
> drawbacks.  More importantly, logfs already makes use of them and -
> since I don't want any incompatible code to get merged and suffer the
> trouble it creates - I would like to discuss my implementation and where
> it makes sense and where it doesn't.
> 
> General advantages of btrees are memory density and efficient use of
> cachelines.  Hashtables are either too small and degrade into linked
> list performance, or they are too large and waste memory.  With changing
> workloads, both may be true on the same system.  Rbtrees have a bad
> fanout of less than 2 (they are not actually balanced binary trees),
> hence reading a fairly large number of cachelines to each lookup.
> 
> Main disadvantage of btrees is that they are complicated, come in a
> gazillion subtly different variant that differ mainly in the balance
> between read efficiency and write efficiency.  Comparing btrees against
> anything is a bit like comparing apples and random fruits.
> 
> This implementation is extremely simple.  It splits nodes when they
> overflow.  It does not move elements to neighboring nodes.  It does not
> try fancy 2:3 splits.  It does not even merge nodes when they shrink,
> making degenerate cases possible.  And it requires callers to do
> tree-global locking.  In effect, it will be hard to find anything less
> sophisticated.
> 
> The one aspect where my implementation is actually nice is in allowing
> variable key length.  Btree keys are interpreted as an array of unsigned
> long.  So by passing the correct geometry to the core functions, it is
> possible to handle 32bit, 64bit or 128bit btrees, which logfs uses.  If
> so desired, any other weird data format can be used as well (Zach, are
> you reading this?).
> 
> So would something like this be merged once some users are identified?
> Would it be useful for anything but logfs?  Or am I plain nuts?

I think a btree library would be useful - there are places where
people are using rb-trees instead of btree simply because it's
easier to use the rbtree than it is to implement a btree library.
I can think of several places I could use such a library for
in-memory extent representation....

That being said, I haven't had a chance to look at that code yet....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
