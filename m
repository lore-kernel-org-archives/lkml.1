Return-Path: <linux-kernel-owner+w=401wt.eu-S933199AbZHVCw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199AbZHVCw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 22:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933183AbZHVCw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 22:52:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:14231 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933177AbZHVCw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 22:52:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=eIV677/iaPDWchbMZ/GgKNy1Kap8Qf6rD3ZjS59aoTpRqvYMPV0WXHCU5C2Ee4Fg4W
         CtFbVoAMu/+5SqcbhPUr+J7gB8qozenOcCdpKDyGmUqeWRTX7pWEtEClMbzXdWYCflmd
         6yhiBIkB4/IEKDTXuBVNDW/nmQon+PLBBuz+o=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Nicolas Pitre <nico@cam.org>
Subject: Re: [PATCH] Convert MMC subsys drivers to dev_pm_ops
Date: Sat, 22 Aug 2009 04:52:05 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-1-amd64; KDE/4.3.0; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
       mirq-linux@rere.qmqm.pl, lkml <linux-kernel@vger.kernel.org>,
       manuel.lauss@gmail.com, ppisa@pikron.com, maen@marvell.com,
       s.hauer@pengutronix.de, tony@atomide.com, madhu.cr@ti.com,
       drzeus@drzeus.cx, ben-linux@fluff.org, avorontsov@ru.mvista.com,
       pierre@ossman.eu, sdhci-devel@lists.ossman.eu, saschasommer@freenet.de,
       oakad@yahoo.com, ian@mnementh.co.uk, HaraldWelte@viatech.com,
       JosephChan@via.com.tw
References: <200908220223.50588.marek.vasut@gmail.com> <alpine.LFD.2.00.0908212234150.6044@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.0908212234150.6044@xanadu.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908220452.05108.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne So 22. srpna 2009 04:44:00 Nicolas Pitre napsal(a):
> On Sat, 22 Aug 2009, Marek Vasut wrote:
> > Hi,
> >
> > This converts most of the drivers found in drivers/mmc/host to
> > dev_pm_ops. Also, it contains some fixes for the probe/remove functions
> > in some cases.
>
> Are you sure you're actually fixing things?
>
> You replaced platform_driver_probe() calls with
> platform_driver_register() calls, and made the probe functions __devinit
> instead of __init.  Especially when the platform device is unlikely to
> go away or new ones to ever appear, there is no point keeping the
> probe code around after it is done.

Yeah, the __devinit should actually remove the init function when done ... to 
my understanding. Sorry in case I'm wrong.
>
>
> Nicolas
