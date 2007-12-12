Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbXLLFOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbXLLFOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 00:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXLLFN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 00:13:58 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:45817 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbXLLFN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 00:13:57 -0500
Date: Wed, 12 Dec 2007 05:01:51 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Chuck Ebbert <cebbert@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Willy Tarreau <wtarreau@hera.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmpfs: restore missing clear_highpage
In-Reply-To: <475F24A7.3020106@redhat.com>
Message-ID: <Pine.LNX.4.64.0712120434410.9566@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0711281844370.25292@blonde.wat.veritas.com>
 <475F24A7.3020106@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007, Chuck Ebbert wrote:
> On 11/28/2007 01:55 PM, Hugh Dickins wrote:
> > tmpfs was misconverted to __GFP_ZERO in 2.6.11.  There's an unusual case in
> > which shmem_getpage receives the page from its caller instead of allocating.
> > We must cover this case by clear_highpage before SetPageUptodate, as before.
> > 
> > Signed-off-by: Hugh Dickins <hugh@veritas.com>
> > ---
> 
> What are the symptoms of the bug this fixes?

I've not seen it in practice, just noticed it while working on that
area in the code.  What's the polite way of describing these things
in public?  It's a vulnerability which might allow an attacker to
access data from inside the kernel which should have been zeroed -
in very limited circumstances I'd prefer not to have to devise and
announce.

It would also be wrong data, so could for example crash any program
rightly relying on uninitialized static data to be zeroed - in the
unlikely event that its data was coming via this route (in most setups
it never can do, perhaps I'd conclude that's true of all setups).  It
has escaped notice for nearly three years, so it's not a commonplace.

Further discussion offline if you like!

Hugh
