Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbZH1LDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbZH1LDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 07:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZH1LDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 07:03:11 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:45740 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbZH1LDK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 07:03:10 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2] powerpc/85xx: Add eSDHC support for MPC8536DS boards
Date: Fri, 28 Aug 2009 19:02:51 +0800
Message-ID: <73839B4A0818E747864426270AC332C304438438@zmy16exm20.fsl.freescale.net>
In-Reply-To: <20090819015101.GA10782@oksana.dev.rtsoft.ru>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2] powerpc/85xx: Add eSDHC support for MPC8536DS boards
Thread-Index: Acogb5k9dl03iogfTlCzVWvOXExzKAHW2zgA
References: <20090807195724.GA24020@oksana.dev.rtsoft.ru><20090807195822.GG2735@oksana.dev.rtsoft.ru><A17F24A0-87E0-4FFA-9C14-DF57D8A9D015@kernel.crashing.org><20090818233818.GA29042@oksana.dev.rtsoft.ru><F58A75CD-73CC-4F75-AF51-2BCC0B828E84@kernel.crashing.org> <20090819015101.GA10782@oksana.dev.rtsoft.ru>
From: "Hu Mingkai-B21284" <Mingkai.Hu@freescale.com>
To: <avorontsov@ru.mvista.com>, "Kumar Gala" <galak@kernel.crashing.org>
Cc: "Ben Dooks" <ben@fluff.org>, <linux-kernel@vger.kernel.org>,
       <sdhci-devel@lists.ossman.eu>, <linuxppc-dev@ozlabs.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Pierre Ossman" <pierre@ossman.eu>,
       "David Vrabel" <david.vrabel@csr.com>
X-Brightmail-Tracker: AAAAAQAAAWE=
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: 
> linuxppc-dev-bounces+b21284=freescale.com@lists.ozlabs.org 
> [mailto:linuxppc-dev-bounces+b21284=freescale.com@lists.ozlabs
> .org] On Behalf Of Anton Vorontsov
> Sent: Wednesday, August 19, 2009 9:51 AM
> To: Kumar Gala
> Cc: Ben Dooks; linux-kernel@vger.kernel.org; 
> sdhci-devel@lists.ossman.eu; linuxppc-dev@ozlabs.org; Andrew 
> Morton; Pierre Ossman; David Vrabel
> Subject: Re: [PATCH v2] powerpc/85xx: Add eSDHC support for 
> MPC8536DS boards
> 
> On Tue, Aug 18, 2009 at 08:24:17PM -0500, Kumar Gala wrote:
> > 
> > On Aug 18, 2009, at 6:38 PM, Anton Vorontsov wrote:
> > 
> > >This patch simply adds sdhci node to the device tree.
> > >
> > >We specify clock-frequency manually, so that eSDHC will 
> work without 
> > >upgrading U-Boot. Though, that'll only work for default setup (1500
> > >MHz) on new board revisions. For non-default setups, it's 
> recommended 
> > >to upgrade U-Boot, since it will fixup clock-frequency 
> automatically.
> > >
> > >Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > 
> > out of interest the 85xx eSDHC don't need the sdhci,wp-inverted 
> > property?
> 
> Yes, eSDHC controllers in MPC85xx report normal state in its 
> registers.
> 

Hi Anton,

The eSDHC controller in different silicon version on MPC8536  reports
different WP state in the register PRSSTAT:

Silicon 1.0:

Card WP pos    PRSSTAT[WPSPL]    RMMCR[SDHC_WP]    GENCFG[SDHC_WP_INV]
------------------------------------------------------------------------
---------------------------------------------
unLock               1                                   1
/
Lock                    0                                   1
/

Silicon 1.1:

Card WP pos    PRSSTAT[WPSPL]    RMMCR[SDHC_WP]    GENCFG[SDHC_WP_INV]
------------------------------------------------------------------------
---------------------------------------------
unLock               0                                   1
0
Lock                    1                                   1
0

Note: the register GENCFG is added on silicon 1.1 to invert the WP
state.

For silicon 1.0,  the macro SDHCI_QUIRK_INVERTED_WRITE_PROTECT is also
defined,
so the dirver will report the error WP state in function sdhci_get_ro.

Best regards,
Mingkai
