Return-Path: <linux-kernel-owner+w=401wt.eu-S965299AbXBFTZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965299AbXBFTZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 14:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965362AbXBFTZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 14:25:48 -0500
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:16896 "EHLO
	outbound2-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965299AbXBFTZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 14:25:47 -0500
X-BigFish: VP
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
Date: Tue, 6 Feb 2007 20:25:33 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: ebiederm@xmission.com
cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>, discuss@x86-64.org,
       "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org,
       "Richard Gooch" <rgooch@safe-mbox.com>
Subject: Re: [discuss] [patch] mtrr: fix issues with large addresses
Message-ID: <20070206192533.GB5647@amd.com>
References: <20070205171959.GF8665@alberich.amd.com>
 <m13b5kw2qj.fsf@ebiederm.dsl.xmission.com>
 <20070206160828.GH8665@alberich.amd.com>
 <m1sldjtbn4.fsf@ebiederm.dsl.xmission.com>
 <20070206184213.GA4628@alberich.amd.com>
 <m1zm7rrtnn.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
In-Reply-To: <m1zm7rrtnn.fsf@ebiederm.dsl.xmission.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 06 Feb 2007 19:25:32.0901 (UTC)
 FILETIME=[91D0D950:01C74A24]
X-WSS-ID: 69D609BA2X038452-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 12:08:12PM -0700, ebiederm@xmission.com wrote:
> "Andreas Herrmann" <andreas.herrmann3@amd.com> writes:
> > You are referring to current Linux implementation?
> > The AMD64 architecture increased physical address size in PSE mode to
> > 40 bits. So at least it would be possible to use more than 32 bits.
> 
> How do you get 40 physical bits in a 32bit page table entry? My memory
> is that the low bits in the page table entry were well defined and
> accounted for. I'm pretty certain I can account for 6 of the low bits
> off the top of my head.  PSE is the page size extension allowing pages 2MB/4MB
> pages.

The access to 40 physical address bits is only possible using large pages
(4MB on 32bit without PAE). In those page tables entrys you only use
bits 22:31 for encoding the physical address. The bits 12:21 are
unused. These unused bits are reused to encode bits 32:39 of the 40 bit
physical address.

Joerg

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG


