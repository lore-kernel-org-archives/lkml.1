Return-Path: <linux-kernel-owner+w=401wt.eu-S1760927AbZBLVvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbZBLVvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 16:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758227AbZBLVvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 16:51:36 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44710 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbZBLVvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 16:51:35 -0500
Subject: What can OpenVZ do?
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, containers@lists.linux-foundation.org,
       hpa@zytor.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, mingo@elte.hu,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <20090212114207.e1c2de82.akpm@linux-foundation.org>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
	 <1234285547.30155.6.camel@nimitz>
	 <20090211141434.dfa1d079.akpm@linux-foundation.org>
	 <1234462282.30155.171.camel@nimitz> <1234467035.3243.538.camel@calx>
	 <20090212114207.e1c2de82.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 13:51:23 -0800
Message-Id: <1234475483.30155.194.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 11:42 -0800, Andrew Morton wrote:
> On Thu, 12 Feb 2009 13:30:35 -0600
> Matt Mackall <mpm@selenic.com> wrote:
> 
> > On Thu, 2009-02-12 at 10:11 -0800, Dave Hansen wrote:
> > 
> > > > - In bullet-point form, what features are missing, and should be added?
> > > 
> > >  * support for more architectures than i386
> > >  * file descriptors:
> > >   * sockets (network, AF_UNIX, etc...)
> > >   * devices files
> > >   * shmfs, hugetlbfs
> > >   * epoll
> > >   * unlinked files
> > 
> > >  * Filesystem state
> > >   * contents of files
> > >   * mount tree for individual processes
> > >  * flock
> > >  * threads and sessions
> > >  * CPU and NUMA affinity
> > >  * sys_remap_file_pages()
> > 
> > I think the real questions is: where are the dragons hiding? Some of
> > these are known to be hard. And some of them are critical checkpointing
> > typical applications. If you have plans or theories for implementing all
> > of the above, then great. But this list doesn't really give any sense of
> > whether we should be scared of what lurks behind those doors.
> 
> How close has OpenVZ come to implementing all of this?  I think the
> implementatation is fairly complete?

I also believe it is "fairly complete".  At least able to be used
practically.

> If so, perhaps that can be used as a guide.  Will the planned feature
> have a similar design?  If not, how will it differ?  To what extent can
> we use that implementation as a tool for understanding what this new
> implementation will look like?

Yes, we can certainly use it as a guide.  However, there are some
barriers to being able to do that:

dave@nimitz:~/kernels/linux-2.6-openvz$ git diff v2.6.27.10... | diffstat | tail -1
 628 files changed, 59597 insertions(+), 2927 deletions(-)
dave@nimitz:~/kernels/linux-2.6-openvz$ git diff v2.6.27.10... | wc 
  84887  290855 2308745

Unfortunately, the git tree doesn't have that great of a history.  It
appears that the forward-ports are just applications of huge single
patches which then get committed into git.  This tree has also
historically contained a bunch of stuff not directly related to
checkpoint/restart like resource management.

We'd be idiots not to take a hard look at what has been done in OpenVZ.
But, for the time being, we have absolutely no shortage of things that
we know are important and know have to be done.  Our largest problem is
not finding things to do, but is our large out-of-tree patch that is
growing by the day. :(

-- Dave

