Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbZCNCwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbZCNCwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 22:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbZCNCwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 22:52:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:50014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbZCNCwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 22:52:43 -0400
Date: Sat, 14 Mar 2009 03:52:38 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "elendil@planet.nl" <elendil@planet.nl>,
       "thellstrom@vmware.com" <thellstrom@vmware.com>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] VM, x86, PAT: Change is_linear_pfn_mapping to not use vm_pgoff
Message-ID: <20090314025238.GA32065@wotan.suse.de>
References: <20090313004527.GA7176@linux-os.sc.intel.com> <tip-4bb9c5c02153dfc89a6c73a6f32091413805ad7d@git.kernel.org> <20090313162530.GA7118@wotan.suse.de> <1236963607.4529.111.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236963607.4529.111.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 10:00:07AM -0700, Pallipadi, Venkatesh wrote:
> On Fri, 2009-03-13 at 09:25 -0700, Nick Piggin wrote:
> > Why not just use another vm_flag for 2.6.29 and earlier (we have 2 left),
> > then do some flag rationalisation in 2.6.30?
> > 
> > But I do like just avoiding these games entirely and encoding it
> > explicitly.
> > 
> 
> Totally agree that this is ugly. But, I didn't like taking away one bit
> for such a light usage. VM_INSERTPAGE is hardly ever used in the kernel
> (wherever it is used, it is checked along with VM_PFNMAP).

That is a concern, but I think it makes the patch more intrusive
than a simple fix that might possibly introduce a bug. So for 2.6.29
we have spare flags so can use one of those for the fix.
 

> OK. I will resend the patch with taking away one of the available bits.
> But, I feel we need to do some multiplexing here, in a clean manner, for
> future.

That would always be appreciated. There are probably several flags that
can go away (eg. VM_RESERVED, VM_INSERTPAGE), others that can be merged
(eg nommu flags with mmu flags), others that can be one scalar value
rather than several binary values etc.

Also, if worst comes to worst, I think we could probably make vm_flags
64-bit on 32-bit compiles to get another 32 bits. Of course I'd rather
not until no other options left for reducing flags ;)
