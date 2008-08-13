Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbYHMVjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbYHMVjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 17:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYHMVjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 17:39:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:58597 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbYHMVjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 17:39:02 -0400
Date: Wed, 13 Aug 2008 14:39:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       andi@firstfloor.org, riel@redhat.com, greg@kroah.com, tytso@mit.edu,
       viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk, peterz@infradead.org,
       hch@infradead.org
Subject: Re: TALPA - a threat model?  well sorta.
Message-ID: <20080813143908.38796217@infradead.org>
In-Reply-To: <1218653864.3540.109.camel@localhost.localdomain>
References: <1218645375.3540.71.camel@localhost.localdomain>
	<20080813103951.1e3e5827@infradead.org>
	<1218653864.3540.109.camel@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 14:57:44 -0400
Eric Paris <eparis@redhat.com> wrote:

> > for the open() case, I would argue that you don't need synchronous
> > behavior as long as the read() case is synchronous. I can imagine
> > that open() kicks off an async scan, and if it's done by the time
> > the first read() happens, no blocking at all happens.
> 
> An interesting addition.  Trying to keep these queues of events gets
> much more complex, but if people really think the open to read race is
> that important I've always said it wasn't impossible to close.

it's not "just" about open-to-read race.
it's about open being non-blocking, and if read is not immediate, never
hitting the latency at all.

The real point is that "read" is the actual point  you want to
intercept, not "open" (you even wrote that in your description).. so
why not just do that ?
 The open case then is just a performance optimization.


> > Open questions now are
> > 4) do we have the kernel kick off an async scan in open() or do we
> > have glibc do this
> > 5) do we have the kernel do the sync scan on read/mmap/.. or do we
> > have glibc do this
> 
> scan on mmap read?  How do I implement this?  

on calling mmap(); not at fault time.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
