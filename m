Return-Path: <linux-kernel-owner+w=401wt.eu-S934638AbXGUNyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934638AbXGUNyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 09:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757619AbXGUNyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 09:54:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58675 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761000AbXGUNyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 09:54:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] compat_ioctl requires CONFIG_BLOCK
Date: Sat, 21 Jul 2007 15:17:14 +0200
User-Agent: KMail/1.9.6
Cc: Sebastian Siewior <sebastian@breakpoint.cc>, linux-kernel@vger.kernel.org
References: <20070720225817.050195257@ayoka.breakpoint.cc> <200707210108.58478.arnd@arndb.de> <20070721124418.GA23802@infradead.org>
In-Reply-To: <20070721124418.GA23802@infradead.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707211517.15736.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19yiexxYhUY1ir2njg9ehM0WrtMODrJMbtLnDZ
 UxoiHNfl+UEKCspUNks8EOFlvtgAsIoir/fEQqcy+47Y5JXP32
 sO09IhwmCmWZGu25qneJw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 July 2007, Christoph Hellwig wrote:
> 
> > Adding #ifdef around an #include is considered bad style. Better just
> > make loop.h compile without any conditionals. Does the below
> > patch work for you?
> 
> That patch looks good, but even better would be adding a compat_ioctl
> handler to the loop driver.  IIRC you even have an old patch for that 

No, that doesn't fly in this case. The loop driver actually has a
compat_ioctl method, but the problem is that some tools try to
call this ioctl on devices other than loop.

We could of course add a fallback handler to compat_blkdev_ioctl(),
but I'm not convinced that this is better than the IGNORE_IOCTL
helper, unless we eventually move all of fs/compat_ioctl.c into
drivers.

	Arnd <><
