Return-Path: <linux-kernel-owner+w=401wt.eu-S933145AbXCCWhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145AbXCCWhY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 17:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933144AbXCCWhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 17:37:24 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48013 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933134AbXCCWhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 17:37:23 -0500
Date: Sat, 3 Mar 2007 14:37:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-Id: <20070303143714.cdd83690.akpm@linux-foundation.org>
In-Reply-To: <45E9F5DA.2070708@redhat.com>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	<45E9DD4A.2060806@redhat.com>
	<20070303131204.6706a95c.akpm@linux-foundation.org>
	<45E9E910.2070804@redhat.com>
	<20070303140744.b22699dd.akpm@linux-foundation.org>
	<45E9F5DA.2070708@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2007 17:25:30 -0500 Rik van Riel <riel@redhat.com> wrote:

> Andrew Morton wrote:
> 
> > Well, backup programs are a unique case.  Let's say instead that the user
> > has just generated a 600MB ISO image.
> > 
> > The kernel *just doesn't know* whether the user will next try to read the
> > kernel tree or will next try to read that ISO image.
> > 
> > That, Rik, is my point, and is the entire point of this work.
> 
> I still don't understand why "the backup program flushed my data out
> of the cache with POSIX_FADV_DONTNEED" is an improvement over "the
> backup program flushed my data out of the cache by reading other files".

Oh.  Well, yes, if the user elected to instruct the backup program to
invalidate both its input files and its output files and if it's a full
dump, you end up with nothing in pagecache.  Possibly a more sensible
setting would be to invalidate only the output.

But having some batch program come in from the side and perform a bulk read
of your present working set isn't very common.

> Your code may be useful for a few specialized situations,

That's quite wrong.  It is useful for a great number of well-known problem
scenarios, all of which are *already "specialized situations".  It's *you*
who is chasing down the 1% scenarios and portraying them as general problems.
Backups only happen once in 24 hours, for example.

> but I don't
> see it actually fixing most of the examples you gave in your
> announcement, except for the DVD copying one.
> 

I don't know how much benefit it will provide for the updatedb problem - I
expect it'll help sometimes.  otoh maybe it'll worsen the existing slab internal
fragmentation problem, dunno.

But the other scenarios it solves completely and optimally.
