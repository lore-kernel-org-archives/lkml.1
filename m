Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbYFKEr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbYFKEr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 00:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbYFKErT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 00:47:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbYFKErS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 00:47:18 -0400
Date: Wed, 11 Jun 2008 06:47:16 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org
Subject: Re: [patch 7/7] powerpc: lockless get_user_pages_fast
Message-ID: <20080611044716.GA11545@wotan.suse.de>
References: <20080605094300.295184000@nick.local0.net> <20080605094826.128415000@nick.local0.net> <Pine.LNX.4.64.0806101159110.17798@schroedinger.engr.sgi.com> <20080611031822.GA8228@wotan.suse.de> <Pine.LNX.4.64.0806102138380.19967@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806102138380.19967@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 09:40:25PM -0700, Christoph Lameter wrote:
> On Wed, 11 Jun 2008, Nick Piggin wrote:
> 
> > > This is reversing the modification to make get_page_unless_zero() usable 
> > > with compound page heads. Will break the slab defrag patchset.
> > 
> > Is the slab defrag patchset in -mm? Because you ignored my comment about
> > this change that assertions should not be weakened until required by the
> > actual patchset. I wanted to have these assertions be as strong as
> > possible for the lockless pagecache patchset.
> 
> So you are worried about accidentally using get_page_unless_zero on a 
> compound page? What would be wrong about that?

Unexpected. Compound pages should have no such races that require
get_page_unless_zero that we very carefully use in page reclaim.

If you don't actually know whether you have a reference to the
thing or not before trying to operate on it, then you're almost
definitely got refcount wrong. How does slab defrag use it?

