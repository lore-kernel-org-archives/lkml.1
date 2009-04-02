Return-Path: <linux-kernel-owner+w=401wt.eu-S1763632AbZDBPNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763632AbZDBPNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759150AbZDBPNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:13:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45901 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555AbZDBPNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:13:06 -0400
Date: Thu, 2 Apr 2009 08:12:51 -0700
From: Chris Wright <chrisw@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       riel@redhat.com, jeremy@goop.org, mtosatti@redhat.com, hugh@veritas.com,
       corbet@lwn.net, yaniv@redhat.com, dmonakhov@openvz.org
Subject: Re: [PATCH 5/4] update ksm userspace interfaces
Message-ID: <20090402151251.GA10392@x200.localdomain>
References: <20090331150218.GS9137@random.random> <49D23224.9000903@codemonkey.ws> <20090331151845.GT9137@random.random> <49D23CD1.9090208@codemonkey.ws> <20090331162525.GU9137@random.random> <49D24A02.6070000@codemonkey.ws> <20090402012215.GE1117@x200.localdomain> <49D424AF.3090806@codemonkey.ws> <20090402053114.GF1117@x200.localdomain> <20090402144118.GH9137@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402144118.GH9137@random.random>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrea Arcangeli (aarcange@redhat.com) wrote:
> On Wed, Apr 01, 2009 at 10:31:14PM -0700, Chris Wright wrote:
> >   - register only ATM, can add MADV_UNSHAREABLE to allow an app to proactively
> >     unregister, but need a cleanup when ->mm goes away via exit/exec
> 
> The unregister cleanup must happen at the vma level (with unregister
> when vma goes away or is overwritten) for this to provide sane madvise
> semantics (not just in exit/exec, but in unmap/mmap too). Otherwise
> this is all but madvise. Basically we need a chunk of code in core VM
> when KSM=y/m, even if we keep returning -EINVAL when KSM=n (for
> backwards compatibility, -ENOSYS not). Example, vma must be split in
> two if you MAP_SHARABLE only part of it etc...

Yes, of course.  I mentioned that (push whole thing into vma).
Current api is really at ->mm level, it's vma agnostic.  Simply put:
watch for pages in this ->mm between start and start+len and (more or
less regardless of the vma).  To do it purely at the vma level would
mean a vma unmap would cause the watch to go away.  So, question is...do
we need something in ->mm as well (like mlockall)?
