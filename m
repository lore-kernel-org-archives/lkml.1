Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbZAGD2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbZAGD2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 22:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbZAGD2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 22:28:08 -0500
Received: from cantor.suse.de ([195.135.220.2]:34812 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbZAGD2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 22:28:06 -0500
Date: Wed, 7 Jan 2009 04:28:03 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090107032802.GA22559@wotan.suse.de>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106151131.b6c4ff0b.akpm@linux-foundation.org> <20090106232418.GB25103@infradead.org> <20090107011448.GB3390@wotan.suse.de> <87tz8b3nfe.fsf@basil.nowhere.org> <20090107014915.GE3390@wotan.suse.de> <20090107025725.GJ496@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107025725.GJ496@one.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 03:57:25AM +0100, Andi Kleen wrote:
> > sys_sync B which is invoked *after* sys_sync caller A should not
> > return before A. If you didn't have a global lock, they'd tend to
> > block one another's pages anyway. I think it's OK.
> 
> It means that you cannot reboot because reboot does sync.
> What happens when the sync gets stuck somewhere on a really
> slow device?

I don't follow you.

The sync gets "stuck" because it is writing out dirty data. You
don't want to reboot before that happens, which is exactly the
reason why sync gets called (although it is probably not needed
anyway if all filesystems get unmounted).

