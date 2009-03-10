Return-Path: <linux-kernel-owner+w=401wt.eu-S1757067AbZCJRnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbZCJRnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbZCJRng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:43:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:22293 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569AbZCJRng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:43:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,336,1233561600"; 
   d="scan'208";a="118784068"
Subject: Re: 2.6.29 pat issue
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <49B6232B.4050503@vmware.com>
References: <498ADFE3.9020907@vmware.com>
	 <1233856988.4286.83.camel@localhost.localdomain>
	 <498B5ADE.3090602@vmware.com> <m1tz78pdwy.fsf@fess.ebiederm.org>
	 <498C062C.201@vmware.com> <20090304060857.GA18318@linux-os.sc.intel.com>
	 <130CA3A191875048A0624FB523A55EC7075DA7CA@PA-EXMBX51.vmware.com>
	 <20090310013953.GA11312@linux-os.sc.intel.com>
	 <49B6232B.4050503@vmware.com>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 10:42:39 -0700
Message-Id: <1236706959.4529.56.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 01:22 -0700, Thomas Hellstrom wrote:
> Pallipadi, Venkatesh wrote:
> > On Fri, Mar 06, 2009 at 03:44:07PM -0800, Thomas Hellstrom wrote:
> >   
> >> We get the warning when we insert RAM pages using vm_insert_pfn().
> >> Having normal RAM pages backing a PFN papping is a valid thing.
> >>
> >>     
> >
> > OK. Below is the updated patch that should fix this fully. Can you confirm?
> >
> > Thanks,
> > Venki
> >
> >   
> 
> Yes, this patch should fix the problem. I'm still concerned about the 
> overhead of going through the
> RAM test for each inserted page.
> 
> Why can't a pfn_valid() test be used in vm_insert_pfn()?
> 

Because we may have to track the RAM pages as well in future. We are
changing the e820 RAM check and making it use pfn_valid. But, for that
we have to change more things in tracking of RAM pages. Today we use one
bit in page struct without any refcounting. But, more changes there are
on ts way. This change here should keep the current kernel fine without
any regression.

Thanks,
Venki

