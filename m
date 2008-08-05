Return-Path: <linux-kernel-owner+w=401wt.eu-S1764090AbYHEAyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764090AbYHEAyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 20:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759066AbYHEAyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 20:54:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55673 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763450AbYHEAyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 20:54:17 -0400
Date: Mon, 4 Aug 2008 20:54:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>,
       malware-list@lists.printk.net, linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
Message-ID: <20080805005415.GA10108@infradead.org>
References: <1217883616.27684.19.camel@localhost.localdomain> <20080804223249.GA10517@kroah.com> <20080805002618.GA18215@infradead.org> <1217897224.27684.66.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217897224.27684.66.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 08:47:04PM -0400, Eric Paris wrote:
> On Mon, 2008-08-04 at 20:26 -0400, Christoph Hellwig wrote:
> > On Mon, Aug 04, 2008 at 03:32:49PM -0700, Greg KH wrote:
> > > >   1. Intercept file opens (exec also) for vetting (block until
> > > >   decision is made) and allow some userspace black magic to make
> > > >   decisions.
> > 
> > NACK, this kind of policy should be done in kernelspace.
> 
> What?  You want to write and in kernel scanner for Window viruses?

No, I want a sane security policy in kernelsapce that doesn't look
at the content because doing security by content properly is equivalent
to solving the halting problem.  I couldn't give a rats a** about
windows viruses as they can't actually cause any harm on a Linux
machine.

> > 
> > > >   6. Scan files directly not relying on path.  Avoid races and problems with namespaces, chroot, containers, etc.
> > 
> > Explain? 
> 
> The data connected with the file being opened must as reasonably as
> possible be the data the 'scanner' looks at.  Some foolish early
> discussion wanted to do simplistic things like pass a pathname to a
> scanner and have it call open on that path name.  I'm willing to
> entertain any other method of making the scanner look at the data the
> process is about to get.

Well, data can change all the time, as can the path name.  This whole
content scanning thing doesn't make any sense at all.

> > > >   9. Mark a processes as exempt from on access scanning
> > 
> > Nack, this completely defeats the purpose.
> 
> What? it allows a process to open a file that contains malware, how is
> that horrible.  If a process says "I want to see malware" it can then
> see malware.  Doesn't in any way affect other processes or the system
> security as a whole.  If 'bad' data gets into a file its going to get
> blocked from everything that doesn't actively choose to see it.

So make this opt-in and in userspace.  Just LD_PRELOAD some monster lib
doing all the horrible things you propose and use it wherever you want.

