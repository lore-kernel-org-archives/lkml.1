Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbXICLcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbXICLcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 07:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbXICLcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 07:32:08 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:57757 "EHLO
	outbound7-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752679AbXICLcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 07:32:07 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Mon, 3 Sep 2007 13:31:14 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: "Robert Richter" <robert.richter@amd.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space
 access for AMD Barcelona
Message-ID: <20070903113114.GA22086@alberich.amd.com>
References: <20070830174311.221133000@amd.com>
 <200709011211.52167.ak@suse.de>
 <20070903083242.GA22144@alberich.amd.com>
 <200709031215.03473.ak@suse.de>
MIME-Version: 1.0
In-Reply-To: <200709031215.03473.ak@suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 03 Sep 2007 11:31:13.0048 (UTC)
 FILETIME=[EEC1A980:01C7EE1D]
X-WSS-ID: 6AC52F091A46464778-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 12:15:03PM +0200, Andi Kleen wrote:
> 
> > But it is needed for some devices for full functionality.
> 
> Examples? I can only think of PCI express error reporting, which
> few drivers implement anyways and isn't really a show stopper
> if it doesn't work. Besides I would be surprised if it even works
> on the cheap desktop boards which have MCFG less BIOS.

Sure, AER is one example.
I don't see why all other stuff in ECS is not worth reading or writing.
And I am not sure whether all server boards set up MCFG in the correct way.

> > E.g. for perfmon (family 0x10/extended inerrupts) extended config space
> > access is a prerequisite.
> 
> How so? 

E.g. access to the IBS control register needs ECS access on Barcelona.
I guess we have to wait until Robert sends his patches which contain
all details.

> >
> > IMHO it is best to try to use MMCONFIG if it's working and to use
> > a fallback (e.g. CF8 ECS access for family 0x10) if available.
> 
> We only put in workarounds if there is a serious problem otherwise (e.g. not 
> booting etc.). I just don't see this here.

The serious problem is you can't access PCI ECS if the BIOS does
not take care to (correctly) set up MCFG.
And unfortunately this is too often the case.

See for instance Robert Hancock's patch http://lkml.org/lkml/2007/5/30/2
to enable MMCONFIG access in certain cases where BIOS did not correctly
set up MCFG. Why are people working on such stuff if it is not serious
enough?

Barcelona just adds another way to access PCI ECS (besides MMCONFIG) and I
can't understand why this shouldn't be supported by Linux.

Do you have any suggestion how else to add support for PCI ECS access via
IO instructions for Barcelona?


Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



