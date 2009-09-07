Return-Path: <linux-kernel-owner+w=401wt.eu-S1752294AbZIGW1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbZIGW1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 18:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZIGW1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 18:27:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbZIGW1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 18:27:19 -0400
Subject: Re: [PATCH 1/5] debugfs - Fix mount directory of debugfs by
 default in events.txt
From: Steven Rostedt <srostedt@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Peter Zijlstra <peterz@infradead.org>, leemgs1@gmail.com,
       linux-kernel <linux-kernel@vger.kernel.org>,
       mathieu.desnoyers@polymtl.ca, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20090907213047.GA28651@kroah.com>
References: <1252327037.2153.96.camel@centos51>
	 <1252327737.7959.22.camel@laptop> <20090907185513.GA27876@kroah.com>
	 <1252350914.7503.24.camel@twins>  <20090907213047.GA28651@kroah.com>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 07 Sep 2009 18:27:00 -0400
Message-Id: <1252362420.2964.53.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 14:30 -0700, Greg KH wrote:

> > 
> > From what people tell me it wasn't a clear consensus.
> 
> Specifics please.

Well I still avoid it. I've been broken into telling people publicly to
mount it in /sys/kernel/debug, but I've never done it myself.

> 
> > > So what is the problem?
> > 
> > Its not related to sysfs in any way I can discover,
> 
> So, other filesystems are mounted in sysfs, and in /proc for many years.
> 
> > its not consistent with most of the other virtual fs',
> 
> What do you mean by this?
> 
> > and its way too much typing.
> 
> tab completion is your friend, as is environment variables.  Don't
> choose stuff just because you are lazy :)

/sy <tab> k <tab> d <tab>

   or

/deb <tab>

I like the second one much better.

> 
> > we don't mount /dev, /proc, /sys in weird places either, so why should
> > we mount /debug in a cumbersome location.
> 
> Because it is a _kernel_ debug thing, not a system-level debug thing.
> What would userspace developers think about /debug ?  Why would they
> care about such a thing?
> 
> As much as we tend to ignore it, kernel developers are not the primary,
> or only, users of Linux :)

Actually this is a very good point. I think that the tracing system has
matured beyond a "debug" level and is being enabled on production
systems. Both fedora and debian are now shipping kernels with it
enabled. Perhaps we should create another pseudo fs that can be like
debugfs but for stable ABIs. A new interface could start out in debugfs,
but when it has reached a stable interface, then it could be moved to
another location to signal this.

/proc has been criticized for the pollution of non process related
information. This happened because there was no place else to place it.
Then came /sys which was suppose to take over this, but IMHO, it is too
over-engineered and too complex to use (I still stumble over kobjects).
I found that debugfs was a nice and simple interface to use. What about
creating a new fs that works like debugfs but is for stable interfaces
and can be mounted at root?

   /kernel?


-- Steve


