Return-Path: <linux-kernel-owner+w=401wt.eu-S1764215AbYEFAe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764215AbYEFAe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764090AbYEFAdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:33:45 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:22389 "EHLO
	outbound3-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764079AbYEFAdn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:33:43 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 07/56] microblaze_v2: Signal support
Date: Mon, 5 May 2008 17:33:45 -0700
In-reply-to: <1210033550.5798.185.camel@localhost>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 07/56] microblaze_v2: Signal support
Thread-Index: AcivD9iqJRppDB5kSWac8NrCpYHf3QAANYFg
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu> <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu> <20080505213244.8DC757A0084@mail70-wa4.bigfish.com> <1210030436.5798.148.camel@localhost> <20080506001339.619971A58057@mail55-wa4.bigfish.com> <1210033550.5798.185.camel@localhost>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: "John Williams" <john.williams@petalogix.com>
Cc: <monstr@seznam.cz>, <linux-kernel@vger.kernel.org>, <arnd@arndb.de>,
       <linux-arch@vger.kernel.org>, "John Linn" <linnj@xilinx.com>,
       <matthew@wil.cx>, <will.newton@gmail.com>, <drepper@redhat.com>,
       <microblaze-uclinux@itee.uq.edu.au>, <grant.likely@secretlab.ca>,
       "Michal Simek" <monstr@monstr.eu>
X-OriginalArrivalTime: 06 May 2008 00:33:41.0442 (UTC) FILETIME=[D562D220:01C8AF10]
Message-Id: <20080506003341.AFA5911E804F@mail138-va3.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You're right.  (I think I've been staring at this too much today... :)

Steve

> -----Original Message-----
> From: John Williams [mailto:john.williams@petalogix.com]
> Sent: Monday, May 05, 2008 5:26 PM
> To: Stephen Neuendorffer
> Cc: monstr@seznam.cz; linux-kernel@vger.kernel.org; arnd@arndb.de;
linux-arch@vger.kernel.org; John
> Linn; matthew@wil.cx; will.newton@gmail.com; drepper@redhat.com;
microblaze-uclinux@itee.uq.edu.au;
> grant.likely@secretlab.ca; Michal Simek
> Subject: RE: [PATCH 07/56] microblaze_v2: Signal support
> 
> On Mon, 2008-05-05 at 17:13 -0700, Stephen Neuendorffer wrote:
> > I'm somewhat ignorant about what this code is attempting to do, but
with
> > some quick poking around (m68knommu, blackfin) seems to suggest that
> > other architectures don't do this, while others (v850) have almost
> > exactly the same code (although they are somewhat smarter and are
> > careful not to flush the whole cache).
> >
> > At the very least, it seems like there is some work in this area
needed.
> 
> flush_cache_sigtramp should just invalidate 8 bytes up from the base
> address of the trampoline.  This is just the region on the process
stack
> where we insert a kind of call-back back.  Writing the opcodes goes
via
> the dcache, and so there's a vanishingly small possibility that the
CPU
> will get a false hit on on an icache fetch when the code is executed.
> 
> That was what Michal's patch had when I scanned it yesterday.  It
> certainly won't/shouldn't be invalidating the entire cache.
> 
> Cheers,
> 
> John
> 
> 


