Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbXFDWYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbXFDWYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbXFDWY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:24:28 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:10534 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007AbXFDWY1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:24:27 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] x86_64: remove check for CONSTANT_TSC from time.c
Date: Mon, 4 Jun 2007 17:23:01 -0500
Message-ID: <249EE4DE927F114DBDC077FFA4A34DC701B3C700@SAUSEXMB3.amd.com>
In-Reply-To: <20070604204157.GB22013@amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] x86_64: remove check for CONSTANT_TSC from time.c
thread-index: Acem6M4Hr/u5DBf9RsO96HSR7BtOPAADXngw
From: "Nagendra, Bhavana" <bhavana.nagendra@amd.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>, "Andi Kleen" <ak@suse.de>
cc: linux-kernel@vger.kernel.org, "Deguara, Joachim" <joachim.deguara@amd.com>
X-OriginalArrivalTime: 04 Jun 2007 22:23:39.0257 (UTC)
 FILETIME=[001FDE90:01C7A6F7]
X-WSS-ID: 6A7A4F611GC4072208-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Yes, the attached patch works for me.  Andi, is this patch acceptable?  

Regards,
--
Bhavana Nagendra
AMD, Inc
 
 

-----Original Message-----
From: Joerg Roedel [mailto:joerg.roedel@amd.com] 
Sent: Monday, June 04, 2007 4:42 PM
To: Andi Kleen
Cc: linux-kernel@vger.kernel.org; Deguara, Joachim; Nagendra, Bhavana
Subject: Re: [PATCH] x86_64: remove check for CONSTANT_TSC from time.c

On Mon, Jun 04, 2007 at 08:02:40PM +0200, Andi Kleen wrote:
> On Monday 04 June 2007 19:49, Joerg Roedel wrote:
> > From: Joerg Roedel <joerg.roedel@amd.com>
> >
> > This patch removes the check for the CONSTANT_TSC cpu flag from
time.c
> > on the x86_64 architecture. At the time this flag is checked at boot
the
> > cpu init code was yet not executed and thus the check fails. At this
> > point the check for VENDOR_AMD and cpu family 0x10 is sufficient.
> 
> Wrong fix. The bit just needs to be set earlier in early cpu detect.
Otherwise 
> there is a problem again with the next constant TSC AMD CPU.
> I will do that.
> 
> -Andi

Ok. But I assume you are meaning something like the attached diff?

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe,
Thomas McCoy


