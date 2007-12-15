Return-Path: <linux-kernel-owner+w=401wt.eu-S1765034AbXLOANg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765034AbXLOANg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 19:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbXLOAN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 19:13:28 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:48854 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753813AbXLOAN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 19:13:28 -0500
Date: Sat, 15 Dec 2007 01:13:31 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Willy Tarreau <wtarreau@hera.kernel.org>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmpfs: restore missing clear_highpage
Message-ID: <20071215001331.GC5403@stusta.de>
References: <Pine.LNX.4.64.0711281844370.25292@blonde.wat.veritas.com> <475F24A7.3020106@redhat.com> <Pine.LNX.4.64.0712120434410.9566@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712120434410.9566@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 05:01:51AM +0000, Hugh Dickins wrote:
> On Tue, 11 Dec 2007, Chuck Ebbert wrote:
> > On 11/28/2007 01:55 PM, Hugh Dickins wrote:
> > > tmpfs was misconverted to __GFP_ZERO in 2.6.11.  There's an unusual case in
> > > which shmem_getpage receives the page from its caller instead of allocating.
> > > We must cover this case by clear_highpage before SetPageUptodate, as before.
> > > 
> > > Signed-off-by: Hugh Dickins <hugh@veritas.com>
> > > ---
> > 
> > What are the symptoms of the bug this fixes?
> 
> I've not seen it in practice, just noticed it while working on that
> area in the code.  What's the polite way of describing these things
> in public?  It's a vulnerability which might allow an attacker to
> access data from inside the kernel which should have been zeroed -
> in very limited circumstances I'd prefer not to have to devise and
> announce.
> 
> It would also be wrong data, so could for example crash any program
> rightly relying on uninitialized static data to be zeroed - in the
> unlikely event that its data was coming via this route (in most setups
> it never can do, perhaps I'd conclude that's true of all setups).  It
> has escaped notice for nearly three years, so it's not a commonplace.
> 
> Further discussion offline if you like!

Can we get or is there already a CVE number?

> Hugh

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

