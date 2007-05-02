Return-Path: <linux-kernel-owner+w=401wt.eu-S1767152AbXEBWsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767152AbXEBWsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767156AbXEBWsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:48:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:54332 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767152AbXEBWsB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:48:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Fulghum <paulkf@microgate.com>
Subject: Re: [PATCH] synclink_gt add compat_ioctl
Date: Thu, 3 May 2007 00:47:55 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1178137281.10111.8.camel@amdx2.microgate.com> <200705030009.11502.arnd@arndb.de> <46392142.2030201@microgate.com>
In-Reply-To: <46392142.2030201@microgate.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705030047.56286.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1//cHC3Amvl6J21b2n6sh2xjQJSk1vHHQA8Poh
 CTNcc8APPBZxAFiPy3mZTv0Q0Eaz3dH4nFctYZYk2ly2gJZSNF
 Kj7abaRsnPvQen5yoAggA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 May 2007, Paul Fulghum wrote:
> >> +
> >> +    spin_lock_irqsave(&info->lock, flags);
> > 
> > no need for _irqsave, just use spin_{,un}lock_irq() when you know that
> > interrupts are enabled.
> 
> That makes me a little uneasy. The locking
> mechanisms (and just about everything else) above the driver
> seem to change frequently. This involves not just the VFS but
> the tty core as well.
> 
> If you are confident this will not change, I will
> switch to spin_lock(). I used spin_lock_irqsave() to be
> more robust against changes to behavior outside my driver.

The same function contains a copy_from_user(), which cannot
be called with interrupts disabled, so yes, I am very certain
it will not change.

	Arnd <><
