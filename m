Return-Path: <linux-kernel-owner+w=401wt.eu-S1765560AbXLNVH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765560AbXLNVH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 16:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbXLNVHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 16:07:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:18370 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbXLNVHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 16:07:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,169,1196668800"; 
   d="scan'208";a="439429872"
Date: Fri, 14 Dec 2007 13:06:45 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: venkatesh.pallipadi@intel.com, ak@muc.de, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 02/12] PAT 64b: Basic PAT implementation
Message-ID: <20071214210645.GA717@linux-os.sc.intel.com>
References: <20071213235543.568682000@intel.com> <20071213235711.464325000@intel.com> <m1d4taq6le.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d4taq6le.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 08:48:45PM -0700, Eric W. Biederman wrote:
> > +		pat = PAT(0,WB) | PAT(1,WT) | PAT(2,UC_MINUS) | PAT(3,WC) |
> > +		      PAT(4,WB) | PAT(5,WT) | PAT(6,UC_MINUS) | PAT(7,WC);
> 
> I strongly object to this configuration.
> 
> The caching modes of interest are:
> PAT_WB write-back or a close as the MTRRs will allow
>        used for WC today.
> PAT_UC completely uncachable not overridable by MTRRs 
>        and what we use today for pgprot_noncached
> PAT_WC what isn't available for current use.
>
> We should use:
> > +		pat = PAT(0,WB) | PAT(1,WT) | PAT(2,WC) | PAT(3,UC) |
> > +		      PAT(4,WB) | PAT(5,WT) | PAT(6,WC) | PAT(7,UC);
> 
> Changing the UC- which currently allows write-combining if the MTRRs specify it,
> to WC.  This grandfathers in all of our current usage and changes the one
> PAT type that could today and in legacy mode specify WC to really specify WC.

That seems reasonable. But looking at mainline kernel, ioremap_nocache()
actually uses UC_MINUS. Wonder why it is not using UC (like
pgprot_noncached).  I think it is ok to change ioremap_nocache() to use UC.

thanks,
suresh
