Return-Path: <linux-kernel-owner+w=401wt.eu-S1030238AbXCFVp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030238AbXCFVp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030224AbXCFVp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:45:26 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:13013 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030242AbXCFVpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:45:24 -0500
Date: Wed, 7 Mar 2007 00:45:14 +0300
From: Vitaly Bordug <vbordug@ru.mvista.com>
To: "Cedric Pontois" <cpontois@nortel.com>
Cc: "Li Yang-r58472" <LeoLi@freescale.com>, <dmalek@jlc.net>,
       <linux-kernel@vger.kernel.org>, <linuxppc-embedded@ozlabs.org>,
       "Rachid Koucha" <koucha@nortel.com>
Subject: Re: [patch 1/1] ppc: Possible bug fix for FCC driver
Message-ID: <20070307004514.76bb83cc@localhost.localdomain>
In-Reply-To: <00B1F4365DDBE745B091C67A1CCFCB4307124DB1@zctfhxm1>
References: <20070306124218.4bebc288@localhost.localdomain>
	<00B1F4365DDBE745B091C67A1CCFCB4307124DB1@zctfhxm1>
X-Mailer: Claws Mail 2.7.2cvs30 (GTK+ 2.10.9; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007 12:03:57 +0100
Cedric Pontois wrote:

> Hi Vitaly,
> 
> The problem seems to be similar in recent kernels
> (/drivers/net/fs_enet/mac-fcc.c). The transmit clock is inverted (TCI
> bit set). The packets are well received, transmitted packets go out
> (tx counter is ok), unfortunately as the clock is inverted (TCI) the
> data are not correctly received by the other side. The FCC works in
> 100Mbps (luck?) but doesn't in 10Mbps. I solved this problem by
> removing the TCI bit set as described in the patch. Actually, this
> problem depends also of the Ethernet phy used on board.
> 
IIRC it worked for us with Davicom PHY on 10 MBps on one of 8260-like...
 
Well I give it a try once more with the recent kernel, but anyway if you think 
you've located and fixed root cause, do (and test) a patch against recent kernel,
send it to me cc'ing netdev and linuxppc-embedded, and I'll push it along
if it is not breaking existing boards.

-Vitaly

> Cedric
> 
> -----Original Message-----
> From: Vitaly Bordug [mailto:vbordug@ru.mvista.com] 
> Sent: mardi 6 mars 2007 10:42
> To: Li Yang-r58472
> Cc: Pontois, Cedric UMTS (CEZ:8Z10); dmalek@jlc.net;
> linux-kernel@vger.kernel.org; linuxppc-embedded@ozlabs.org
> Subject: Re: [patch 1/1] ppc: Possible bug fix for FCC driver
> 
> 
> On Tue, 6 Mar 2007 10:23:43 +0800
> Li Yang-r58472 wrote:
> 
> > Hi Cedric,
> > 
> > For ppc embedded related patches, please also cc: 
> > linuxppc-embedded@ozlabs.org.
> > 
> > > We use a kernel 2.6.14 on PPC platform (MPC 8555). The FCC driver
> > works
> > 
> > To submit a kernel patch upstream, the patch should be against the 
> > latest kernel version which is 2.6.21-rc now.
> > > well with a 100Mbps link. But it doesn't with a 10Mbps link. To 
> > > solve it, I modified the GFMR register init: removed TCI bit and
> > > set
> 
> > > CRC32
> > bit
> > > instead of.
> > 
> > I don't know how these bits caused the 10M link issue.  Do you have 
> > any reasoning?
> > 
> > > 	Signed-off-by: Cedric Pontois <cpontois@nortel.com>
> > > 
> > >
> > ----------------------------------------------------------------------
> > --
> > > -----
> > > 
> > > diff -ruN pa-original/arch/ppc/8260_io/fcc_enet.c
> The fcc code in 8260_io has been obsoleted by fs_enet driver
> (drivers/net/fs_enet). It is known to work with 85xx at least in
> recent kernels. If it does not for some reason, please letus know.
> 
> Thanks,
> 
> -Vitaly
