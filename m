Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbYKJPUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbYKJPUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 10:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbYKJPUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 10:20:45 -0500
Received: from kandzendo.ru ([195.178.208.66]:53384 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbYKJPUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 10:20:45 -0500
Date: Mon, 10 Nov 2008 18:20:43 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: mtk.manpages@gmail.com
Cc: linux-kernel@vger.kernel.org, Robert Love <rlove@rlove.org>,
       linux-api@vger.kernel.org, John McCutchan <ttb@tentacle.dhs.org>
Subject: Re: [1/1] Use pid in inotify events.
Message-ID: <20081110152043.GB15796@ioremap.net>
References: <20081108114225.GA22674@ioremap.net> <cfd18e0f0811080625w5b285cc0p2410e8d187b025c7@mail.gmail.com> <20081108153545.GA3859@ioremap.net> <cfd18e0f0811080858k7f6cddadg962771ed0cb3bdb8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0811080858k7f6cddadg962771ed0cb3bdb8@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael.

On Sat, Nov 08, 2008 at 11:58:30AM -0500, Michael Kerrisk (mtk.manpages@googlemail.com) wrote:
> It's perhaps unfortunate that the structure wasn't padded out with a
> few additional fields "for future use".  But -- maybe it is not really
> true that we can't change things.  Two things to consider:
> 
> a) We now (since 2.6.27) have an inotify_init1() which has a flags argument.
> b) There are spare bits in the mask argument of inotify_add_watch()
> 
> We could use a flag in either of these to say that we want a different
> structure returned on read() from the inotify descriptor.  In the
> first case, this would be a global setting for all inotify events on
> that descriptor.  In the second, we could do it on a per-watch basis
> (I'm not so sure that that is a nice idea).  Since we are in any case
> extending the ABI, and new applications would need to be taught about
> the extension, it seems we could consider either of the alternative
> extensions I mentioned, which woul also allow the PID to be obtained
> for rename() events.  What do you think?

This may be a good idea for some serious ABI change. I think we could
extend it even more to include IO offset/size into events and attribute
changes.

-- 
	Evgeniy Polyakov
