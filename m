Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbZF3KUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbZF3KUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 06:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZF3KUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 06:20:15 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:41360 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZF3KUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 06:20:13 -0400
Date: Tue, 30 Jun 2009 06:18:01 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Petr Tesarik <ptesarik@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
       David Daney <ddaney@caviumnetworks.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Introduce a boolean "single_bit_set" function.
In-Reply-To: <1246342379.31661.5.camel@nathan.suse.cz>
Message-ID: <alpine.LFD.2.00.0906300608001.10353@localhost>
References: <alpine.LFD.2.00.0904231339080.13089@localhost.localdomain>  <49F0C817.8050407@caviumnetworks.com>  <20090423165723.16c9f566.akpm@linux-foundation.org>  <alpine.LFD.2.00.0904240632240.16107@localhost.localdomain>  <20090424104651.7c751735.akpm@linux-foundation.org>
  <1246299311.7698.19.camel@nathan.suse.cz>  <alpine.LFD.2.00.0906291448510.3864@localhost> <1246342379.31661.5.camel@nathan.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1910645433-1246357086=:10353"
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

--8323328-1910645433-1246357086=:10353
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 30 Jun 2009, Petr Tesarik wrote:

> Robert P. J. Day p=C3=AD=C5=A1e v Po 29. 06. 2009 v 14:50 -0400:

> >   since i originally muttered about this, the rationale behind it
> > was not for performance (obviously), but for semantic
> > clarification, so that when you saw the expression "n & (n-1)", it
> > was more obvious which test you were doing semantically:
> >
> > 1) is n a power of 2?
> > 2) does n represent a single set bit?
> >
> > nothing ever came of that, but that was the thinking behind it.
>
> Yes, I can remember and I would still appreciate it. It's always
> better to show _what_ the code does rather than _how_ it does it.
>
> IIRC Andrew rejected your patch on the grounds that it is possible
> to replace the expression "n & (n-1)" with "hweight(n) =3D=3D 1" if one
> wants to show that it really tests for a single bit set. But I don't
> like his proposal quite as much as yours, because of the big
> overhead.
>
> In short, if you re-post your patch, I'll gladly join you in the
> battle of getting it in. ;-)

  i never meant for this to turn into a pitched battle of
philosophies -- it just seemed like a simple way to make the code
clearer, particularly since some of the patches i've submitted allowed
for the removal of comments like "test that blocksize is a power of
2" given that what you're testing is now painfully obvious. :-)

  if someone has a quick, simple and performance non-crippling
suggestion for this, i'm all ears.  but there's no point thinking
about it if it's actually going to cause performance issues.

rday

p.s.  a simple grep to find potential cleanup of the form n&(n-1):

grep -Ern "([^\(\)]+) ?\& ?\(\1 ?- ?1\)" * | less

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
--8323328-1910645433-1246357086=:10353--
