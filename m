Return-Path: <linux-kernel-owner+w=401wt.eu-S1760143AbZDBOlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143AbZDBOlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbZDBOlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:41:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43496 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbZDBOlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:41:39 -0400
Date: Thu, 2 Apr 2009 16:41:18 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Chris Wright <chrisw@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, riel@redhat.com, jeremy@goop.org, mtosatti@redhat.com,
       hugh@veritas.com, corbet@lwn.net, yaniv@redhat.com,
       dmonakhov@openvz.org
Subject: Re: [PATCH 5/4] update ksm userspace interfaces
Message-ID: <20090402144118.GH9137@random.random>
References: <49D22A9D.4050403@codemonkey.ws> <20090331150218.GS9137@random.random> <49D23224.9000903@codemonkey.ws> <20090331151845.GT9137@random.random> <49D23CD1.9090208@codemonkey.ws> <20090331162525.GU9137@random.random> <49D24A02.6070000@codemonkey.ws> <20090402012215.GE1117@x200.localdomain> <49D424AF.3090806@codemonkey.ws> <20090402053114.GF1117@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402053114.GF1117@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 10:31:14PM -0700, Chris Wright wrote:
>   - register only ATM, can add MADV_UNSHAREABLE to allow an app to proactively
>     unregister, but need a cleanup when ->mm goes away via exit/exec

The unregister cleanup must happen at the vma level (with unregister
when vma goes away or is overwritten) for this to provide sane madvise
semantics (not just in exit/exec, but in unmap/mmap too). Otherwise
this is all but madvise. Basically we need a chunk of code in core VM
when KSM=y/m, even if we keep returning -EINVAL when KSM=n (for
backwards compatibility, -ENOSYS not). Example, vma must be split in
two if you MAP_SHARABLE only part of it etc...
