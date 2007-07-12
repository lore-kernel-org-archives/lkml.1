Return-Path: <linux-kernel-owner+w=401wt.eu-S934446AbXGLQUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446AbXGLQUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757805AbXGLQUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:20:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41641 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755933AbXGLQU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:20:29 -0400
Date: Thu, 12 Jul 2007 09:19:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>, cmm@us.ibm.com,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 2][PATCH 2/5] cleanups: Add extent sanity checks
Message-Id: <20070712091932.68733b2b.akpm@linux-foundation.org>
In-Reply-To: <1184248671.10312.7.camel@kleikamp.austin.ibm.com>
References: <1183275382.4010.121.camel@localhost.localdomain>
	<20070710163020.196d32a0.akpm@linux-foundation.org>
	<469612B4.5070105@shadowen.org>
	<1184248671.10312.7.camel@kleikamp.austin.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007 08:57:51 -0500 Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:

> On Thu, 2007-07-12 at 12:38 +0100, Andy Whitcroft wrote:
> > Andrew Morton wrote:
> > >> +			if (ext4_ext_check_header(inode, ext_block_hdr(bh),
> > >> +							depth - i - 1)) {
> > >> +				err = -EIO;
> > >> +				break;
> > >> +			}
> > >> +			path[i+1].p_bh = bh;
> > > 
> > > Really that should have been "i + 1".  checkpatch misses this.  It seems to
> > > be missing more stuff that it used to lately.
> > 
> > This one is difficult.  The rules up to now have been consistent spacing
> > is required on both sides of mathematics operators.  I personally like
> > spaces always, but we do tend to use them without spaces too where the
> > binding is effectivly part of the value -- the classic case is something
> > like:
> > 
> > 	pfn << MAX_ORDER-1
> > 
> > In allowing that sort of thing, we implictly allow the one you note
> > above.  We have tried to be overly annoying on these things, and so the
> > check is consistancy, spaces both or neither.  We could be stricter.
> 
> I personally think stricter is better.  An occasionally false-positive
> isn't going to hurt anyone.  (Well, maybe the checkpatch.pl maintainers
> will get nagged.)  It at least will cause the developer to look at the
> line of code in question and make a conscious decision to leave it as it
> is.  I'm assuming that upstream maintainers use checkpatch.pl with some
> constraint, and don't throw every patch that produces a warning back at
> the submitter.
> 

I'm in two minds.  Missing-the-spaces is pretty damn common and is sometimes
a reasonable way of saving quite a lot of horizontal space.  I spose we could
take it out again if it's causing problems.
