Return-Path: <linux-kernel-owner+w=401wt.eu-S1764554AbYECBqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764554AbYECBqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 21:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbYECBp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 21:45:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754401AbYECBp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 21:45:56 -0400
Date: Fri, 2 May 2008 18:34:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-next@vger.kernel.org, sfrench@us.ibm.com, swhiteho@redhat.com,
       jeff@garzik.org, ralf@linux-mips.org, drzeus-list@drzeus.cx,
       jack@ucw.cz, cbou@mail.ru, jens.axboe@oracle.com, ericvh@gmail.com,
       wim@iguana.be, chris@zankel.net, nico@cam.org, penberg@cs.helsinki.fi,
       clameter@sgi.com, ezk@cs.sunysb.edu, linux-kernel@vger.kernel.org
Subject: Re: git trees which are not yet in linux-next
Message-Id: <20080502183403.3d9f2d9f.akpm@linux-foundation.org>
In-Reply-To: <481BBD84.10904@s5r6.in-berlin.de>
References: <20080502151206.b40f77ea.akpm@linux-foundation.org>
	<20080502154200.a6d8c43a.akpm@linux-foundation.org>
	<481BBD84.10904@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 May 2008 03:19:00 +0200 Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Andrew Morton wrote:
> > On Fri, 2 May 2008 15:12:06 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> >> The first
> >> problem is working out "how the heck did that patch get into linux-next"? 
> >> That would be much easier if the signoff trail was complete for git-based
> >> patches, but it often is not.
> > 
> > doh.  I'm pulling linux-next's constituent trees independently, so if I
> > spot a turd in linux-next I can just grep the various git trees to find out
> > where it came from.
> > 
> > It seems wrong though...
> 
> What about the committer info?  Well, I suppose a nobody@localhost slips 
> in, but more often I expect it to be something more telling than that.

Beats me.  To pick one example:

commit 1a72963d3af38eb17a939fc19b322735da1c0aad
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Fri Apr 25 12:38:41 2008 -0400

    Convert board-nokia770 from semaphore to spinlock
    
    None of the operations done under the semaphore could sleep, so a spinlock
    is more appropriate to this case.
    
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

There's no sign how that got there.  A bit of forensics shows up:

semaphore-removal       git     git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git#semaphore-removal                                                  

in Next/Trees.  I don't actually have that tree in -mm, which is a bit
unusual.  Otherwise a grep for `Convert board-nokia770 from semaphore to
spinlock' would have found it.

Oh well, don't worry - I'll work it out ;)


