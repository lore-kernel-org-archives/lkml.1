Return-Path: <linux-kernel-owner+w=401wt.eu-S1760473AbZFLCBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760473AbZFLCBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 22:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZFLCBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 22:01:31 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:26890 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbZFLCBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 22:01:31 -0400
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jun 2009 22:01:30 EDT
X-SpamScore: -41
X-BigFish: VPS-41(zz1432R62a3L98dR936eN1805M179dN1442J10d1Izz1202hzzz32i17ch6bh43j)
X-FB-SS: 5,13,
X-WSS-ID: 0KL3RKT-01-VQP-01
Date: Fri, 12 Jun 2009 03:43:47 +0200
From: Robert Richter <robert.richter@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Newall <davidn@davidnewall.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-ID: <20090612014346.GG3226@erda.amd.com>
References: <84144f020906111059g6e25a090y4434cfd698f84fb4@mail.gmail.com> <4A3148AA.9000007@davidnewall.com> <alpine.LFD.2.01.0906111120100.3573@localhost.localdomain> <4A314F37.2080202@davidnewall.com> <alpine.LFD.2.01.0906111142390.3573@localhost.localdomain> <4A3155E3.3030603@davidnewall.com> <alpine.LFD.2.01.0906111223250.3573@localhost.localdomain> <alpine.LFD.2.01.0906111226130.3573@localhost.localdomain> <4A315C9F.8050908@davidnewall.com> <alpine.LFD.2.01.0906111247270.3535@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906111247270.3535@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Jun 2009 01:43:48.0578 (UTC) FILETIME=[3B185420:01C9EAFF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.06.09 12:49:25, Linus Torvalds wrote:
> 
> 
> On Fri, 12 Jun 2009, David Newall wrote:
> 
> > Linus Torvalds wrote:
> > > To take the oprofile example that decided it for me: the code to actually 
> > > support new processors was all done by basically kernel developers. And it 
> > > didn't hit user land for almost a year, because the user-land tools didn't 
> > > take the patch and propagate it up.
> > 
> > Bad developer, Spot, you only did half the job. Not sure there's much
> > more one can say.
> 
> Umm. The kernel developer _did_ do the job. The patch to the user land 
> side was available for that whole year. It just didn't get merged, and 
> then didn't get merged some more, and then got merged but only in a SVN 
> tree, not a release, and then finally when I did a bugzilla request to 
> fedora, they took the patch and put it in their distro.

Having the oprofile user land in the kernel would not solve the
problem. Then you would have code in the kernel tree you actually
don't wont there: XML encoder, autoconf scripts, graphical tools, c++
code, man page docs, etc., and maybe different coding style.

The problem is another one. First, as Christoph mentioned, it is a
design problem of oprofile. Changes in the kernel require user land
changes. This could be done better, but everybody knows it is hard to
change the user/kernel i/f and maybe, keep backward compatibility
too. So this is not easy to fix.

Second, there are different users with different expectations. (Linus,
I suggest oprofile has one user less, hmm...) Some run the latest
kernel on the latest systems, others use it in their clusters using
stable, not often changing well tested releases and hardware. If a
user land release aims more the seconds, it must conflict with the
others. Also, being in sync with the kernel would require release
cycles as for the kernel, which was the problem here with oprofile.

But, user land patches exist, even at the day of the kernel
release. Otherwise the code would have been badly or not tested. And
the patches are also in a repository, _somewhere_. This, was true for
oprofile too, the patches were in cvs at least on the day the kernel
was released. (I think a git repository would be nicer, but that's a
different question.) And this is the next problem, the patches are
somewhere, sometimes not under control of the kernel developer. And
this could be best solved if the kernel developer who brings the
kernel code upstream maintains a user land repository at
git.kernel.org.  (Marcel already suggested this too.) There could be
all patches in required to run the latest kernel, based on the latest
user land release. (You can blame then the kernel maintainer, if
something does not work.) And of course the user is required then to
compile the user land himself, as he does for the kernel. And maybe,
distros pick up the patches too when adding a new kernel to it.

So, I think this would be much nicer than having a user land in the
kernel tree. And this would also solve the problems with the oprofile
user land.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

