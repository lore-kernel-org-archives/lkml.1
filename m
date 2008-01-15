Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbYAOXVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbYAOXVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbYAOXVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:21:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:11604 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbYAOXVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:21:17 -0500
X-ExtLoop1: 1
Date: Tue, 15 Jan 2008 15:21:15 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andi Kleen <andi@firstfloor.org>, ebiederm@xmission.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       jesse.barnes@intel.com
Subject: Re: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Message-ID: <20080115232115.GD8903@linux-os.sc.intel.com>
References: <p737iiho5yq.fsf@bingen.suse.de> <924EFEDD5F540B4284297C4DC59F3DEE5A2805@orsmsx423.amr.corp.intel.com> <20080110192808.GF747@one.firstfloor.org> <924EFEDD5F540B4284297C4DC59F3DEE5A28CE@orsmsx423.amr.corp.intel.com> <20080114164324.GH15542@elte.hu> <20080114212105.GB8903@linux-os.sc.intel.com> <20080115221758.GG2665@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115221758.GG2665@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 11:17:58PM +0100, Ingo Molnar wrote:
> 
> * Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:
> > Time to resurrect Jesse's old patches 
> > i386-trim-memory-not-covered-by-wb-mtrrs.patch(which was in -mm 
> > sometime back)
> 
> just to make sure i understood the attribute priorities right: we cannot 
> just mark it WB in the PAT and expect it to be write-back - the UC of 
> the MTRR will control?

unfortuantely PAT is not the over-riding winner always. It all depends
on the individual attributes. For WB in PAT, mtrr always takes
the precedence.

> 
> > >        (NOTE: UC- would be fine and 
> > >        overridable by PAT, hence it's not a conflict we should detect.)
> > 
> > UC- can't be specified by MTRR's.
> 
> hm, only by PATs? Not even by the default MTRR?

No.

> > >      - mmio area marked cacheable in the MTRR (results in broken 
> > >      system)
> > 
> > PAT can help specify the UC/WC attribute here.
> 
> ok. So it seems we dont even need all that many special cases, a "dont 
> write MTRRs" and "use PATs everywhere" rule would just do the right 
> thing all across?

Yes. The main thing required is on the lines of Jesse's patch.
If the MTRR's def type is not WB, then we need to check if any of the RAM
is not covered by MTRR range registers and trim the RAM accordingly.

thanks,
suresh
