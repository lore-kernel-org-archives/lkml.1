Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbXIEPBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbXIEPBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 11:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbXIEPBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 11:01:39 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:10444 "EHLO
	outbound1-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137AbXIEPBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 11:01:37 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Wed, 5 Sep 2007 17:00:27 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Robert Richter" <robert.richter@amd.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space
 access for AMD Barcelona
Message-ID: <20070905150027.GD22086@alberich.amd.com>
References: <20070903081736.288288000@amd.com>
 <20070903081736.588599000@amd.com>
 <20070903013157.72c94891@laptopd505.fenrus.org>
 <20070903091718.GB22144@alberich.amd.com>
 <20070903043319.7573875b@laptopd505.fenrus.org>
 <20070903154734.GC22086@alberich.amd.com> <46DE45A2.40403@zytor.com>
MIME-Version: 1.0
In-Reply-To: <46DE45A2.40403@zytor.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Sep 2007 15:00:25.0160 (UTC)
 FILETIME=[7D397480:01C7EFCD]
X-WSS-ID: 6AC01B3B1A46695787-12-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2007 at 06:58:58AM +0100, H. Peter Anvin wrote:
> Well, they don't add any functionality, do they?

They allow CF8/CFC to access ECS in cases where mmcfg is not working.

> As such, I would agree with Andi -- we only 
> need one method which can (correctly) access the full configuration space,

Right, we need to be able to "correctly access the full config space".

> since it'll look the same on the bus anyway.

Sure, on the bus we should only see pci configuration requests in both
cases.


To summarize it:
- mmcfg needs support by BIOS ("PCI services in ACPI")
- CF8/CFC ECS access does not have that dependency
- For base configuration space access we already have two methods -
  type 1 and mmcfg  (type1 as fallback if there is no mmcfg).
- So what's the benefit in not allowing CF8/CFC ECS  access ("extended type1")
  if the hardware supports it and if mmcfg is not suitable?


One thing that comes out of that fruitless discussion:
For IBS Robert might have to implement CF8/CFC ECS access directly in the IBS
code, or in a new driver for ECS access of NB functions. Just to ensure that
IBS is working if there is no mmcfg. And this is kind of ugly.


Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



