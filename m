Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbXCXGMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbXCXGMn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 02:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbXCXGMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 02:12:43 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56561 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbXCXGMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 02:12:42 -0400
Date: Fri, 23 Mar 2007 22:12:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Nish Aravamudan" <nish.aravamudan@gmail.com>
Cc: "Ken Chen" <kenchen@google.com>, "Adam Litke" <agl@us.ibm.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Christoph Hellwig" <hch@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] rfc: introduce /dev/hugetlb
Message-Id: <20070323221225.bdadae16.akpm@linux-foundation.org>
In-Reply-To: <29495f1d0703232232o3e436c62lddccc82c4dd17b51@mail.gmail.com>
References: <b040c32a0703230144r635d7902g2c36ecd7f412be31@mail.gmail.com>
	<20070323205810.3860886d.akpm@linux-foundation.org>
	<29495f1d0703232232o3e436c62lddccc82c4dd17b51@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007 22:32:31 -0700 "Nish Aravamudan" <nish.aravamudan@gmail.com> wrote:

> > Probably the kernel team should be maintaining, via existing processes, a
> > separate libkernel project, to fix these distributional problems.  The
> > advantage in this case is of course that our new hugetlb functionality
> > would be available to people on 2.6.18 kernels, not only on 2.6.22 and
> > later.
> 
> That sounds like a good idea. For this hugetlb stuff, though, I plan
> on simply taking advantage of /dev/hugetlb (or whatever it is called)
> if it exists, and otherwise falling back to hugetlbfs (which
> admittedly requires some admin intervention (mounting hugetlbfs,
> permissions, and such), but then again, so does using hugepages in the
> first place (either at boot-time or via /proc/sys/vm/nr_hugepages)).
> Is that what you mean by available to 2.6.18 (falling back to
> hugetlbfs) and 2.6.22 (using the chardev)?

My point is:

a) Ken observes that obtaining private hugetlb memory via hugetlbfs
   involves "fuss".

b) the libhugetlbfs maintainers then go off and implement a no-fuss way of
   doing this.

c) voila, people can now use the new no-fuss interface on older kernels.
   Whereas Ken's kernel patch would require that they upgrade to a new
   kernel.

It wasn't a vary big point ;) I'm assuming that users find that upgrading
libhugetlb is less costly than upgrading their kernel.


> > Am I wrong?
> 
> I don't think so. And hugepages are hard enough to use (and with
> enough architecture specific quirks) that it was worth creating
> libhugetlbfs. While having some nice features like segment remapping
> and overriding malloc, it is also meant to provide an API that is
> useful for general use of hugepages: we currently export
> gethugepagesize(), hugetlbfs_test_path() (verify a path is a valid
> hugetlbfs mount), hugetlbfs_find_path() (gives you the hugetlbfs
> mount) and hugetlbfs_unlinked_fd() (gives you an unlinked file in the
> hugetlbfs mount).
> 
> Then again, maybe I'm missing some much bigger picture here and you
> meant something completely different -- sorry for the noise in that
> case :/

You got it.

The fact that a kernel interface is "hard to use" really shouldn't be an
issue for us, because that hardness can be addressed in libraries.  Kernel
interfaces should be good, and complete, and maintainable, and etcetera. 
If that means that they end up hard to use, well, that's not necessarily a
bad thing.  I'm not sure that in all cases we want to be optimising for
ease-of-use just because libraries-are-hard.


But for non-programming reasons, we're just not there yet: people want to
program direct to the kernel interfaces simply because of the
distribution/coordination problems with libraries.  It would be nice to fix
that problem.


For a counter-example, look at futexes.  Their kernel interfaces are
*damned* hard to use.  But practically nobody is affected by that because
glibc solved the problem and programmers just use the pthread API.

More of this, please ;)

