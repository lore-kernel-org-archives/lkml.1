Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbYJOQnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbYJOQnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 12:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbYJOQnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 12:43:12 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57977 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbYJOQnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 12:43:10 -0400
Date: Wed, 15 Oct 2008 10:24:11 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: paulmck@us.ibm.com, sds@tycho.nsa.gov, jmorris@namei.org,
       chrisw@sous-sol.org, dhowells@redhat.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       haradats@nttdata.co.jp, akpm@linux-foundation.org
Subject: Re: [TOMOYO #10 (linux-next) 7/8] File operation restriction part.
Message-ID: <20081015152411.GA18455@us.ibm.com>
References: <20081009042814.398846861@nttdata.co.jp> <20081009042922.939610141@nttdata.co.jp> <20081009164836.GA5480@us.ibm.com> <200810120909.GDF95392.SQOFFFHVtOMOJL@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810120909.GDF95392.SQOFFFHVtOMOJL@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp):
> Hello.
> 
> Serge E. Hallyn wrote:
> > In a previous patch you mark funtions with 'begin/end critical section'.
> > Please instead put a comment on top listing precisely which locks
> > the fn expects to be held.
> > 
> > As for protecting your own data, please
> > 	1. explain at the var declaration what lock protects it
> > 	2. define the lock next to the list
> 
> OK. I added comments and simplified dependencies.
> http://svn.sourceforge.jp/cgi-bin/viewcvs.cgi/trunk/2.2.x/tomoyo-lsm/patches/?root=tomoyo

Cool, thanks.

This, in general, is part of changing your mindset - from that of being
a maintainer of out-of-tree code, to being a part of the core community.
My dcache comment further down is along the same lines.

> Anything else we can do before reposting as #11?

Well I'd like to sit down one day and make sure that your _clean()s in
patch 1 cover all the error cases and there are no leaks.

The pathname walking code doesn't seem to be in any way tomoyo-specific,
so it really ought to be in fs/dcache.c where the relevant maintainers
will see, scrutinize, and update it when necessary.  I realize that
means we make it look like we encourage others to use the functions
which we don't want either.  But having them in tomoyo-specific code
isn't nice either.

And I haven't really looked at your patches 6-8 yet, and am not sure
when I'll get time.

Anyway I think we're well to the point where the patches should be
tossed into a tree and tested (once you address Paul's feedback).
Actually, one thing which is missing from this patchset is a MAINTAINERS
entry.  What I'd particularly be interested in is a mailing list entry
(with a public readable archive), so we can see that there is in fact a
community using this.

-serge
