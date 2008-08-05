Return-Path: <linux-kernel-owner+w=401wt.eu-S1764702AbYHEUcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764702AbYHEUcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758917AbYHEUc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:32:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:55025 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421AbYHEUc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:32:26 -0400
Date: Tue, 5 Aug 2008 13:30:07 -0700
From: Greg KH <greg@kroah.com>
To: Eric Paris <eparis@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
Message-ID: <20080805203007.GB27489@kroah.com>
References: <1217883616.27684.19.camel@localhost.localdomain> <20080804223249.GA10517@kroah.com> <1217896374.27684.53.camel@localhost.localdomain> <20080805005132.GA3661@kroah.com> <20080805122328.69a37c1d@lxorguk.ukuu.org.uk> <20080805170307.GB9639@kroah.com> <1217962602.27684.144.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217962602.27684.144.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 02:56:42PM -0400, Eric Paris wrote:
> On Tue, 2008-08-05 at 10:03 -0700, Greg KH wrote:
> > On Tue, Aug 05, 2008 at 12:23:28PM +0100, Alan Cox wrote:
> > > > > It may be possible to do in glibc, LD_PRELOAD doesn't exactly work for
> > > > > suid binaries
> > > > 
> > > > Are suid binaries something that you feel is necessary to scan from?
> > > > 
> > > > I don't see it on the list above :)
> > > 
> > > Doesn't work very well really does it - ld.so loads files too and can be
> > > attacked.
> > 
> > But that's an "attack" vector, which virus scanners are not addressing.
> > They are going for the "is this file corrupted" type issue.  The
> > "normal" LSM interface is for malware itself, taking control of a
> > system.
> 
> So you are arguing against the defense in depth theory?  LSM should
> solve it all so why bother?

No, I am saying I have yet to see a real requirement to justify that
this code goes into the kernel.

Your list shows no such requirement, in fact it overlaps with some
things that LSM already provides.  So why not just make it an LSM and be
done with it?

Oh wait, this is a commercial add-on for vendor kernels that already
have an LSM built in, that will not work.

Is that really the community's issue?  :)

> I don't think that anyone is claiming that they don't address that
> vector.  They may not be perfect but they are infinitely better than the
> zero protection we offer today.  Clearly in the enterprise world the
> most useful purpose of these scanners is looking at inflight data
> crossing valid safe non-hacked linux processes, but the implementation I
> have given is such that we can start doing some validation on our own
> executables.  Remember the requirement wasn't just to scan data, it was
> to scan everything that gets opened.

/me points at a fixed inotify.

> As an example of the usefulness of this approach as opposed to the
> LD_PRELOAD/glibc approach is that I could be used to minimize the impact
> of things like the recently much touted discussion about malicious
> repository mirrors.  Although clearly there were some flaws in the
> common conception of the problem, the ability to trick users into
> downloading and installing trojaned libraries is not something we can
> presently protect against with any mechanism.

Exactly, so don't try to bring it up when it does not even pertain here.

> Lets assume that the black magic in userspace was able to spot a
> trojaned library running programs which would still be linked to the old
> files on disk would continue to work but you would very quickly find out
> there was trouble when everything that tried to open its shared library
> was getting EPERM.

But that's not what virus scanners on Linux do!  So again, don't bring
up things that are outside the threat model!

> I'm going to run perf test this afternoon but I'm going to have to look
> for a test that is a good mix of reads,writes, and opens.  I strongly
> suspect that there will be a noticable perf lose in any other method
> that doesn't include in kernel caching.  (how can there not be with an
> extra context switch for every open?)

See my earlier comments about this.

thanks,

greg k-h
