Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbXFKTzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbXFKTzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756731AbXFKTyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:54:54 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49538 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685AbXFKTyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:54:53 -0400
Subject: Re: [PATCH] shm: Fix the filename of hugetlb sysv shared memory
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serge@hallyn.com>,
       Albert Cahalan <acahalan@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       torvalds@linux-foundation.org
In-Reply-To: <20070611111111.2345470d.akpm@linux-foundation.org>
References: <787b0d920706062027s5a8fd35q752f8da5d446afc@mail.gmail.com>
	 <20070606204432.b670a7b1.akpm@linux-foundation.org>
	 <787b0d920706062153u7ad64179p1c4f3f663c3882f@mail.gmail.com>
	 <20070607162004.GA27802@vino.hallyn.com>
	 <m1ir9zrtwe.fsf@ebiederm.dsl.xmission.com> <46697EDA.9000209@us.ibm.com>
	 <m1vedyqaft.fsf_-_@ebiederm.dsl.xmission.com>
	 <20070611111111.2345470d.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 12:55:33 -0700
Message-Id: <1181591733.22665.5.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-11 at 11:11 -0700, Andrew Morton wrote:
> On Fri, 08 Jun 2007 17:43:34 -0600
> ebiederm@xmission.com (Eric W. Biederman) wrote:
> 
> > Some user space tools need to identify SYSV shared memory when
> > examining /proc/<pid>/maps.  To do so they look for a block device
> > with major zero, a dentry named SYSV<sysv key>, and having the minor of
> > the internal sysv shared memory kernel mount.
> > 
> > To help these tools and to make it easier for people just browsing
> > /proc/<pid>/maps this patch modifies hugetlb sysv shared memory to
> > use the SYSV<key> dentry naming convention.
> > 
> > User space tools will still have to be aware that hugetlb sysv
> > shared memory lives on a different internal kernel mount and so
> > has a different block device minor number from the rest of sysv
> > shared memory.
> 
> So..  I am sitting here believing that this patch and Badari's
> restore-shmid-as-inode-to-fix-proc-pid-maps-abi-breakage.patch are both
> needed in 2.6.22 and that they will fix all these issues up.
> 
> If that is untrue, someone please let us know..

Andrew,

My restore-shmid-as-inode-to-fix-proc-pid-maps-abi-breakage.patch is
definitely needed for 2.6.22 to fix ABI issue.

Eric's patch goes beyond and provides same naming convention for
hugetlbfs backed shm segs (which we never did in the past). So,
its not absolutely need for 2.6.22. You can queue up for next 
release,  unless Albert really wants to extend proc-ps utils for
hugetlbfs segments too.

But, its very simple patch - you might as well push this too.

Thanks,
Badari

