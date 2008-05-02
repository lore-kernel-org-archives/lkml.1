Return-Path: <linux-kernel-owner+w=401wt.eu-S964894AbYEBWHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964894AbYEBWHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758710AbYEBWHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:07:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:29740 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039AbYEBWHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:07:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,428,1204531200"; 
   d="scan'208";a="277363606"
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [git head] Should X86_PAT really default to yes?
Date: Fri, 2 May 2008 15:07:28 -0700
User-Agent: KMail/1.9.9
Cc: "Frans Pop" <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Packard, Keith" <keith.packard@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
References: <200805022122.03576.elendil@planet.nl> <200805021340.24987.jesse.barnes@intel.com> <924EFEDD5F540B4284297C4DC59F3DEEFB8E83@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEFB8E83@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805021507.28728.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 02, 2008 2:55 pm Pallipadi, Venkatesh wrote:
> >-----Original Message-----
> >From: Barnes, Jesse
> >Sent: Friday, May 02, 2008 1:40 PM
> >To: Pallipadi, Venkatesh
> >Cc: Frans Pop; linux-kernel@vger.kernel.org; Ingo Molnar;
> >Packard, Keith
> >Subject: Re: [git head] Should X86_PAT really default to yes?
> >
> >On Friday, May 02, 2008 12:37 pm Pallipadi, Venkatesh wrote:
> >> >-----Original Message-----
> >> >From: Frans Pop [mailto:elendil@planet.nl]
> >> >Sent: Friday, May 02, 2008 12:22 PM
> >> >To: linux-kernel@vger.kernel.org
> >> >Cc: Pallipadi, Venkatesh; Ingo Molnar
> >> >Subject: [git head] Should X86_PAT really default to yes?
> >> >
> >> >With X86_PAT enabled, when X is started I get about 40 lines
> >> >(with varying
> >> >addresses) like:
> >> >kernel: Xorg:3358 /dev/mem expected mapping type write-back for
> >> >807bf000-81000000, got uncached-minus
> >
> >These messages?  They're coming from the kernel it looks like,
> >from the
> >map_devmem routine in pat.c.  I'm not sure they're accurate
> >though; for PCI
> >regions /dev/mem is *supposed* to map with UC- and not WB, so
> >maybe this
> >function needs to be updated?
>
> Indeed.
> I think these messages are due to X using the mprotect workaround to
> change UC_MINUS to WB.
> I don't see these error messages on my 965 here. May be I have different
> x version.

Hm, yeah that could be.  strace would tell us.

>
> What may be happening:
> 1) process A mmaps /dev/mem and gets UC_MINUS
> 2) Changes the page table to make pg_prot WB
> 3) Does a fork to create process B
> 4) While copying the vma, we go through map_devmem request WB, but get
> UC_MINUS back
> 5) We are not changing vma pg_prot to new value at this point (we should
> change this), so one more round of errors will be there when forked
> process exits.
>
> Again, this should not have any side-effect like the band etc. It just a
> "friendly warning". It should go away when X moves to using WC or does
> not use the mprotect workaround to make pg_prot WB.

More recent versions of X will use sysfs rather than /dev/mem (though we're 
still using the mprotect hack there to give us UC-), so yeah this warning 
should already be gone in more recent builds.

Jesse
