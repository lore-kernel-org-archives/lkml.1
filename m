Return-Path: <linux-kernel-owner+w=401wt.eu-S933400AbYDVWno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400AbYDVWno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759683AbYDVWng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:43:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45387 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758970AbYDVWng (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:43:36 -0400
Date: Wed, 23 Apr 2008 08:43:09 +1000
From: David Chinner <dgc@sgi.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] xfs: #define out unused parameters of xfs_bmap_add_free and xfs_btree_read_bufl
Message-ID: <20080422224309.GW108924158@sgi.com>
References: <20080419142329.GA5339@elte.hu> <200804221142.00914.vda.linux@googlemail.com> <200804221216.25905.vda.linux@googlemail.com> <200804221320.54147.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804221320.54147.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 01:20:54PM +0200, Denys Vlasenko wrote:
> Hi David,
> 
> xfs_bmap_add_free and xfs_btree_read_bufl functions
> use some of their parameters only in some cases
> (e.g. if DEBUG is defined, or on non-Linux OS :)
> 
> This patch removes these parameters using #define hack
> which makes them "disappear" without the need of uglifying
> every callsite with #ifdefs.

We don't use pre-processor hacks to hide function variables for different
config options.  The XFS header files are messy enough without adding
additional redefinitions of function types to them.

w.r.t xfs_bmap_add_free(), the correct thing to do is to factor the
debug code out into a different function that is only compiled
on debug kernels and remove all the debug checks from xfs_bmap_add_free().

As it is, I don't think that the change is worth the maintenance
cost for a few bytes of stack space in non-critical paths.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
