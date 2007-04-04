Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbXDDNcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbXDDNcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 09:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbXDDNcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 09:32:11 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:57155 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbXDDNcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 09:32:09 -0400
X-AuditID: d80ac287-976cabb000000c42-2d-4613a8d8ecdd 
Date: Wed, 4 Apr 2007 14:32:03 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrea Arcangeli <andrea@suse.de>
cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>, tee@sgi.com,
       holt@sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] no ZERO_PAGE?
In-Reply-To: <20070404130559.GD19587@v2.random>
Message-ID: <Pine.LNX.4.64.0704041426080.10683@blonde.wat.veritas.com>
References: <20070329075805.GA6852@wotan.suse.de>
 <Pine.LNX.4.64.0703291324090.21577@blonde.wat.veritas.com>
 <20070330024048.GG19407@wotan.suse.de> <20070404033726.GE18507@wotan.suse.de>
 <Pine.LNX.4.64.0704041023040.17341@blonde.wat.veritas.com>
 <20070404102407.GA529@wotan.suse.de> <Pine.LNX.4.64.0704041338450.7416@blonde.wat.veritas.com>
 <20070404130559.GD19587@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 04 Apr 2007 13:32:08.0374 (UTC) FILETIME=[A47A8D60:01C776BD]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Andrea Arcangeli wrote:
> On Wed, Apr 04, 2007 at 01:45:06PM +0100, Hugh Dickins wrote:
> > I'm confused.  CONFIG_ZERO_PAGE off is where we'd like to end up: how
> > would turning CONFIG_ZERO_PAGE on in -rc kernels help us to get there?
> 
> He most certainly meant on by default.

Okay, I thought it more diplomatic to label myself as the confused one ;)

> 
> I think if we do this, we also need a zeropage counter in the vm stats
> so that we'll get a measure of the waste and it'll be possible to
> identify apps to optimize/fix.

That's a little unfortunate, since we'd then have to lose the win from
this change, that we issue a writable zeroed page (when VM_WRITE) in
do_anonymous_page, even when it's a read fault, saving subsequent fault.

Wouldn't we?  Or am I confused ;?

Hugh
