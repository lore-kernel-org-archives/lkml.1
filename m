Return-Path: <linux-kernel-owner+w=401wt.eu-S1763822AbYEFAP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763822AbYEFAP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756470AbYEFAPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:15:43 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:63638 "EHLO
	outbound3-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755966AbYEFAPm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:15:42 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 07/56] microblaze_v2: Signal support
Date: Mon, 5 May 2008 17:13:42 -0700
In-reply-to: <1210030436.5798.148.camel@localhost>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 07/56] microblaze_v2: Signal support
Thread-Index: AcivCJqTKE6gxX62RWSG6U3S60zxwwAACyqw
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu> <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu> <20080505213244.8DC757A0084@mail70-wa4.bigfish.com> <1210030436.5798.148.camel@localhost>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: "John Williams" <john.williams@petalogix.com>
Cc: <monstr@seznam.cz>, <linux-kernel@vger.kernel.org>, <arnd@arndb.de>,
       <linux-arch@vger.kernel.org>, "John Linn" <linnj@xilinx.com>,
       <matthew@wil.cx>, <will.newton@gmail.com>, <drepper@redhat.com>,
       <microblaze-uclinux@itee.uq.edu.au>, <grant.likely@secretlab.ca>,
       "Michal Simek" <monstr@monstr.eu>
X-OriginalArrivalTime: 06 May 2008 00:13:39.0191 (UTC) FILETIME=[08C9E070:01C8AF0E]
Message-Id: <20080506001339.619971A58057@mail55-wa4.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm somewhat ignorant about what this code is attempting to do, but with
some quick poking around (m68knommu, blackfin) seems to suggest that
other architectures don't do this, while others (v850) have almost
exactly the same code (although they are somewhat smarter and are
careful not to flush the whole cache).

At the very least, it seems like there is some work in this area needed.

Steve

> -----Original Message-----
> From: John Williams [mailto:john.williams@petalogix.com]
> Sent: Monday, May 05, 2008 4:34 PM
> To: Stephen Neuendorffer
> Cc: monstr@seznam.cz; linux-kernel@vger.kernel.org; arnd@arndb.de;
linux-arch@vger.kernel.org; John
> Linn; matthew@wil.cx; will.newton@gmail.com; drepper@redhat.com;
microblaze-uclinux@itee.uq.edu.au;
> grant.likely@secretlab.ca; Michal Simek
> Subject: RE: [PATCH 07/56] microblaze_v2: Signal support
> 
> On Mon, 2008-05-05 at 14:32 -0700, Stephen Neuendorffer wrote:
> > (multiple places)  can this code (and flush_cache_sigtramp()) go
away?
> >
> > +#if 0
> > +		flush_cache_sigtramp((unsigned long)frame->tramp);
> > +#endif
> 
> You have to icache_invalidate the sigtramp because you are writing
into
> memory that will shortly be executed.
> 
> I'm not sure why this is #if'd away in the first place?
> 
> John
> 
> 


