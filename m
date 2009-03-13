Return-Path: <linux-kernel-owner+w=401wt.eu-S1760789AbZCMREx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbZCMREx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759187AbZCMRBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:01:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:1036 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759710AbZCMRBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:01:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,358,1233561600"; 
   d="scan'208";a="672745917"
Subject: Re: [tip:x86/urgent] VM, x86, PAT: Change is_linear_pfn_mapping to
 not use vm_pgoff
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "elendil@planet.nl" <elendil@planet.nl>,
       "thellstrom@vmware.com" <thellstrom@vmware.com>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <20090313162530.GA7118@wotan.suse.de>
References: <20090313004527.GA7176@linux-os.sc.intel.com>
	 <tip-4bb9c5c02153dfc89a6c73a6f32091413805ad7d@git.kernel.org>
	 <20090313162530.GA7118@wotan.suse.de>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 10:00:07 -0700
Message-Id: <1236963607.4529.111.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 09:25 -0700, Nick Piggin wrote:
> On Fri, Mar 13, 2009 at 04:03:39AM +0000, Pallipadi, Venkatesh wrote:
> > Commit-ID:  4bb9c5c02153dfc89a6c73a6f32091413805ad7d
> > Gitweb:     http://git.kernel.org/tip/4bb9c5c02153dfc89a6c73a6f32091413805ad7d
> > Author:     Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
> > AuthorDate: Thu, 12 Mar 2009 17:45:27 -0700
> > Commit:     Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri, 13 Mar 2009 04:28:50 +0100
> >  
> >  /*
> > + * pfnmap vmas that are fully mapped at mmap time (not mapped on fault).
> > + * Used by x86 PAT to identify such PFNMAP mappings and optimize their handling.
> > + * Note VM_INSERTPAGE flag is overloaded here. i.e,
> > + * VM_INSERTPAGE && !VM_PFNMAP implies
> > + *     The vma has had "vm_insert_page()" done on it
> > + * VM_INSERTPAGE && VM_PFNMAP implies
> > + *     The vma is PFNMAP with full mapping at mmap time
> > + */
> > +#define VM_PFNMAP_AT_MMAP (VM_INSERTPAGE | VM_PFNMAP)
> 
> This is really ugly IMO. Either it should be its own bit, or if you want
> to reduce usage of bits, then set aside some bits to represent a set of
> vma types, and convert existing code over to use that. 
> 
> Why not just use another vm_flag for 2.6.29 and earlier (we have 2 left),
> then do some flag rationalisation in 2.6.30?
> 
> But I do like just avoiding these games entirely and encoding it
> explicitly.
> 

Totally agree that this is ugly. But, I didn't like taking away one bit
for such a light usage. VM_INSERTPAGE is hardly ever used in the kernel
(wherever it is used, it is checked along with VM_PFNMAP).

OK. I will resend the patch with taking away one of the available bits.
But, I feel we need to do some multiplexing here, in a clean manner, for
future.

Thanks,
Venki

