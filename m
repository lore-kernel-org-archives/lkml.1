Return-Path: <linux-kernel-owner+w=401wt.eu-S1763536AbXF1Ouc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763536AbXF1Ouc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 10:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762338AbXF1Ott
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 10:49:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63360 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763435AbXF1Otq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 10:49:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
Subject: Re: [PATCH 3/5 v2] Add the platform device support with RapidIO to MPC8641HPCN platform.
Date: Thu, 28 Jun 2007 16:47:55 +0200
User-Agent: KMail/1.9.6
Cc: linuxppc-dev@ozlabs.org, mporter@kernel.crashing.org, paulus@samba.org,
       linux-kernel@vger.kernel.org
References: <11829333481420-git-send-email-wei.zhang@freescale.com> <200706272256.16418.arnd@arndb.de> <46B96294322F7D458F9648B60E15112C6F31B2@zch01exm26.fsl.freescale.net>
In-Reply-To: <46B96294322F7D458F9648B60E15112C6F31B2@zch01exm26.fsl.freescale.net>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706281647.57408.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19E+Gqt+Zdiyzp3rWUd2Kre7nOw9QftQB+M1N0
 2PzyvXn/78QWOd/UTngO78Z+v88IE2jOW2ajOAvGkhRnl7oNIv
 v1annmAIQb2GaAhx46fhg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 June 2007, Zhang Wei-r63237 wrote:
> > > +static __init int mpc86xx_of_device_init(void)
> > > +{
> > > +       return of_platform_bus_probe(NULL, mpc86xx_of_ids, NULL);
> > > +}
> > 
> > This will add any devices below the "fsl,rapidio-delta" device
> > as an of_device. Is that what you actually want? I would guess that
> > you want to add the bridge itself, not the devices below it.
> > 
> > Is the rapidio device at the root of the device tree, and if so, why
> > not under the soc bus?
> > 
> 
> RapidIO is rather a bus that a device although these is no other nodes defined in its sector now.
> 

That's exactly my point. The meaning of of_platform_bus_probe() is 'add all
direct children of these nodes', not 'add these nodes', although it
happens to do that in the process.

Of course, looking at the device tree, rapidio is a device, not a bus,
because it does not have a device_type and it does not have any children
of its own.

	Arnd <><
