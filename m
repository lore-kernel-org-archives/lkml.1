Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948AbYKAKRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbYKAKRv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 06:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYKAKRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 06:17:44 -0400
Received: from atlantis.8hz.com ([212.129.237.78]:56666 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbYKAKRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 06:17:42 -0400
Date: Sat, 1 Nov 2008 10:17:41 +0000
From: Sean Young <sean@mess.org>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library
Message-ID: <20081101101741.GA99347@atlantis.8hz.com>
References: <20081026124643.GA1328@logfs.org> <20081031201745.GA93714@atlantis.8hz.com> <20081031233614.GA24960@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031233614.GA24960@logfs.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2008 at 12:36:15AM +0100, Joern Engel wrote:
> On Fri, 31 October 2008 20:17:45 +0000, Sean Young wrote:
> > On Sun, Oct 26, 2008 at 01:46:44PM +0100, Joern Engel wrote:
> > > General advantages of btrees are memory density and efficient use of
> > > cachelines.  Hashtables are either too small and degrade into linked
> > > list performance, or they are too large and waste memory.  With changing
> > > workloads, both may be true on the same system.  Rbtrees have a bad
> > > fanout of less than 2 (they are not actually balanced binary trees),
> > > hence reading a fairly large number of cachelines to each lookup.
> > 
> > Which reminds me:
> > 
> > find_vma() uses rbtrees. Now I assume find_vma() is called far more than
> > mmap() and friends. Since avltree are balanced (unlike rbtrees) lookups
> > will be faster at the expense of extra rotations during updates.
> 
> Maybe I should have been clearer.  Rbtrees _are_ balanced trees.  They
> are not balanced _binary_ trees, but balanced 234-trees in a binary
> representation.

I should have been more clearer. avltrees are more rigidly balanced than
rbtrees, making them faster for lookups but slower for modification:

http://en.wikipedia.org/wiki/AVL_tree#Comparison_to_other_structures

The difference between the shortest path to a leaf node and the longest 
path to a leaf node is +1 for avl and *2 for red-black.


Sean
