Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbYANVVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbYANVVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYANVVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:21:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:33487 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbYANVVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:21:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,284,1196668800"; 
   d="scan'208";a="253387313"
Date: Mon, 14 Jan 2008 13:21:06 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andi Kleen <andi@firstfloor.org>, ebiederm@xmission.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, jesse.barnes@intel.com
Subject: Re: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Message-ID: <20080114212105.GB8903@linux-os.sc.intel.com>
References: <p737iiho5yq.fsf@bingen.suse.de> <924EFEDD5F540B4284297C4DC59F3DEE5A2805@orsmsx423.amr.corp.intel.com> <20080110192808.GF747@one.firstfloor.org> <924EFEDD5F540B4284297C4DC59F3DEE5A28CE@orsmsx423.amr.corp.intel.com> <20080114164324.GH15542@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114164324.GH15542@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 05:43:24PM +0100, Ingo Molnar wrote:
> 
> * Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:
> 
> > Also, relying on MTRR, is like giving more importance to BIOS writer 
> > than required :-). I think the best way to deal with MTRR is just to 
> > not touch it. Leave it as it is and do not try to assume that they are 
> > correct, as frequently they will not be.
> 
> i'd suggest the following strategy on PAT-capable CPUs:
> 
>  - do not try to write MTRRs. Ever.
> 
>  - _read_ the current MTRR settings (including the default MTRR) and 
>    check them against the e820 map. I can see two basic types of 
>    mismatches:
> 
>      - RAM area marked fine in e820 but marked UC by MTRR: this 
>        currently results in a slow system.

Time to resurrect Jesse's old patches 
i386-trim-memory-not-covered-by-wb-mtrrs.patch(which was in -mm sometime back)

>        (NOTE: UC- would be fine and 
>        overridable by PAT, hence it's not a conflict we should detect.)

UC- can't be specified by MTRR's.

>      - mmio area marked cacheable in the MTRR (results in broken system)

PAT can help specify the UC/WC attribute here.

thanks,
suresh
