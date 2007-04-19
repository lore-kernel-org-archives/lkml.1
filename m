Return-Path: <linux-kernel-owner+w=401wt.eu-S1422710AbXDSW4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422710AbXDSW4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 18:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422717AbXDSW4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 18:56:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63365 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422710AbXDSW4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 18:56:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sergey Yanovich <ynvich@gmail.com>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
Date: Fri, 20 Apr 2007 00:56:33 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Pierre Ossman <drzeus-mmc@drzeus.cx>
References: <4627D6CB.1050107@gmail.com>
In-Reply-To: <4627D6CB.1050107@gmail.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704200056.33866.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+aRCgFe5WePLT2DYgWGboACt6FmaL9g6E0GHe
 BAo/NhXojQDPBk6smIwXGNVA1yLO4inGC2CiMDUck4FqaJsawb
 SInYZ6Pg2+6H8pGCQICFg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 April 2007, Sergey Yanovich wrote:
> The device is present in many notebooks. Notebooks depend heavily on 
> suspend/resume functionality. tifm_core/7xx1/sd family is an ambitous, 
> but uncompleted project. It used to crash on resuming, or hang up on 
> suspending. A less common failure used to be trigerred by a fast card 
> insert/removal sequence. Finally, tifm_sd module needs to be manually 
> inserted.

As very general comments, you should have the maintainer of the subsystem
(Pierre in this case) on Cc when posting a driver, and you should include
the patch inline in your mail, see Documentation/SubmittingPatches.

More specific to your patch:

You should include the Makefile and Kconfig changes in the same patch/mail,
no point splitting these out.

Don't define your own DBG macro, instead use the predefined dev_dbg()
that has a similar definition.

Your mmc_tifm_irq_chip() function does a _very_ long delay of 100
miliseconds. This is normally not acceptable, since it is a noticeable
time in which the system is completely unresponsive. Maybe you can convert
the tasklet to a workqueue, which lets you call msleep instead of mdelay.

Your use of pci_map_sg() looks wrong, you simply can't assume that the
return value is '1' in general. I've stumbled over that same problem
in the sdhci driver, so it may be inherent to the mmc layer and not
be driver specific.

Other than that, your driver looks pretty good to me.

	Arnd <><
