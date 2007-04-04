Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917AbXDDQHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbXDDQHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXDDQHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:07:48 -0400
Received: from ns.suse.de ([195.135.220.2]:60259 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbXDDQHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:07:46 -0400
Date: Wed, 4 Apr 2007 18:07:15 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: Dan Aloni <da-x@monatomic.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>, tee@sgi.com,
       holt@sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] no ZERO_PAGE?
Message-ID: <20070404160715.GJ19587@v2.random>
References: <20070404033726.GE18507@wotan.suse.de> <Pine.LNX.4.64.0704041023040.17341@blonde.wat.veritas.com> <20070404102407.GA529@wotan.suse.de> <20070404122701.GB19587@v2.random> <20070404135530.GA29026@localdomain> <20070404141457.GF19587@v2.random> <20070404144421.GA13762@localdomain> <Pine.LNX.4.64.0704041553220.18202@blonde.wat.veritas.com> <20070404153451.GH19587@v2.random> <Pine.LNX.4.64.0704041636550.22242@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704041636550.22242@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 04:41:46PM +0100, Hugh Dickins wrote:
> Nor I: I meant that anonymous readfault should
> (perhaps) mark the pte writable but clean.

Sorry I assumed when you said clean you implied readonly... Though
we'd need to differentiate the archs where the dirty bit is not set by
the hardware. Overall I'm unsure it worth it. Currently the VM
definitely wouldn't cope with a writeable and clean anonymous page, so
we'd need to change shrink_page_list and try_to_unmap_anon to make it
work. Likely it won't be measurable, so it may be a nice feature to
have from a theoretical point of view, in practice I doubt it matters.
