Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbYCFTMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbYCFTMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 14:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYCFTMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 14:12:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:32623 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbYCFTMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 14:12:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,457,1199692800"; 
   d="scan'208";a="215638548"
Date: Thu, 6 Mar 2008 11:10:52 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Christoph Hellwig <hch@infradead.org>, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 2/2] x86, fpu: lazy allocation of FPU area - v3
Message-ID: <20080306191051.GH28006@linux-os.sc.intel.com>
References: <20080303230335.892214000@linux-os.sc.intel.com> <20080303230336.042604000@linux-os.sc.intel.com> <20080304012012.GB22431@infradead.org> <20080304014306.GC28006@linux-os.sc.intel.com> <20080304103220.GA17621@elte.hu> <20080304175528.GD28006@linux-os.sc.intel.com> <20080305194705.GA4386@ucw.cz> <20080306155141.GA23340@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306155141.GA23340@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 04:51:41PM +0100, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > > > kmem_cache_alloc() can fail (return NULL) and not handling it is a 
> > > > bug.
> > > 
> > > oops. you are correct. Will send a sigsegv in the failure case then. 
> > > Thanks.
> > 
> > You are introducing possibility of hard to debug error, where previous 
> > code just worked... Does not look like good idea to me.
> 
> hm, how does it differ from any other allocation failure? We could fail 
> to allocate a pagetable page. We could fail to allocate the task_struct 
> to begin with.

Yes. This happens under out of memory conditions. And we are also using
GFP_KERNEL here, which can block.
