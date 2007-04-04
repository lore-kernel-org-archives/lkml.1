Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbXDDNkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbXDDNkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 09:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbXDDNkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 09:40:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:40792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbXDDNkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 09:40:15 -0400
Date: Wed, 4 Apr 2007 15:40:02 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>, tee@sgi.com,
       holt@sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] no ZERO_PAGE?
Message-ID: <20070404134002.GE19587@v2.random>
References: <20070329075805.GA6852@wotan.suse.de> <Pine.LNX.4.64.0703291324090.21577@blonde.wat.veritas.com> <20070330024048.GG19407@wotan.suse.de> <20070404033726.GE18507@wotan.suse.de> <Pine.LNX.4.64.0704041023040.17341@blonde.wat.veritas.com> <20070404102407.GA529@wotan.suse.de> <Pine.LNX.4.64.0704041338450.7416@blonde.wat.veritas.com> <20070404130559.GD19587@v2.random> <Pine.LNX.4.64.0704041426080.10683@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704041426080.10683@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 02:32:03PM +0100, Hugh Dickins wrote:
> That's a little unfortunate, since we'd then have to lose the win from
> this change, that we issue a writable zeroed page (when VM_WRITE) in
> do_anonymous_page, even when it's a read fault, saving subsequent fault.

Hmm no, that win would remain (and that win would only apply to the
class of apps that we intend to hurt by removing the zero-page
anyway). I think it's enough to increase a per-cpu counter in
do_anonymous_page if it's a read fault, and nothing else. We don't
need to keep track of the exact number of ZERO_PAGEs in the
VM. Ideally nothing should increase my counter, hence your "exact"
counter would always be zero too when everything is ok.

The only real win we'll lose with the counter is the removal of the
slow-path branch in do_anonymous_page, but I guess I'm more
comfortable to be able to detect if something very inefficient ever
run on my system.
