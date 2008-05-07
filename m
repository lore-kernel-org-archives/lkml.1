Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbYEGEhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbYEGEhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 00:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbYEGEhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 00:37:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39531 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbYEGEhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 00:37:37 -0400
Date: Tue, 6 May 2008 21:37:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
 drivers/video/aty/radeon_base.c
Message-ID: <20080506213717.725784ec@infradead.org>
In-Reply-To: <20080506212314.695daf98.akpm@linux-foundation.org>
References: <20080424043400.GS20457@bakeyournoodle.com>
	<20080506143936.6357e578.akpm@linux-foundation.org>
	<20080506.144301.233784820.davem@davemloft.net>
	<20080506145608.565b61bf.akpm@linux-foundation.org>
	<20080506210055.75e2f881@infradead.org>
	<20080506211233.f050fd41.akpm@linux-foundation.org>
	<20080506211552.6af7cecc@infradead.org>
	<20080506212314.695daf98.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 21:23:14 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 6 May 2008 21:15:52 -0700 Arjan van de Ven
> <arjan@infradead.org> wrote:
> 
> > On Tue, 6 May 2008 21:12:33 -0700
> > 
> > > > can we make it a WARN_ON() as well? that way we'll see it in
> > > > various kerneloops.org stats etc etc.. and we also get a nice
> > > > backtrace for free to go with it....
> > > > 
> > > > (rationale: users tend to not read their dmesg much, but
> > > > WARN_ON()'s do get noticed)
> > > 
> > > OK by me, although if we're going to do much more of this it
> > > might be time to add a WARN_ON which takes (fmt, args...).
> > 
> > totally; I was just talking to some others about doing just this.
> 
> The challenge will be to minimise the code footprint.

the meat of WARN_ON() is already out of line; so all the vararg stuff
is just going to be one function out of line, if we really care about
the last 20 bytes we can even implement WARN_ON() using an empty string.

I suspect it's not all that bad.
(but gcc is still churning, so no hard data yet)
 
> otcompletelyoh, perhaps we could generate a backtrace from within
> printk() itself for when it sees messages which have KERN_ERR or some
> other suitably-chosen (and probably configurable) facility level.

interesting thought. Only thing is that this won't give the option to
have a condition there, or to compile it out for those folks who care
about squeezing the last bytes out by disabling such debug messages.


> 
> That'll generate false positives and will reveal dubious choices, but
> we can fix those up.

I'm not all that worried about that; if we introduce a new flag that is
it'll be explicit and fine.
