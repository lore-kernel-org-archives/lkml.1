Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490Ab0AGUmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab0AGUmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583Ab0AGUmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:42:14 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:35859 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab0AGUmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:42:13 -0500
Date: Thu, 7 Jan 2010 20:42:12 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Joe Perches <joe@perches.com>
cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] lib/vsprintf.c: Add %pMF to format FDDI bit reversed
 MAC addresses
In-Reply-To: <1262888625.10429.23.camel@Joe-Laptop.home>
Message-ID: <alpine.LFD.2.00.1001072037170.13474@eddie.linux-mips.org>
References: <BD79186B4FD85F4B8E60E381CAEE19090208954A@mi8nycmail19.Mi8.com> <1262888625.10429.23.camel@Joe-Laptop.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010, Joe Perches wrote:

> On Mon, 2010-01-04 at 23:43 +0000, Maciej W. Rozycki wrote:
> > The example below shows an address, and the sequence of bits or symbols 
> > that would be transmitted when the address is used in the Source Address 
> > or Destination Address fields on the MAC header.  The transmission line 
> > shows the address bits in the order transmitted, from left to right.  For 
> > IEEE 802 LANs these correspond to actual bits on the medium.  The FDDI 
> > symbols line shows how the FDDI PHY sends the address bits as encoded 
> > symbols.
> > 
> >         MSB:            35:7B:12:00:00:01
> >         Canonical:      AC-DE-48-00-00-80
> >         Transmission:   00110101 01111011 00010010 00000000 00000000 00000001
> >         FDDI Symbols:   35 7B 12 00 00 01"
> > 
> > Please note that this address has its group bit clear.
> > 
> >  This notation is also defined in the "FDDI MEDIA ACCESS CONTROL-2 
> > (MAC-2)" (X3T9/92-120) document although that book does not have a need 
> > to use the MSB form and it's skipped.
> 
> Adds 56 bytes to object size
> 
> New:
> $ size lib/vsprintf.o
>    text	   data	    bss	    dec	    hex	filename
>    8714	      0	      2	   8716	   220c	lib/vsprintf.o
> old:
> $ size lib/vsprintf.o
>    text	   data	    bss	    dec	    hex	filename
>    8658	      0	      2	   8660	   21d4	lib/vsprintf.o

 What's the gain?  I'd be rather conservative when taking everybody's 56 
bytes for one or two drivers hardly anybody uses.  The format of MAC 
addresses is unlikely to change, so I'd say the sources can live with 
one or two places where the strings are formatted manually.  Even if the 
drivers lose more than these 56 bytes.

  Maciej
