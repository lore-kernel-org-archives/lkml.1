Return-Path: <linux-kernel-owner+w=401wt.eu-S1762956AbYAQW4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762956AbYAQW4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762426AbYAQWxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:53:17 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:57898 "EHLO
	mail125-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762412AbYAQWxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:53:14 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Thu, 17 Jan 2008 23:52:43 +0100
From: "Andreas Herrmann3" <andreas.herrmann3@amd.com>
To: "Ingo Molnar" <mingo@elte.hu>
cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Venki Pallipadi" <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug
 fixes
Message-ID: <20080117225243.GH12631@alberich.amd.com>
References: <20080116185748.GA11244@alberich.amd.com>
 <20080116203328.GA17869@linux-os.sc.intel.com>
 <20080117191211.GA12631@alberich.amd.com>
 <20080117203600.GB27778@elte.hu>
 <20080117210301.GC12631@alberich.amd.com>
 <20080117211308.GA7858@elte.hu>
 <20080117213131.GA25389@linux-os.sc.intel.com>
 <20080117214209.GA12811@elte.hu>
 <20080117220650.GE12631@alberich.amd.com>
 <20080117221505.GB18883@elte.hu>
MIME-Version: 1.0
In-Reply-To: <20080117221505.GB18883@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Jan 2008 22:52:27.0338 (UTC)
 FILETIME=[A1E95AA0:01C8595B]
X-WSS-ID: 6B9103A724S8210490-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 11:15:05PM +0100, Ingo Molnar wrote:
> 
> * Andreas Herrmann3 <andreas.herrmann3@AMD.COM> wrote:
> 
> > On Thu, Jan 17, 2008 at 10:42:09PM +0100, Ingo Molnar wrote:
> > > 
> > > * Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:
> > > 
> > > > On Thu, Jan 17, 2008 at 10:13:08PM +0100, Ingo Molnar wrote:
> > > > > but in general we must be robust enough in this case and just degrade 
> > > > > any overlapping page to UC (and emit a warning perhaps) - instead of 
> > > > > failing the ioremap and thus failing the driver (and the bootup).
> > > > 
> > > > But then, this will cause an attribute conflicit. Old one was 
> > > > specifying WB in PAT (ioremap with noflags) and the new ioremap 
> > > > specifies UC.
> > > 
> > > we could fix up all aliases of that page as well and degrade them to UC?
> > 
> > Yes, we must fix all aliases or reject the conflicting mapping. But 
> > fixing all aliases might not be that easy. (I've just seen a panic 
> > when using your patch ;-(
> 
> yes, indeed my patch is bad if you have PAT enabled: conflicting cache 
> attributes might be present. I'll go with your patch for now.

I think the best is to just reject conflicting mappings. (Because now
I am too tired to think about a safe way how to change the aliases to the
most restrictive memory type. ;-)

But then of course such boot-time problems like I've seen on my test
machines should be avoided somehow.


Andreas



