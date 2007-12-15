Return-Path: <linux-kernel-owner+w=401wt.eu-S1753006AbXLOFok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbXLOFok (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 00:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756664AbXLOFoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 00:44:25 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:42706 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407AbXLOFoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 00:44:24 -0500
Date: Sat, 15 Dec 2007 05:43:01 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Adrian Bunk <bunk@kernel.org>
cc: Chuck Ebbert <cebbert@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Willy Tarreau <wtarreau@hera.kernel.org>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmpfs: restore missing clear_highpage
In-Reply-To: <20071215001331.GC5403@stusta.de>
Message-ID: <Pine.LNX.4.64.0712150533550.24015@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0711281844370.25292@blonde.wat.veritas.com>
 <475F24A7.3020106@redhat.com> <Pine.LNX.4.64.0712120434410.9566@blonde.wat.veritas.com>
 <20071215001331.GC5403@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Dec 2007, Adrian Bunk wrote:
> On Wed, Dec 12, 2007 at 05:01:51AM +0000, Hugh Dickins wrote:
> > On Tue, 11 Dec 2007, Chuck Ebbert wrote:
> > > On 11/28/2007 01:55 PM, Hugh Dickins wrote:
> > > > tmpfs was misconverted to __GFP_ZERO in 2.6.11.  There's an unusual case in
> > > > which shmem_getpage receives the page from its caller instead of allocating.
> > > > We must cover this case by clear_highpage before SetPageUptodate, as before.
> > > > 
> > > > Signed-off-by: Hugh Dickins <hugh@veritas.com>
> > > > ---
> > > 
> > > What are the symptoms of the bug this fixes?
> > 
> > I've not seen it in practice, just noticed it while working on that
> > area in the code.  What's the polite way of describing these things
> > in public?  It's a vulnerability which might allow an attacker to
> > access data from inside the kernel which should have been zeroed -
> > in very limited circumstances I'd prefer not to have to devise and
> > announce.
> > 
> > It would also be wrong data, so could for example crash any program
> > rightly relying on uninitialized static data to be zeroed - in the
> > unlikely event that its data was coming via this route (in most setups
> > it never can do, perhaps I'd conclude that's true of all setups).  It
> > has escaped notice for nearly three years, so it's not a commonplace.
> > 
> > Further discussion offline if you like!
> 
> Can we get or is there already a CVE number?

I've not asked for one, so I don't suppose there is one: do go ahead
and get one if you wish (though of course it would have been better
earlier, so 2.6.22.15 and 2.6.23.10 could have cited it along with
their fix: sorry about that).

Hugh
