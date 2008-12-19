Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbYLSMfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbYLSMfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 07:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYLSMfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 07:35:04 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:48322 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbYLSMfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 07:35:03 -0500
Subject: Re: Pull request for FS-Cache, including NFS patches
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       sfr@canb.auug.org.au, steved@redhat.com, rwheeler@redhat.com,
       bfields@fieldses.org, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20081218184443.d73f5431.akpm@linux-foundation.org>
References: <20081218123601.11810b7f.akpm@linux-foundation.org>
	 <8930.1229560221@redhat.com> <20081218224418.804f10bc.sfr@canb.auug.org.au>
	 <20081218142420.GA16728@infradead.org> <7633.1229653644@redhat.com>
	 <20081218184443.d73f5431.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 19 Dec 2008 07:33:56 -0500
Message-Id: <1229690036.7789.113.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: F1D1BF84FB1EEA915C9F5F2BF94E5CA4E470D504
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 283 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-18 at 18:44 -0800, Andrew Morton wrote:
> On Fri, 19 Dec 2008 02:27:24 +0000 David Howells <dhowells@redhat.com> wrote:
> 
> > > Are any distros pushing for this?  Or shipping it?  If so, are they
> > > able to weigh in and help us with this quite difficult decision?
> > 
> > We (Red Hat) have shipped it in RHEL-5 and some Fedora releases.  Doing so is
> > quite an effort, though, precisely because the code is not yet upstream.  We
> > have customers using it and are gaining more customers who want it.  There
> > even appear to be CentOS users using it (or at least complaining when it
> > breaks).
> 
> That's useful news.
> 
> > 
> > I don't know what will convince you.  I've given you theoretical reasons why
> > caching ought to be useful; I've backed up the ones I've implemented with
> > benchmarks; I've given you examples of what our customers are doing with it or
> > want to do with it.
> 
> Was that information captured/maintained somewhere?  It really is important (I
> think) for something of this magnitude.
> 
> > Please help me understand what else you want.
> 
> I want to be able to have an answer when someone asks me "why was all that
> stuff merged".  One which I can believe.
> 
> > Do you perhaps want the netfs maintainers (such as Trond) to say that it's
> > necessary?
> 
> Of course, their opinions (and supporting explanations) would be valuable.

OK. I do agree that persistent caches can be (sometimes very!) useful
for certain workloads. As far as I'm concerned, it is mainly a tool to
help scale up the number of clients per server.

One interesting use case that I didn't see David mention is for cluster
boot up. In a lot of the HPC clustered set-ups there tend be a number of
'hot' files that all clients need to access at roughly the same time in
the boot cycle. Pre-loading these files into the persistent cache before
booting the cluster is one way to solve this problem. Server replication
and/or copying the files to local storage on the clients are other
solutions.
The advantage the persistent cache confers over the two other solutions
is that it simplifies the data management: if you do need to change one
or two of those hot files on the server, then the clients will
automatically update their caches (both the page cache and the
persistent cache) without requiring any further action from the cluster
administrator. The disadvantage is that cachefs doesn't yet appear to
have a tool to select those files that are hot and are therefore best
suited to cache (please correct me if I'm wrong, David). The fact that a
file is 'hot' on some given client is not necessarily equivalent to
saying that it is hot on the server and vice versa. Are there any plans
to at some point introduce a tool to manage the persistent cache?

Cheers
  Trond

