Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbYFCMCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbYFCMCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 08:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757433AbYFCMBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 08:01:48 -0400
Received: from mail2.shareable.org ([80.68.89.115]:52269 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbYFCMBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 08:01:46 -0400
X-Greylist: delayed 1873 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jun 2008 08:01:45 EDT
Date: Tue, 3 Jun 2008 13:01:35 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Miklos Szeredi <miklos@szeredi.hu>, drepper@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] utimensat() non-conformances and fixes [v3]
Message-ID: <20080603120135.GA28905@shareable.org>
References: <482D4665.4050401@gmail.com> <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <48401E7E.9090304@gmail.com> <cfd18e0f0806030405u1c32b114pa0fdd979f36f87fb@mail.gmail.com> <E1K3URo-0005sj-JW@pomaz-ex.szeredi.hu> <20080603112221.GW28946@ZenIV.linux.org.uk> <cfd18e0f0806030427p22a274dev746e1656662f34f6@mail.gmail.com> <20080603113018.GA27955@shareable.org> <cfd18e0f0806030439n5a11fa4aocd6251ffab66b6dd@mail.gmail.com> <20080603114921.GX28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603114921.GX28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Tue, Jun 03, 2008 at 01:39:07PM +0200, Michael Kerrisk wrote:
> 
> > > Is there anything else where the file descriptor's access mode allows
> > > doing things on Linux, but the standard requires a permissions check
> > > each time?
> > 
> > Jamie,
> > 
> > I can't think of examples offhand -- but I'm also not quite sure what
> > your question is about.  Could you say a little more?
> 
> "Is anything else equally stupid?", I suspect...  AFAICS, behaviour in
> question is inherited from futimes(2) in one of the *BSD - nothing to
> do about that now (at least 10 years too late).  It's rather inconsistent
> with a lot of things, starting with "why utimes(2) has weaker requirements
> with NULL argument", but we are far too late to fix that.

To be fair, having a writable file descriptor only lets you change the
mtime to "now", and having a readable file descriptor only lets you
change the atime to "now".

Changing the times _in general_ can be seen as over-reaching those
capabilities and arguably justifies more strict checks.

E.g. setting times in the past, you can break some caching systems,
Make, etc.  Setting times to "now" will not break those things.

(A bit analogous with O_APPEND vs. O_WRITE.  Someone hands you an
O_APPEND descriptor and they can continue to assume you won't clobber
earlier records in their file.)

-- Jamie
