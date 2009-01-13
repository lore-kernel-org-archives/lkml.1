Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbZAMRnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbZAMRnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 12:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZAMRnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 12:43:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63211 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZAMRnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 12:43:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [PATCH RFC v5] net: add PCINet driver
Date: Tue, 13 Jan 2009 18:42:53 +0100
User-Agent: KMail/1.9.9
Cc: Rusty Russell <rusty@rustcorp.com.au>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       shemminger@vyatta.com, netdev@vger.kernel.org
References: <20090107195052.GA24981@ovro.caltech.edu> <200901131733.04341.arnd@arndb.de> <20090113164007.GA7434@ovro.caltech.edu>
In-Reply-To: <20090113164007.GA7434@ovro.caltech.edu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901131842.54688.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18mgRkgDAzkB2FRvQtsvay9H9FKtWQbGfZCWvw
 BocLGfWms7Zh/ydFDuCy49U/rxVAf24pJmaFMvYaBbz5u04QSW
 On9HqiABzNre5yqQ2Yd4w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2009, Ira Snyder wrote:
> So do you program one channel of the DMA engine from the host side and
> another channel from the guest side?

Yes.

> I tried to avoid having the host program the DMA controller at all.
> Using the DMAEngine API on the guest did better than I could achieve by
> programming the registers manually. I didn't use chaining or any of the
> fancier features in my tests, though.

Our driver unfortunately does not use the DMA API, but it clearly
should. What this means in your case is that you would need to port
the freescale DMA engine driver to the host side, to operate on the
PCI device. Not sure about how specifically this would work on fsl
hardware, but it seems generally doable.

	Arnd <><
