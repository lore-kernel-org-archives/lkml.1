Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbYL2XF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbYL2XF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 18:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbYL2XFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 18:05:13 -0500
Received: from mx2.netapp.com ([216.240.18.37]:29705 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbYL2XFL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 18:05:11 -0500
X-IronPort-AV: E=Sophos;i="4.36,297,1228118400"; 
   d="scan'208";a="105473711"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Pull request for FS-Cache, including NFS patches
Date: Mon, 29 Dec 2008 15:05:06 -0800
Message-ID: <7A24DF798E223B4C9864E8F92E8C93EC01AAFE24@SACMVEXC1-PRD.hq.netapp.com>
In-Reply-To: <1230561056.7046.47.camel@heimdal.trondhjem.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Pull request for FS-Cache, including NFS patches
Thread-Index: AclpwiPWgqGwhFK7Q2SXCzGoDIsQcgAPe0dA
From: "Muntz, Daniel" <Dan.Muntz@netapp.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Bernd Schubert" <bernd.schubert@fastmail.fm>, <nfsv4@linux-nfs.org>,
       <linux-kernel@vger.kernel.org>, <steved@redhat.com>,
       <dhowells@redhat.com>, <linux-next@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>, <rwheeler@redhat.com>
X-OriginalArrivalTime: 29 Dec 2008 23:05:08.0402 (UTC) FILETIME=[E4E1C120:01C96A09]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before throwing the 'FUD' acronym around, maybe you should re-read the
details.  My point was that there were few users of cachefs even when
the technology had the potential for greater benefit (slower networks,
less powerful servers, smaller memory caches).  Obviously cachefs can
improve performance--it's simply a function of workload and the
assumptions made about server/disk/network bandwidth.  However, I would
expect the real benefits and real beneficiaries to be fewer than in the
past.  HOWEVER^2 I did provide some argument(s) in favor of adding
cachefs, and look forward to extensions to support delayed write,
offline operation, and NFSv4 support with real consistency checking (as
long as I don't have to take the customer calls ;-).  BTW,
animation/video shops were one group that did benefit, and I imagine
they still could today (the one I had in mind did work across Britain,
the US, and Asia and relied on cachefs for overcoming slow network
connections).  Wonder if the same company is a RH customer...

All the comparisons to HTTP browser implementations are, imho, absurd.
It's fine to keep a bunch of http data around on disk because a) it's RO
data, b) correctness is not terribly important, and c) a human is
generally the consumer and can manually request non-cached data if
things look wonky.  It is a trivial case of caching.

As for security, look at what MIT had to do to prevent local disk
caching from breaking the security guarantees of AFS.

Customers (deluded or otherwise) are still customers.  No one is forced
to compile it into their kernel.  Ship it.

  -Dan


-----Original Message-----
From: Trond Myklebust [mailto:trond.myklebust@fys.uio.no] 
Sent: Monday, December 29, 2008 6:31 AM
To: Andrew Morton
Cc: Stephen Rothwell; Bernd Schubert; nfsv4@linux-nfs.org;
linux-kernel@vger.kernel.org; steved@redhat.com; dhowells@redhat.com;
linux-next@vger.kernel.org; linux-fsdevel@vger.kernel.org;
rwheeler@redhat.com
Subject: Re: Pull request for FS-Cache, including NFS patches

On Sun, 2008-12-28 at 20:01 -0800, Andrew Morton wrote:
> On Mon, 29 Dec 2008 14:45:33 +1100 Stephen Rothwell
<sfr@canb.auug.org.au> wrote:
> 
> > Hi David,
> > 
> > On Fri, 19 Dec 2008 11:05:39 +1100 Stephen Rothwell
<sfr@canb.auug.org.au> wrote:
> > >
> > > Given the ongoing discussions around FS-Cache, I have removed it 
> > > from linux-next.  Please ask me to include it again (if sensible) 
> > > once some decision has been reached about its future.
> > 
> > What was the result of discussions around FS-Cache?
> 
> There was none.
> 
> Dan Muntz's question:
> 
>   Solaris has had CacheFS since ~1995, HPUX had a port of it since
>   ~1997.  I'd be interested in evidence of even a small fraction of
>   Solaris and/or HPUX shops using CacheFS.  I am aware of customers
who
>   thought it sounded like a good idea, but ended up ditching it for
>   various reasons (e.g., CacheFS just adds overhead if you almost
>   always hit your local mem cache).
> 
> was an very very good one.
> 
> Seems that instead of answering it, we've decided to investigate the 
> fate of those who do not learn from history.

David has given you plenty of arguments for why it helps scale the
server (including specific workloads), has given you numbers validating
his claim, and has presented claims that Red Hat has customers using
cachefs in RHEL-5.
The arguments I've seen against it, have so far been:

     1. Solaris couldn't sell their implementation
     2. It's too big
     3. It's intrusive

Argument (1) has so far appeared to be pure FUD. In order to discuss the
lessons of history, you need to first do the work of analysing and
understanding it first. I really don't see how it is relevant to Linux
whether or not the Solaris and HPUX cachefs implementations worked out
unless you can demonstrate that that their experience shows some fatal
flaw in the arguments and numbers that David presented, and that his
customers are deluded.
If you want examples of permanent caches that clearly do help servers
scale, then look no further than the on-disk caches used in almost all
http browser implemantations. Alternatively, as David mentioned, there
are the on-disk caches used by AFS/DFS/coda.

(2) may be valid, but I have yet to see specifics for where you'd like
to see the cachefs code slimmed down. Did I miss them?

(3) was certainly true 3 years ago, when the code was first presented
for review, and so we did a review and critique then. The NFS specific
changes have improved greatly as a result, and as far as I know, the
security folks are happy too. If you're not happy with the parts that
affect the memory management code then, again, it would be useful to see
specifics that what you want changed.

If there is still controversy concerning this, then I can temporarily
remove cachefs from the nfs linux-next branch, but I'm definitely
keeping it in the linux-mm branch until someone gives me a reason for
why it shouldn't be merged in its current state.

Trond

_______________________________________________
NFSv4 mailing list
NFSv4@linux-nfs.org
http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4
