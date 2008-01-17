Return-Path: <linux-kernel-owner+w=401wt.eu-S1759836AbYAQVsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836AbYAQVsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758613AbYAQVmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:42:36 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:29985 "EHLO
	outbound6-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758619AbYAQVme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:42:34 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Thu, 17 Jan 2008 22:42:28 +0100
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
Message-ID: <20080117214228.GD12631@alberich.amd.com>
References: <20080116023955.597433000@intel.com>
 <20080116185748.GA11244@alberich.amd.com>
 <20080116203328.GA17869@linux-os.sc.intel.com>
 <20080117191211.GA12631@alberich.amd.com>
 <20080117203600.GB27778@elte.hu>
 <20080117210301.GC12631@alberich.amd.com>
 <20080117211308.GA7858@elte.hu>
MIME-Version: 1.0
In-Reply-To: <20080117211308.GA7858@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Jan 2008 21:42:12.0882 (UTC)
 FILETIME=[D1E66720:01C85951]
X-WSS-ID: 6B91143C24S8203847-03-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 10:13:08PM +0100, Ingo Molnar wrote:
> 
> * Andreas Herrmann3 <andreas.herrmann3@amd.com> wrote:
> 
> > Yes.
> > 
> > Meanwhile I have figured out that it is some ACPI stuff that maps the 
> > page cached. I've changed the ioremap's in drivers/acpi/osl.c to 
> > ioremap_nocache. See attached patch.
> > 
> > Now the machine boots without conflicts.
> 
> ah, nice!
> 
> but in general we must be robust enough in this case and just degrade 
> any overlapping page to UC (and emit a warning perhaps) - instead of 
> failing the ioremap and thus failing the driver (and the bootup).
> 
> Does my third patch (which falls back to UC in case of attribute 
> conflicts, also attached below) instead of your ioremap_nocache() patch 
> solve your bootup problem too?

I'll check this asap

> but i have not seen this message in your boot log. Could you boot with 
> early_ioremap_debug and send us the dmesg - i'm curious which ACPI 
> tables are actively mapped while those devices are initialized.

Hmm, early_ioremap_debug exists only in ioremap_32.c
Have to adapt  the 64-bit version first.

But wait the 64-bit code contains already debug output for this.  See
the boot-logs that I have attached to my previous mails.
(Interestingly the code for 64-bit early_io(re/un)map resides not in
ioremap_64.c but in init_64.c.)


Andreas



