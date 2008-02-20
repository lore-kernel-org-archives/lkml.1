Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYBTHdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYBTHdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 02:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYBTHdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 02:33:04 -0500
Received: from 1wt.eu ([62.212.114.60]:2055 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbYBTHdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 02:33:01 -0500
Date: Wed, 20 Feb 2008 08:32:45 +0100
From: Willy Tarreau <w@1wt.eu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Arjan van de Ven <arjan@infradead.org>, Roel Kluin <12o3l@tiscali.nl>,
       geoffrey.levand@am.sony.com, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
Message-ID: <20080220073245.GA28524@1wt.eu>
References: <47B70A61.9030306@tiscali.nl> <20080216094226.1e8eede1@laptopd505.fenrus.org> <p731w7axrat.fsf@bingen.suse.de> <200802191333.53607.nickpiggin@yahoo.com.au> <20080219055806.GA8404@1wt.eu> <20080219092846.GB6485@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219092846.GB6485@one.firstfloor.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 10:28:46AM +0100, Andi Kleen wrote:
> > Sometimes, for performance critical paths, I would like gcc to be dumb and
> > follow *my* code and not its hard-coded probabilities. 
> 
> If you really want that, simple: just disable optimization @)

already tried. It fixed some difficulties, but create new expected issues
with data being reloaded often from memory instead of being passed along
a few registers. Don't forget that optimizing for x86 requires a lot of
smartness from the compiler because of the very small number of registers!

> > Maybe one thing we would need would be the ability to assign probabilities
> > to each branch based on what we expect, so that gcc could build a better
> > tree keeping most frequently used code tight.
> 
> Just use profile feedback then for user space. I don't think it's a good
> idea for kernel code though because it leads to unreproducible binaries
> which would wreck the development model.

I never found this to be practically usable in fact, because you have to
use it on the *exact* same source. End of game for cross-compilation. It
would be good to be able to use a few pragmas in the code to say "hey, I
want this block optimized like this". This is what I understood the
__builtin_expect() was for, except that it tends to throw unpredicted
branches too far away.

> > Hmm I've just noticed -fno-guess-branch-probability in the man, I never tried
> > it.
> 
> Or -fno-reorder-blocks

Thanks for the hint, I will try it.

Willy

