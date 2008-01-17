Return-Path: <linux-kernel-owner+w=401wt.eu-S1761621AbYAQXKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761621AbYAQXKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757922AbYAQXKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:10:18 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:7995 "EHLO
	outbound7-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757826AbYAQXKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:10:13 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Fri, 18 Jan 2008 00:06:07 +0100
From: "Andreas Herrmann3" <andreas.herrmann3@amd.com>
To: "Ingo Molnar" <mingo@elte.hu>
cc: "Venki Pallipadi" <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug
 fixes
Message-ID: <20080117230607.GI12631@alberich.amd.com>
References: <20080116023955.597433000@intel.com>
 <20080116185748.GA11244@alberich.amd.com>
 <20080116203328.GA17869@linux-os.sc.intel.com>
 <20080117191211.GA12631@alberich.amd.com>
 <20080117203600.GB27778@elte.hu>
 <20080117210301.GC12631@alberich.amd.com>
 <20080117211308.GA7858@elte.hu>
 <20080117214228.GD12631@alberich.amd.com>
 <20080117222634.GG12631@alberich.amd.com>
 <20080117223551.GA23543@elte.hu>
MIME-Version: 1.0
In-Reply-To: <20080117223551.GA23543@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Jan 2008 23:05:51.0416 (UTC)
 FILETIME=[812DEB80:01C8595D]
X-WSS-ID: 6B9100D824S8211700-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 11:35:51PM +0100, Ingo Molnar wrote:
> 
> * Andreas Herrmann3 <andreas.herrmann3@amd.com> wrote:
> 
> > > I'll check this asap
> > 
> > So, now that I've avoided this tiny NULL-pointer-dereference, the 
> > system boots fine as well with your (slightly modified) patch. See 
> > dmesg attached.
> 
> for now i applied your ioremap_uncached() patch and removed my patch.
> 
> my patch might work if the MTRR marks that area UC. Does it on your 
> system?

The region (c0403000-c04031ff) is not characterized by an MTRR.
The MTRRdefType specifies it and it is

  MTRRdefType          = 0x0000000000000c00
    MemType=0
    MtrrDefTypeFixEn=0x1
    MtrrDefTypeEn=0x1

=> 0==UC

So, that's why it worked.


Andreas



