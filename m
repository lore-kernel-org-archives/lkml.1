Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbXICIdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbXICIdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbXICIdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:33:05 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:56511 "EHLO
	outbound4-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890AbXICIdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:33:03 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Mon, 3 Sep 2007 10:32:42 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: "Robert Richter" <robert.richter@amd.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space
 access for AMD Barcelona
Message-ID: <20070903083242.GA22144@alberich.amd.com>
References: <20070830174311.221133000@amd.com>
 <20070830174311.536394000@amd.com> <200709011211.52167.ak@suse.de>
MIME-Version: 1.0
In-Reply-To: <200709011211.52167.ak@suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 03 Sep 2007 08:32:40.0646 (UTC)
 FILETIME=[FDAAD660:01C7EE04]
X-WSS-ID: 6AC519201A46453876-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2007 at 12:11:52PM +0200, Andi Kleen wrote:
> On Thursday 30 August 2007 19:43:14 Robert Richter wrote:
> > This patch implements PCI extended configuration space access for
> > AMD's Barcelona CPUs. It extends the method using CF8/CFC IO
> > addresses. An x86 capability bit has been introduced that is set for
> > CPUs supporting PCI extended config space accesses.
> 
> We shouldn't need this because extended config space should work
> here and Linux should use it 
> (especially after we added the ugly Barcelona workaround into  that code) 

This patch is needed for all buggy BIOSes that don't correctly set up MCFG.

> The only exception would be if the user disables MMCONFIG in CONFIG, but that's
> their own fault then.

No, as you stated yourself there are two exceptions. And the more serious one is the
BIOS issue.

> Ok there might be buggy BIOS around with no or no usable MCFG table, but since
> extended config space is not really a critical feature that's not a big issue.

Not sure why you assume extended config space (ECS) is not critical.
Ok, for a lot of stuff it does not matter.
But it is needed for some devices for full functionality.
E.g. for perfmon (family 0x10/extended inerrupts) extended config space access
is a prerequisite.

> So I don't think we want this special case code at all and should
> just rely on MMCONFIG.

Rely on something unreliable (due to buggy/incomplete BIOS)?
I don't think we should do this.

IMHO it is best to try to use MMCONFIG if it's working and to use
a fallback (e.g. CF8 ECS access for family 0x10) if available.


Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



