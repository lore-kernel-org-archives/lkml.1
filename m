Return-Path: <linux-kernel-owner+w=401wt.eu-S965760AbXCFCWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965760AbXCFCWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 21:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965764AbXCFCWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 21:22:30 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:49571 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965760AbXCFCW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 21:22:28 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [patch 1/1] ppc: Possible bug fix for FCC driver
Date: Tue, 6 Mar 2007 10:23:43 +0800
Message-ID: <989B956029373F45A0B8AF02970818902DA97B@zch01exm26.fsl.freescale.net>
In-Reply-To: <00B1F4365DDBE745B091C67A1CCFCB43070CE21E@zctfhxm1>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 1/1] ppc: Possible bug fix for FCC driver
Thread-Index: AcdfDtbC24HBg98sQZWoIfIKQy9fJgAhrfSw
From: "Li Yang-r58472" <LeoLi@freescale.com>
To: "Cedric Pontois" <cpontois@nortel.com>, <dmalek@jlc.net>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-embedded@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cedric,

For ppc embedded related patches, please also cc:
linuxppc-embedded@ozlabs.org.

> We use a kernel 2.6.14 on PPC platform (MPC 8555). The FCC driver
works

To submit a kernel patch upstream, the patch should be against the
latest kernel version which is 2.6.21-rc now.
> well with a 100Mbps link. But it doesn't with a 10Mbps link. To solve
> it, I modified the GFMR register init: removed TCI bit and set CRC32
bit
> instead of.

I don't know how these bits caused the 10M link issue.  Do you have any
reasoning?

> 	Signed-off-by: Cedric Pontois <cpontois@nortel.com>
> 
>
------------------------------------------------------------------------
> -----
> 
> diff -ruN pa-original/arch/ppc/8260_io/fcc_enet.c
> pa-patched/arch/ppc/8260_io/fcc_enet.c
> --- pa-original/arch/ppc/8260_io/fcc_enet.c	2007-03-02
> 14:57:07.000197000 +0100
> +++ pa-patched/arch/ppc/8260_io/fcc_enet.c	2007-03-02
> 14:57:08.000038000 +0100
> @@ -2232,7 +2232,7 @@
> 
>  	/* Set GFMR to enable Ethernet operating mode.
>  	 */
> -	fccp->fcc_gfmr = (FCC_GFMR_TCI | FCC_GFMR_MODE_ENET);
> +	fccp->fcc_gfmr = (FCC_GFMR_TCRC_32 | FCC_GFMR_MODE_ENET);
> 
>  	/* Set sync/delimiters.
>  	*/
> 

