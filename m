Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbZKYGyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbZKYGyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 01:54:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbZKYGyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 01:54:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46922 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbZKYGyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 01:54:07 -0500
Date: Wed, 25 Nov 2009 07:54:12 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091125065412.GD17484@wotan.suse.de>
References: <20091123145409.GA29627@wotan.suse.de> <87einnwsxv.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87einnwsxv.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 09:47:56PM +0100, Andi Kleen wrote:
> Nick Piggin <npiggin@suse.de> writes:
> 
> > Hi,
> >
> > Last time this issue came up that I could see, I don't think
> > there were objections to making rwlocks fair, the main
> > difficulty seemed to be that we allow reentrant read locks
> > (so a write lock waiting must not block arbitrary read lockers).
> >
> > Nowadays our rwlock usage is smaller although still quite a
> > few, so it would make better sense to do a conversion by
> > introducing a new lock type and move them over I guess.
> 
> You want to do a new lock type for potentially nested rwlocks?
> 
> >From the basic idea it sounds good, but according
> to grep the current tree has hundreds of rwlocks all over,
> and how would you reliably detect whether they are nestable
> or not?
> 
> I assume it's not something that could be easily analyzed
> at compile time and relying on runtime would seem dangerous.
> 
> Basically it sounds like quite a lot of work.
> 
> A better plan might be to have new types which are non nestable
> and only move over audited code to fair rwlocks.

No that's what I meant, the new type would be non nestable.


