Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbXKJTnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbXKJTnv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 14:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbXKJTnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 14:43:43 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57693 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152AbXKJTnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 14:43:43 -0500
Date: Sat, 10 Nov 2007 11:43:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 5/6] MN10300: Add the MN10300/AM33 architecture to the
 kernel [try #5]
Message-Id: <20071110114320.1fa6e94c.akpm@linux-foundation.org>
In-Reply-To: <24343.1194697130@redhat.com>
References: <20071109195303.edbdc631.akpm@linux-foundation.org>
	<20071109153432.20803.69832.stgit@warthog.procyon.org.uk>
	<20071109153458.20803.10594.stgit@warthog.procyon.org.uk>
	<24343.1194697130@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Nov 2007 12:18:50 +0000 David Howells <dhowells@redhat.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > ho hum, I've seen worse-looking code ;).  There's quite a bit of the usual
> > stuff in there: use of SPIN_LOCK_UNLOCKED, a forest of fishy-looking
> > volatiles
> 
> The vast majority of which are either memory-mapped hardware registers or
> interrupt-routine-filled ring buffers.

So?  Those are very common things and most drivers don't resort to
`volatile' to access them.

> > but I don't need to sit here and emulate checkpatch.pl.
> 
> No, it should be deleted:
> 
> 	shred -fu scripts/checkpatch.pl
> 
> will do the trick quite nicely.

checkpatch is quite accurate now - Ingo has been following this quite
carefully.

If you were to use it there would be improvements in the exceptionally high
number of mistakes in your patches.

> | WARNING: do not add new typedefs
> | #27265: FILE: include/asm-mn10300/types.h:30:
> | +typedef unsigned int __u32;
> 
> Pah!

Bug reports against checkpath should be sent to apw, not used as an excuse
to put incorrectly laid-out code into the kernel and for increasing my
workload.

> > I googled a bit but most of the mn10300 info pertains to linux kernel and
> > gcc.  Who is using this CPU and in what applications?
> 
> This CPU is MEI/Matsushita/Panasonic's own CPU.  If you've bought a Panasonic
> telly, say, in the last few years, the odds are rather good that it's got one
> of these CPUs in it running Linux.

How did you know I had a Panasonic flat screen? ;)

> 	http://www.am-linux.jp/
> 
> has a couple of examples on it's front page.  If you work through the menus of
> modern Panasonic tellies, you might find a URL pointing somewhere on this
> website that isn't reachable by linking from the index page of the website.
> 
> I don't know who else uses this CPU, but it's possible MEI sell them to other
> companies.
> 

If it is indeed the case that this architecture is used internally by a
single organisation then perhaps it doesn't make sense for us to merge it.

One of the main reasons we put code into the kernel is as a means of
distribution: to get it into the hands of people who need it.  But in this
situation there is no advantage to *anyone* from this merge apart from MEI.

IOW, the submitter gains and everyone else loses.  It's a curious situation.

I guess if it were possible to install a self-built kernel into a Panasonic
gadget then we could look at it on that basis.  Do you know if that's the
case?
