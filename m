Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbYGYInT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbYGYInT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 04:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbYGYImy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 04:42:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48085
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755489AbYGYImx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 04:42:53 -0400
Date: Fri, 25 Jul 2008 01:42:52 -0700 (PDT)
Message-Id: <20080725.014252.193706389.davem@davemloft.net>
To: ben-linux@fluff.org
Cc: bzolnier@gmail.com, harvey.harrison@gmail.com, linux-ide@kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: recent IDE regression
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080725083448.GE8301@fluff.org.uk>
References: <20080724.233831.193691312.davem@davemloft.net>
	<20080725083448.GE8301@fluff.org.uk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Dooks <ben-linux@fluff.org>
Date: Fri, 25 Jul 2008 09:34:48 +0100

> On Thu, Jul 24, 2008 at 11:38:31PM -0700, David Miller wrote:
> > diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
> > index 07da5fb..8aae917 100644
> > --- a/drivers/ide/ide-iops.c
> > +++ b/drivers/ide/ide-iops.c
> > @@ -510,10 +510,8 @@ void ide_fixstring (u8 *s, const int bytecount, const int byteswap)
> >  
> >  	if (byteswap) {
> >  		/* convert from big-endian to host byte order */
> > -		for (p = end ; p != s;) {
> > -			unsigned short *pp = (unsigned short *) (p -= 2);
> > -			*pp = ntohs(*pp);
> > -		}
> > +		for (p = end ; p != s;)
> > +			be16_to_cpus((u16 *)(p -= 2));
> 
> personally, i would much prefer to see the loop being less evil
> like:
> 
> 	for (p = s; p < end; p += 2)
> 		be16_to_cpus((u16 *)p);
> 
> is there an architecture/compiler combo which really makes this
> evil worthwile? on arm (gcc 4.2), both evaluate to the same number of
> instructions.

Regardless of what we want to do with this ugly loop, the endianness
macros should be fixed to consistently evaluate their arguments
once just like real function calls do.
