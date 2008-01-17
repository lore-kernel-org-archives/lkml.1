Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbYAQWH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbYAQWH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757986AbYAQWG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:06:56 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:43369 "EHLO
	outbound5-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757876AbYAQWGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:06:54 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Thu, 17 Jan 2008 23:06:50 +0100
From: "Andreas Herrmann3" <andreas.herrmann3@AMD.COM>
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
Message-ID: <20080117220650.GE12631@alberich.amd.com>
References: <20080116023955.597433000@intel.com>
 <20080116185748.GA11244@alberich.amd.com>
 <20080116203328.GA17869@linux-os.sc.intel.com>
 <20080117191211.GA12631@alberich.amd.com>
 <20080117203600.GB27778@elte.hu>
 <20080117210301.GC12631@alberich.amd.com>
 <20080117211308.GA7858@elte.hu>
 <20080117213131.GA25389@linux-os.sc.intel.com>
 <20080117214209.GA12811@elte.hu>
MIME-Version: 1.0
In-Reply-To: <20080117214209.GA12811@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Jan 2008 22:06:34.0614 (UTC)
 FILETIME=[39290160:01C85955]
X-WSS-ID: 6B910EE707S8365221-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 10:42:09PM +0100, Ingo Molnar wrote:
> 
> * Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:
> 
> > On Thu, Jan 17, 2008 at 10:13:08PM +0100, Ingo Molnar wrote:
> > > but in general we must be robust enough in this case and just degrade 
> > > any overlapping page to UC (and emit a warning perhaps) - instead of 
> > > failing the ioremap and thus failing the driver (and the bootup).
> > 
> > But then, this will cause an attribute conflicit. Old one was 
> > specifying WB in PAT (ioremap with noflags) and the new ioremap 
> > specifies UC.
> 
> we could fix up all aliases of that page as well and degrade them to UC?

Yes, we must fix all aliases or reject the conflicting mapping.
But fixing all aliases might not be that easy.
(I've just seen a panic when using your patch ;-(


Andreas



