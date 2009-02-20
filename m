Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbZBTVL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbZBTVL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 16:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZBTVLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 16:11:47 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:31907 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751170AbZBTVLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 16:11:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UFWDNEn6zZ/jEdKsq5CHaY3awuXxrkvxbv0dof5Wy4Dvz8UYjpVk9x8RnuF93LF+2p1eGS0Y7LXd2wJymK2bG2WBlYOT19oloAOwANAQZDS7JTkkDiaNv61m5n7wcdWNaxx/BAPf0hbIdeRDBSTho9uLL8dwzhrR0oYl03zf7EU=  ;
X-YMail-OSG: IPQ1C.EVM1nJLRalgFR_fCZq6u1zjekfDzFAefP5HEcx_lZkGBCA2wWaHQKERpyTeH.9e3Mka2bpPJvEu9z4Pv5JjiyG3dLvLeDK.MTMJxCYcc2h2jPxY7x12BCDfSyUvrRmN8X.dhS4GjWJzi70TIj0
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Kim Kyuwon <chammoru@gmail.com>
Subject: Re: [PATCH] OMAP: HSMMC: Initialize hsmmc controller registers when  resuming
Date: Fri, 20 Feb 2009 13:11:43 -0800
User-Agent: KMail/1.9.10
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx,
       =?utf-8?q?=EA=B9=80=EA=B7=9C=EC=9B=90?= <q1.kim@samsung.com>,
       =?utf-8?q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>
References: <4d34a0a70902200400s252f48ddvfd6e0d83e91fa291@mail.gmail.com>
In-Reply-To: <4d34a0a70902200400s252f48ddvfd6e0d83e91fa291@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902201311.44056.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 February 2009, Kim Kyuwon wrote:
> +static void omap_hsmmc_init(struct mmc_omap_host *host)
> +{
> +       u32 hctl, capa, value;
> +
> +       /* Only MMC1 supports 3.0V */
> +       if (host->id == OMAP_MMC1_DEVID) {
> +               hctl = SDVS30;

Shouldn't it be remembering what voltage it was using,
and then restore that, instead of always making MMC1
restart at a 3.0V level?  That's pretty awkward to test
unless you have a 1.8V-capable card in MMC1...

Somewhat related:  I think the PBIAS register updates
should be moved out of mach-omap2/mmc-twl4030.c into
this driver.  They're needed no matter what flavor
regulator is used to with MMC1 voltage over 1.8V,
and it's a bit odd to split the state machine for
1.8V -vs- 3.0V I/O voltages the way it's now done.

- Dave

