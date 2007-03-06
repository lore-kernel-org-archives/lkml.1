Return-Path: <linux-kernel-owner+w=401wt.eu-S964896AbXCFLEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964896AbXCFLEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 06:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964931AbXCFLEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 06:04:41 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:32785 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964896AbXCFLEk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 06:04:40 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5.7226.0
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 1/1] ppc: Possible bug fix for FCC driver
Date: Tue, 6 Mar 2007 12:03:57 +0100
Message-ID: <00B1F4365DDBE745B091C67A1CCFCB4307124DB1@zctfhxm1>
In-Reply-To: <20070306124218.4bebc288@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 1/1] ppc: Possible bug fix for FCC driver
Thread-Index: Acdf08ASKLZJHcf3SQW9/huDZQ9GIQACSOWA
From: "Cedric Pontois" <cpontois@nortel.com>
To: "Vitaly Bordug" <vbordug@ru.mvista.com>,
       "Li Yang-r58472" <LeoLi@freescale.com>
Cc: <dmalek@jlc.net>, <linux-kernel@vger.kernel.org>,
       <linuxppc-embedded@ozlabs.org>, "Rachid Koucha" <koucha@nortel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vitaly,

The problem seems to be similar in recent kernels
(/drivers/net/fs_enet/mac-fcc.c). The transmit clock is inverted (TCI
bit set). The packets are well received, transmitted packets go out (tx
counter is ok), unfortunately as the clock is inverted (TCI) the data
are not correctly received by the other side. The FCC works in 100Mbps
(luck?) but doesn't in 10Mbps. I solved this problem by removing the TCI
bit set as described in the patch. Actually, this problem depends also
of the Ethernet phy used on board.

Cedric

-----Original Message-----
From: Vitaly Bordug [mailto:vbordug@ru.mvista.com] 
Sent: mardi 6 mars 2007 10:42
To: Li Yang-r58472
Cc: Pontois, Cedric UMTS (CEZ:8Z10); dmalek@jlc.net;
linux-kernel@vger.kernel.org; linuxppc-embedded@ozlabs.org
Subject: Re: [patch 1/1] ppc: Possible bug fix for FCC driver


On Tue, 6 Mar 2007 10:23:43 +0800
Li Yang-r58472 wrote:

> Hi Cedric,
> 
> For ppc embedded related patches, please also cc: 
> linuxppc-embedded@ozlabs.org.
> 
> > We use a kernel 2.6.14 on PPC platform (MPC 8555). The FCC driver
> works
> 
> To submit a kernel patch upstream, the patch should be against the 
> latest kernel version which is 2.6.21-rc now.
> > well with a 100Mbps link. But it doesn't with a 10Mbps link. To 
> > solve it, I modified the GFMR register init: removed TCI bit and set

> > CRC32
> bit
> > instead of.
> 
> I don't know how these bits caused the 10M link issue.  Do you have 
> any reasoning?
> 
> > 	Signed-off-by: Cedric Pontois <cpontois@nortel.com>
> > 
> >
> ----------------------------------------------------------------------
> --
> > -----
> > 
> > diff -ruN pa-original/arch/ppc/8260_io/fcc_enet.c
The fcc code in 8260_io has been obsoleted by fs_enet driver
(drivers/net/fs_enet). It is known to work with 85xx at least in recent
kernels. If it does not for some reason, please letus know.

Thanks,

-Vitaly
