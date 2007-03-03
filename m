Return-Path: <linux-kernel-owner+w=401wt.eu-S1750767AbXCCXhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750767AbXCCXhz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 18:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbXCCXhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 18:37:54 -0500
Received: from codepoet.org ([166.70.99.138]:48786 "EHLO codepoet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbXCCXhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 18:37:54 -0500
X-Greylist: delayed 1878 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Mar 2007 18:37:54 EST
Date: Sat, 3 Mar 2007 15:56:01 -0700
From: Erik Andersen <andersen@codepoet.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, bert hubert <bert.hubert@netherlabs.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-ID: <20070303225601.GA15579@codepoet.org>
Reply-To: andersen@codepoet.org
Mail-Followup-To: andersen@codepoet.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@redhat.com>,
	bert hubert <bert.hubert@netherlabs.nl>,
	linux-kernel@vger.kernel.org
References: <20070303122935.f1ab0067.akpm@linux-foundation.org> <45E9DD4A.2060806@redhat.com> <20070303131204.6706a95c.akpm@linux-foundation.org> <45E9E910.2070804@redhat.com> <20070303214108.GA28961@outpost.ds9a.nl> <20070303141448.1ed70e6d.akpm@linux-foundation.org> <45E9F454.2080600@redhat.com> <20070303142609.d3bc9cc3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070303142609.d3bc9cc3.akpm@linux-foundation.org>
X-No-Junk-Mail: I do not want to get *any* junk mail.
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat Mar 03, 2007 at 02:26:09PM -0800, Andrew Morton wrote:
> On Sat, 03 Mar 2007 17:19:00 -0500 Rik van Riel <riel@redhat.com> wrote:
> 
> > > It is *not* a global instruction.  It uses setenv, so the user's policy
> > > affects only the target process and its forked children.
> > 
> > ... and all other processes accessing the same file(s)!
> > 
> > Your library and the system calls may be limited to one process,
> > but the consequences are global.
> 
> Yes.  So what?  If the user wants to go and evict libc.so from pagecache
> then he can do so - the kernel has provided syscalls with which this can be
> done for at least seven years.  Bad user, shouldn't do that.

I think what Rik is pointing out is that as currently
implemented, posix_fadvise is a much bigger hammer than is
generally useful or desirable.

Using posix_fadvise on the other hand says "immediately drop this
stuff from the pagecache, consequences be damned".  If someone
else happens to be using the specified data, well too bad, they
suffer collateral damage.  Process A can, maliciously or
ignorantly, deny service to process B.

On the other hand, your old but super cool O_STREAMING patch took
a kinder gentler approach, where applications could tell the
kernel "please do not keep this file descriptor's data in cache
on my account since I will not reuse it." If someone else however
was using the same data, the kernel would keep things cached as
usual and thereby avoid doing collateral damage.

 -Erik

--
Erik B. Andersen             http://codepoet-consulting.com/
--This message was written using 73% post-consumer electrons--
