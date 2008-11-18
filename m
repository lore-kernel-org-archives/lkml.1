Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbYKRNUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbYKRNUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 08:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYKRNT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 08:19:56 -0500
Received: from verein.lst.de ([213.95.11.210]:33939 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbYKRNTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 08:19:55 -0500
Date: Tue, 18 Nov 2008 14:19:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: mtk.manpages@gmail.com
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Robert Love <rlove@rlove.org>,
       linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [take 3] Use pid in inotify events.
Message-ID: <20081118131937.GC16944@lst.de>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081116232450.GA13547@ioremap.net> <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 11:59:11AM -0500, Michael Kerrisk wrote:
> NAK.  If we are going to do this -- and I leave the security
> discussions to others more knowlegeable on that score than me -- then
> the API design should be better than this.  The current design is a
> hack.  Why exclude rename events?  Why re-use the cookie field?  The
> only answers I can guess at are that the current patch is less work to
> write.  IMO, there are (much) better design possibilities, using
> inotify1(), as I suggested earlier in this thread.

Yes, this kind of thing should be enable using an flag to inotify1, and
be consistant even for rename.  Doing it as a flag to inotify1 also has
the advantage to be able to return an -EPERM when the feature is
requested but not allowed instead of letting applications that assume it
silently fail.

