Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbZCaPTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbZCaPTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbZCaPTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:19:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37962 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbZCaPTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:19:00 -0400
Date: Tue, 31 Mar 2009 17:18:45 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       chrisw@redhat.com, riel@redhat.com, jeremy@goop.org,
       mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net, yaniv@redhat.com,
       dmonakhov@openvz.org
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
Message-ID: <20090331151845.GT9137@random.random>
References: <1238457560-7613-3-git-send-email-ieidus@redhat.com> <1238457560-7613-4-git-send-email-ieidus@redhat.com> <1238457560-7613-5-git-send-email-ieidus@redhat.com> <49D17C04.9070307@codemonkey.ws> <49D20B63.8020709@redhat.com> <49D21B33.4070406@codemonkey.ws> <20090331142533.GR9137@random.random> <49D22A9D.4050403@codemonkey.ws> <20090331150218.GS9137@random.random> <49D23224.9000903@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D23224.9000903@codemonkey.ws>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 10:09:24AM -0500, Anthony Liguori wrote:
> I don't think the registering of ram should be done via sysfs.  That would 
> be a pretty bad interface IMHO.  But I do think the functionality that 
> ksmctl provides along with the security issues I mentioned earlier really 
> suggest that there ought to be a separate API for control vs. registration 
> and that control API would make a lot of sense as a sysfs API.
>
> If you wanted to explore alternative APIs for registration, madvise() seems 
> like the obvious candidate to me.
>
> madvise(start, size, MADV_SHARABLE) seems like a pretty obvious API to me.

madvise to me would sound appropriate, only if ksm would be always-in,
which is not the case as it won't even be built if it's configured to
N.

Besides madvise is sus covered syscall, and this is linux specific detail.
