Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbZDXUUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbZDXUUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 16:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbZDXUT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 16:19:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39928 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbZDXUT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 16:19:57 -0400
Date: Fri, 24 Apr 2009 21:19:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: binfmt_aout fix
Message-ID: <20090424201952.GQ8633@ZenIV.linux.org.uk>
References: <20090424144738.GD32087@jurassic.park.msu.ru> <20090424150549.GN8633@ZenIV.linux.org.uk> <20090424154602.GA368@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424154602.GA368@jurassic.park.msu.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 07:46:02PM +0400, Ivan Kokshaysky wrote:
> On Fri, Apr 24, 2009 at 04:05:49PM +0100, Al Viro wrote:
> > On Fri, Apr 24, 2009 at 06:47:38PM +0400, Ivan Kokshaysky wrote:
> > > Fixed by changing the registration order of the default
> > > binfmt handlers using list_add_tail() and introducing insert_binfmt()
> > > function which places new handler on the top of the binfmt list.
> > > This might be generally useful for installing arch-specific frontends
> > > for default handlers or just for overriding them.
> > 
> > Hmm...  How about always doing list_add_tail() instead?
> 
> That would fix the module case, but gets broken when binfmt_aout
> in built-in, because the generic handlers are registered pretty
> early (core_initcall) and alpha binfmt_loader is an arch_initcall.

OK, probably the easiest way to deal with that.

ACK
