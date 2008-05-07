Return-Path: <linux-kernel-owner+w=401wt.eu-S1763525AbYEGUOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763525AbYEGUOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYEGUOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:14:34 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:36651 "EHLO
	outbound3-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbYEGUOb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:14:31 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [microblaze-uclinux] [PATCH 04/56] microblaze_v2: Open firmware files
Date: Wed, 7 May 2008 13:14:45 -0700
In-reply-to: <4821FF0A.7090508@seznam.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [microblaze-uclinux] [PATCH 04/56] microblaze_v2: Open firmware files
Thread-Index: AciwfUPd7vOwRAPUR2+jKwFh6zzvmQAAUSWA
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>	 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>	 <20080507160432.93FC11750046@mail35-dub.bigfish.com>	 <4821F794.10003@seznam.cz> <fa686aa40805071159ta7076c3va07e63ffd582ada4@mail.gmail.com> <4821FF0A.7090508@seznam.cz>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: <microblaze-uclinux@itee.uq.edu.au>,
       "Grant Likely" <grant.likely@secretlab.ca>
Cc: <linux-kernel@vger.kernel.org>, <arnd@arndb.de>,
       <linux-arch@vger.kernel.org>, "John Linn" <linnj@xilinx.com>,
       <john.williams@petalogix.com>, <matthew@wil.cx>,
       <will.newton@gmail.com>, <drepper@redhat.com>,
       "Paul Mackerras" <paulus@samba.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 07 May 2008 20:14:25.0863 (UTC) FILETIME=[F25D5570:01C8B07E]
Message-Id: <20080507201426.A2B9099005D@mail79-dub.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm don't think all of this code should move.

In particular, parts of prom_parse.c dealing with irqs handle virtual
irqs in a powerpc specific way.
I also think ifdef PPC_PSERIES and PPC_64 and PPC_32 in prom.c are
indicative of the fact that alot of this is dealing with
architecture-specific issues.

Probably some parts of these files, but it's going to take some tweezing
to figure out what parts.

Steve

> -----Original Message-----
> From: owner-microblaze-uclinux@itee.uq.edu.au
[mailto:owner-microblaze-uclinux@itee.uq.edu.au] On
> Behalf Of Michal Simek
> Sent: Wednesday, May 07, 2008 12:12 PM
> To: Grant Likely
> Cc: monstr@seznam.cz; microblaze-uclinux@itee.uq.edu.au;
linux-kernel@vger.kernel.org; arnd@arndb.de;
> linux-arch@vger.kernel.org; John Linn; john.williams@petalogix.com;
matthew@wil.cx;
> will.newton@gmail.com; drepper@redhat.com; Paul Mackerras; Stephen
Rothwell; David Miller
> Subject: Re: [microblaze-uclinux] [PATCH 04/56] microblaze_v2: Open
firmware files
> 
> Hi Grant,
> 
> you understand I use of_device, of_platform and prom_parse. If you do
diff
> between them they will almost the same. One small difference is in
prom.c file.
> 
> I hope we will move these files to drivers/of.
> This is not only question to me.
> 
> Paul, Steve and David: Can I moved these three files to drivers/of?
> 
> Michal
> 
> >> Hi Steve,
> >>
> >>  you are right. Microblaze don't need CONFIG_PPC_something but
> >>  I keep this in files because it will be easier to move this to
better place.
> >>  I wanted to sort what Microblaze don't use.
> >>
> >>  I need to talk with people from sparc and powerpc what we can move
and where.
> >>  I see the best way to push these files to microblaze/kernel/ and
then sychronize
> >>  them with one patch - all archs together.
> >
> > I would disagree.  I think its better to push (and get merged)
patches
> > to move the files first; then add microblaze on top of that.  You
can
> > start getting stuff merged piecemeal that way instead of relying on
> > getting your entire patch series merged at once.
> >
> > However, that's just my opinion, others may look at it differently.
> >
> > Cheers,
> > g.
> >
> 
> ___________________________
> microblaze-uclinux mailing list
> microblaze-uclinux@itee.uq.edu.au
> Project Home Page :
http://www.itee.uq.edu.au/~jwilliams/mblaze-uclinux
> Mailing List Archive :
http://www.itee.uq.edu.au/~listarch/microblaze-uclinux/
> 


