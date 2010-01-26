Return-Path: <linux-kernel-owner+w=401wt.eu-S1751816Ab0AZATO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab0AZATO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 19:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549Ab0AZATM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 19:19:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:19578 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab0AZATK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 19:19:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qIrtaxxs3C9NqNkKMxS2Zd6hN0KhdLcZO6b2mRfWSQRy+Bp6p+zdbDWalJStlOYOgj
         F9jK6IHk9fzwXct1K9TNz+8u93QcLkP8MOXv8epMfwiWv9J9OkhJg7ibKpbEB+LEnm1p
         Ne8mEL0lojIuR1TdHBExn6ErKu29xTi5zgnjU=
Date: Tue, 26 Jan 2010 01:19:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, ebiederm@xmission.com, tytso@mit.edu,
       Trond.Myklebust@netapp.com, aelder@sgi.com, hch@infradead.org,
       viro@zeniv.linux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
       x86@kernel.org, mingo@redhat.com, dan.j.williams@intel.com,
       borislav.petkov@amd.com, ying.huang@intel.com, lenb@kernel.org,
       neilb@suse.de, cl@linux-foundation.org
Subject: Re: [PATCH 7/8] percpu: add __percpu sparse annotations to
	hw_breakpoint
Message-ID: <20100126001901.GI5087@nowhere>
References: <1264432935-10453-1-git-send-email-tj@kernel.org> <1264432935-10453-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264432935-10453-8-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 12:22:14AM +0900, Tejun Heo wrote:
> Add __percpu sparse annotations to hw_breakpoint.
> 
> These annotations are to make sparse consider percpu variables to be
> in a different address space and warn if accessed without going
> through percpu accessors.  This patch doesn't affect normal builds.
> 
> per_cpu(nr_task_bp_pinned, cpu) is replaced with
> &per_cpu(nr_task_bp_pinned[0], cpu).  This is the same to the compiler
> but allows per_cpu() macro to correctly drop __percpu designation for
> the returned pointer.



Ouch... It's unpleasant to see such workaround that messes up the
code just to make sparse happy.

I guess __percpu is an address_space attribute? Is there no
way to force the address space change directly from the
per_cpu() macro?

Thanks.

