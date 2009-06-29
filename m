Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbZF2Sw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbZF2Sw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbZF2Swt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:52:49 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:47006 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881AbZF2Sws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:52:48 -0400
Date: Mon, 29 Jun 2009 14:50:31 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Petr Tesarik <ptesarik@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
       David Daney <ddaney@caviumnetworks.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Introduce a boolean "single_bit_set" function.
In-Reply-To: <1246299311.7698.19.camel@nathan.suse.cz>
Message-ID: <alpine.LFD.2.00.0906291448510.3864@localhost>
References: <alpine.LFD.2.00.0904231339080.13089@localhost.localdomain>  <49F0C817.8050407@caviumnetworks.com>  <20090423165723.16c9f566.akpm@linux-foundation.org>  <alpine.LFD.2.00.0904240632240.16107@localhost.localdomain>  <20090424104651.7c751735.akpm@linux-foundation.org>
 <1246299311.7698.19.camel@nathan.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-178087832-1246301440=:3864"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-178087832-1246301440=:3864
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 29 Jun 2009, Petr Tesarik wrote:

> Andrew Morton p=C3=AD=C5=A1e v P=C3=A1 24. 04. 2009 v 10:46 -0700:
> > On Fri, 24 Apr 2009 06:40:39 -0400 (EDT) "Robert P. J. Day" <rpjday@cra=
shcourse.ca> wrote:
> >
> > >   so it would be a simple matter to define the bit set boolean in
> > > terms of hweight_long(), yes?  so what about, in bitops.h:
> > >
> > >   static inline bool
> > >   exactly_one_bit_set(unsigned long w)
> > >   {
> > > =09return hweight_long(w) =3D=3D 1;
> > >   }
> > >
> > >   static inline bool
> > >   more_than_one_bit_set(unsigned long w)
> > >   {
> > > =09return hweight_long(w) > 1;
> > >   }
> > >
>
> Andrew, you must be kidding! Are you seriously suggesting to replace
> a simple and instruction with a call to an extern library function
> with 17 instructions (not including the call and ret)?
>
> I'd better check the use of hweight in the kernel to eradicate as
> many calls to it as possible...

  since i originally muttered about this, the rationale behind it was
not for performance (obviously), but for semantic clarification, so
that when you saw the expression "n & (n-1)", it was more obvious
which test you were doing semantically:

1) is n a power of 2?
2) does n represent a single set bit?

nothing ever came of that, but that was the thinking behind it.

rday
--

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--8323328-178087832-1246301440=:3864--
