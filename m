Return-Path: <linux-kernel-owner+w=401wt.eu-S1752314AbZLVBix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbZLVBix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 20:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbZLVBix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 20:38:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:63662 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZLVBiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 20:38:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,434,1257148800"; 
   d="scan'208";a="758252867"
Date: Tue, 22 Dec 2009 09:38:51 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [RFC]block: add a new flag to make request complete on
 submitted  cpu
Message-ID: <20091222013851.GA28512@sli10-desk.sh.intel.com>
References: <20091221022827.GA1897@sli10-desk.sh.intel.com>
 <20091221091030.GF4489@kernel.dk>
 <20091221121228.GI4489@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091221121228.GI4489@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 08:12:28PM +0800, Jens Axboe wrote:
> On Mon, Dec 21 2009, Jens Axboe wrote:
> > On Mon, Dec 21 2009, Shaohua Li wrote:
> > > We already have a QUEUE_FLAG_SAME_COMP, which makes request complete
> > > on the first cpu of a mc/ht, but this isn't sufficient. In a system
> > > with fast block devices (intel SSD), it turns out the first cpu is
> > > bottlenect. Add a flag to make request complete on cpu where request
> > > is submitted. The flag implies QUEUE_FLAG_SAME_COMP. By default, it is off.
> > 
> > It was a lazy trick to avoid doing any round robin work in there.
> > 
> > > My test machine has two CPUs and 4 intel SSD. Without the new flag,
> > > the io thoughput is about 400m/s; with it, the thoughput is about 500m/s.
> > 
> > So I think we should just fix it, I still think the group logic makes
> > sense. But instead of always going for the first one, let it complete
> > locally if part of the group, if not send to specific submitter CPU.
> 
> Is this enough? It renames cpu to local_cpu and ccpu to target_cpu to
> make things clearer to read, the real change is that we allow local
> completion if the cpu matches OR the group matches.
No. Interrupt is fired on one CPU, so the change is a nop. All requests
are handled by the CPU directed the interrupt.
AHCI supports multiple MSI but not support per-vector mask, which makes
it's hard to add multiple MSI support.

Thanks,
Shaohua
