Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbYHNP5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbYHNP5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYHNP5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:57:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:38359 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYHNP5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:57:31 -0400
Date: Thu, 14 Aug 2008 08:57:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       andi@firstfloor.org, riel@redhat.com, greg@kroah.com, tytso@mit.edu,
       viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk, peterz@infradead.org,
       hch@infradead.org
Subject: Re: TALPA - a threat model?  well sorta.
Message-ID: <20080814085740.35b32633@infradead.org>
In-Reply-To: <1218723133.3540.137.camel@localhost.localdomain>
References: <1218645375.3540.71.camel@localhost.localdomain>
	<20080813103951.1e3e5827@infradead.org>
	<1218653864.3540.109.camel@localhost.localdomain>
	<20080813143908.38796217@infradead.org>
	<1218723133.3540.137.camel@localhost.localdomain>
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

On Thu, 14 Aug 2008 10:12:13 -0400
Eric Paris <eparis@redhat.com> wrote:

> On Wed, 2008-08-13 at 14:39 -0700, Arjan van de Ven wrote:
> > On Wed, 13 Aug 2008 14:57:44 -0400
> > Eric Paris <eparis@redhat.com> wrote:
> > 
> > > > for the open() case, I would argue that you don't need
> > > > synchronous behavior as long as the read() case is synchronous.
> > > > I can imagine that open() kicks off an async scan, and if it's
> > > > done by the time the first read() happens, no blocking at all
> > > > happens.
> > > 
> > > An interesting addition.  Trying to keep these queues of events
> > > gets much more complex, but if people really think the open to
> > > read race is that important I've always said it wasn't impossible
> > > to close.
> > 
> > it's not "just" about open-to-read race.
> > it's about open being non-blocking, and if read is not immediate,
> > never hitting the latency at all.
> > 
> > The real point is that "read" is the actual point  you want to
> > intercept, not "open" (you even wrote that in your description).. so
> > why not just do that ?
> >  The open case then is just a performance optimization.
> 
> I've been thinking about this more over night.  I really like the idea
> for perf reasons but I'm scared of programs not expecting and thus
> poorly handling -EACCESS from read.  Every program ever is going to
> expect that back from open, but once you have the fd open its not
> common.  

you could stretch things and report -EIO.

> 
> The idea of multiple concurrent outstanding async notifications is
> going to be much more difficult to code, but hey, who am I to

well... do you really need a response?
you could just write it to a netlink socket...

> complain.  We could have outstanding async scanning requests for any
> number of writes, any number of closes, and any number of opens all
> at the same time.  The current interface believes that every request
> out requires a response but this type of interface basically requires
> some sort of coalescing.

or fire-and-forget.
> 
> Would you be opposed to a first patch round that did blocking
> enforcement on open like we have today and do sync scanning (blocking
> or return EWOULDBLOCK) on read if needed due to concurrent writes?

I think we need to sort the interface issue on this for sure, and
probably from the start...

> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
