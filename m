Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab0CMBrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:47:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:64102 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab0CMBq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 20:46:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,629,1262592000"; 
   d="scan'208";a="548665807"
Subject: Re: [Patch] x86,pat Update the page flags for memtype atomically
 instead of using memtype_lock.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <alpine.LFD.2.00.1003130204560.22855@localhost.localdomain>
References: <20100311161700.GC5685@sgi.com>
	 <1268439313.2793.148.camel@sbs-t61.sc.intel.com>
	 <alpine.LFD.2.00.1003130204560.22855@localhost.localdomain>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 12 Mar 2010 17:46:02 -0800
Message-Id: <1268444762.2793.197.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 17:08 -0800, Thomas Gleixner wrote:
> On Fri, 12 Mar 2010, Suresh Siddha wrote:
> > On Thu, 2010-03-11 at 08:17 -0800, Robin Holt wrote:
> > > Changes since -V1:
> > > 1) Introduce atomically setting and clearing the page flags and not
> > > using the global memtype_lock to protect page->flags.
> > > 
> > > 2) This allowed me the opportunity to convert the rwlock back into a
> > > spinlock and not affect _MY_ tests performance as all the pages my test
> > > was utilizing are tracked by struct pages.
> > 
> > Can you also include this spinlock to rwlock conversion, which can be
> > used for non RAM pages as a second patch?
> 
> spinlock -> rwlock conversion ? I hope you meant it the other way
> round as Robin said in #2 :)

Thomas, No. I meant converting the existing memtype_lock which is a
spinlock into rwlock. Robin has this in the first version of the patch
but he dropped it in a later version as he avoided this lock for RAM
pages.

Just wanted to make sure that we address the perf aspect even for non
RAM pages by converting the memtype_lock into rwlock before some one
else reports a similar issue for non RAM pages.

thanks,
suresh

