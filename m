Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbYCKU1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbYCKU1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYCKU1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:27:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:40943 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbYCKU1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:27:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,482,1199692800"; 
   d="scan'208";a="353264767"
Date: Tue, 11 Mar 2008 13:22:40 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 1/2] x86, fpu: split FPU state from task struct - v5
Message-ID: <20080311202239.GF15909@linux-os.sc.intel.com>
References: <20080310222955.565902000@linux-os.sc.intel.com> <20080311050644.GB4589@martell.zuzino.mipt.ru> <20080311083517.GC25110@elte.hu> <b6fcc0a0803110309m1108382dm7b4aa714576ba813@mail.gmail.com> <20080311101126.GY25110@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311101126.GY25110@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 11:11:26AM +0100, Ingo Molnar wrote:
> 
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > On 3/11/08, Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > >
> > > > > -	extern void __bad_fxsave_alignment(void);
> > > > > -
> > > > > -	if (offsetof(struct task_struct, thread.i387.fxsave) & 15)
> > > > > -	__bad_fxsave_alignment();
> > > >
> > > > I think removal of such checks needs giving necessary alignment to
> > > > cache. Previously it worked because of __aligned((16)) and
> > > > L1_CACHE_SHIFT combo.
> > >
> > > it's still checked, just elsewhere:
> > >
> > > > + WARN_ON((unsigned long)dst->thread.xstate & 15);
> > >
> > > i'd not expect us to ever align worse than 16 bytes in the future
> > 
> > But sysfs tells me alignment of "xstate" is 8 now. Object size is 512 
> > which is masking it.
> 
> ok - you are right, that needs to be solved then. (object size could 
> change anytime someone adds a few fields for debugging or whatever)

Which sysfs file are we referring here?
