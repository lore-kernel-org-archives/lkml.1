Return-Path: <linux-kernel-owner+w=401wt.eu-S933864AbXGWXK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933864AbXGWXK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 19:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbXGWXKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 19:10:50 -0400
Received: from ozlabs.org ([203.10.76.45]:43397 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755466AbXGWXKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 19:10:49 -0400
Subject: Re: [kvm-devel] [RFC 0/8]KVM: swap out guest pages
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <46A4829C.9080104@qumranet.com>
References: <1185173489.2645.64.camel@sli10-conroe.sh.intel.com>
	 <46A4829C.9080104@qumranet.com>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 09:10:18 +1000
Message-Id: <1185232218.1803.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 13:27 +0300, Avi Kivity wrote:
> Having an address_space (like your patch does) is remarkably simple, and 
> requires few hooks from the current vm.  However using existing vmas 
> mapped by the user has many advantages:
> 
> - compatible with s390 requirements
> - allows the user to use hugetlbfs pages, which have a performance 
> advantage using ept/npt (but which are unswappable)
> - allows the user to map a file (which can be regarded as way to specify 
> the swap device)
> - better ingration with the rest of the vm

You don't need to expose the vmas.  You just have userspace point out
the start+len of each region of memory it wants the guest to be able to
access, and the address it wants it to appear in the guest.

This is a slight superset of what lguest does in two ways:

1) my guest address == user address, but I'm looking at adding an offset
so I don't have to link the launcher binary specially.
2) I have only one contiguous region of guest-physical memory, since I
can place device memory immediately above "normal" mem.

But the result is pretty sweet, and doesn't require any new symbols to
be exported.

Cheers,
Rusty.

