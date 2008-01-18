Return-Path: <linux-kernel-owner+w=401wt.eu-S1763966AbYARSIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763966AbYARSIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761464AbYARSIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:08:45 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44727 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759358AbYARSIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:08:44 -0500
Date: Fri, 18 Jan 2008 19:12:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Message-ID: <20080118181202.GA19889@one.firstfloor.org>
References: <p737iiho5yq.fsf@bingen.suse.de> <20080118120112.GB8583@elte.hu> <20080118131209.GA16459@one.firstfloor.org> <200801180846.03161.jesse.barnes@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801180846.03161.jesse.barnes@intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 08:46:02AM -0800, Jesse Barnes wrote:
> On Friday, January 18, 2008 5:12 am Andi Kleen wrote:
> > > (AMD machines apparently don't need it
> >
> > That's not true -- we had AMD systems in the past with broken MTRRs for
> > large memory configurations too,  Mostly it was pre revE though.
> 
> It should be easy enough to enable it for AMD as well, and it would also be 
> good to track down the one failure you found...  I don't *think* the 
> re-ordering of MTRR initialization should affect AMDs anymore than it does 
> Intel, but someone familiar with the boot code would have to do a quick audit 
> to be sure.

I looked back then when I had bisected it down and I admit I didn't spot the 
problem from source review. I think it came from the reordering so blacklisting 
AMD alone wouldn't have helped. Might have been some
subtle race (e.g. long ago we had such races in the MTRR code
triggered by the first HT CPUs) 

Anyways I just test booted latest git-x86 with your patches included on 
the QC system and it booted now. However it has both more RAM and newer CPUs 
(the original ones were pre-production, that is why I also didn't send you logs[1] ..) 
then when I tested originally. So this means either the problem was somewhere 
else or the different configuration hides it.

I guess you will hear about it if it's still broken on other machines.

Currently it looks good.

I think it should be enabled on AMD too though. If the reordering breaks
it then blacklisting won't help anyways.

-Andi

[1] but I checked the known errata and there was nothing related to MTRR.

