Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966770Ab0B0AyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 19:54:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:53796 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966750Ab0B0AyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 19:54:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,549,1262592000"; 
   d="scan'208";a="544405066"
Subject: Re: [patch 1/1] Replace the memtype_lock spinlock with an rwlock.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Robin Holt <holt@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20100226174319.537341172@gulag1.americas.sgi.com>
References: <20100226174256.003433508@gulag1.americas.sgi.com>
	 <20100226174319.537341172@gulag1.americas.sgi.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 26 Feb 2010 16:52:59 -0800
Message-Id: <1267231979.2720.25.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-26 at 09:42 -0800, Robin Holt wrote:
> While testing an application using the xpmem (out of kernel driver), we
> noticed a significant page fault rate reduction of x86_64 with respect
> to ia64.  For one test running with 256 cpus, one thread per cpu, it
> took one minute, eight seconds for each of the threads to vm_insert_pfn
> 2GB worth of pages.
> 
> The slowdown was tracked to lookup_memtype which acquires the spinlock
> memtype_lock.  This heavily contended lock was slowing down fault time.
> 
> I quickly converted the spinlock to an rwlock.  This greatly improved
> vm_insert_pfn time to 4.3 seconds for the above test.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

> As a theoretical test, I removed the lock around get_page_memtype to see
> what the full impact of the single shared lock actually was.  With that
> change, the vm_insert_pfn time dropped to 1.6 seconds.
> 
> I do not think the current global lock to protect individual pages is
> the "correct" method for protecting get/set of the page_memtype flag.
> It seems like the locking should be located within the function that
> gets and sets the flags and be locked by a per-page lock or protected
> with an atomic update.

I agree. Will you be willing to look into this and post a patch? Or else
I can look at this and post a fix next week.

thanks,
suresh

