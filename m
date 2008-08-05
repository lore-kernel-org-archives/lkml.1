Return-Path: <linux-kernel-owner+w=401wt.eu-S1762103AbYHEArT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762103AbYHEArT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 20:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbYHEArL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 20:47:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803AbYHEArK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 20:47:10 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
From: Eric Paris <eparis@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Greg KH <greg@kroah.com>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080805002618.GA18215@infradead.org>
References: <1217883616.27684.19.camel@localhost.localdomain>
	 <20080804223249.GA10517@kroah.com>  <20080805002618.GA18215@infradead.org>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 20:47:04 -0400
Message-Id: <1217897224.27684.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 20:26 -0400, Christoph Hellwig wrote:
> On Mon, Aug 04, 2008 at 03:32:49PM -0700, Greg KH wrote:
> > >   1. Intercept file opens (exec also) for vetting (block until
> > >   decision is made) and allow some userspace black magic to make
> > >   decisions.
> 
> NACK, this kind of policy should be done in kernelspace.

What?  You want to write and in kernel scanner for Window viruses?

> 
> > >   2. Intercept file closes for scanning post access
> 
> Not  even possible for mmap, and dumb otherwise, NACK.

I don't know when files get closed and can't preemptively scan to make
sure it is clean for the next open?  Any writes are going to invalidate
the allow/deny cache....

> 
> > >   6. Scan files directly not relying on path.  Avoid races and problems with namespaces, chroot, containers, etc.
> 
> Explain? 

The data connected with the file being opened must as reasonably as
possible be the data the 'scanner' looks at.  Some foolish early
discussion wanted to do simplistic things like pass a pathname to a
scanner and have it call open on that path name.  I'm willing to
entertain any other method of making the scanner look at the data the
process is about to get.

> 
> > >   9. Mark a processes as exempt from on access scanning
> 
> Nack, this completely defeats the purpose.

What? it allows a process to open a file that contains malware, how is
that horrible.  If a process says "I want to see malware" it can then
see malware.  Doesn't in any way affect other processes or the system
security as a whole.  If 'bad' data gets into a file its going to get
blocked from everything that doesn't actively choose to see it.

> 
> > >  11. Exclude sub-trees from scanning based on filesystem path
> > >  12. Include only certain sub-trees from scanning based on filesystem path
> 
> Nack, please no pathname based idiocies.

Go read the long explainations, I already rules out path based
inclusions.  I'm leaving exclusions up for grabs since I don't see it
weakening the security model.

