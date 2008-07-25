Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbYGYIqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbYGYIqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 04:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYGYIqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 04:46:13 -0400
Received: from trinity.fluff.org ([89.145.97.151]:36192 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbYGYIqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 04:46:12 -0400
Date: Fri, 25 Jul 2008 09:46:07 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: David Miller <davem@davemloft.net>
Cc: ben-linux@fluff.org, bzolnier@gmail.com, harvey.harrison@gmail.com,
       linux-ide@kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: recent IDE regression
Message-ID: <20080725084607.GQ26938@trinity.fluff.org>
References: <20080724.233831.193691312.davem@davemloft.net> <20080725083448.GE8301@fluff.org.uk> <20080725.014252.193706389.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725.014252.193706389.davem@davemloft.net>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 01:42:52AM -0700, David Miller wrote:
> From: Ben Dooks <ben-linux@fluff.org>
> Date: Fri, 25 Jul 2008 09:34:48 +0100
> 
> > On Thu, Jul 24, 2008 at 11:38:31PM -0700, David Miller wrote:
> > > diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
> > > index 07da5fb..8aae917 100644
> > > --- a/drivers/ide/ide-iops.c
> > > +++ b/drivers/ide/ide-iops.c
> > > @@ -510,10 +510,8 @@ void ide_fixstring (u8 *s, const int bytecount, const int byteswap)
> > >  
> > >  	if (byteswap) {
> > >  		/* convert from big-endian to host byte order */
> > > -		for (p = end ; p != s;) {
> > > -			unsigned short *pp = (unsigned short *) (p -= 2);
> > > -			*pp = ntohs(*pp);
> > > -		}
> > > +		for (p = end ; p != s;)
> > > +			be16_to_cpus((u16 *)(p -= 2));
> > 
> > personally, i would much prefer to see the loop being less evil
> > like:
> > 
> > 	for (p = s; p < end; p += 2)
> > 		be16_to_cpus((u16 *)p);
> > 
> > is there an architecture/compiler combo which really makes this
> > evil worthwile? on arm (gcc 4.2), both evaluate to the same number of
> > instructions.
> 
> Regardless of what we want to do with this ugly loop, the endianness
> macros should be fixed to consistently evaluate their arguments
> once just like real function calls do.

Yes, I wasn't saying the macro fixes are not worthwile. I would also
like to see the loop being fixed to not perpetrate this nasty code
any further.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

