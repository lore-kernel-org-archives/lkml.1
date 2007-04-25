Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbXDYXAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbXDYXAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbXDYXAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:00:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:53867 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbXDYXAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:00:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sergey Yanovich <ynvich@gmail.com>
Subject: Re: [PATCH] [mmc] [tifm] Reduces delay in card insert/removal
Date: Thu, 26 Apr 2007 01:00:30 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
References: <11775383653672-git-send-email-ynvich@gmail.com> <11775383661213-git-send-email-ynvich@gmail.com>
In-Reply-To: <11775383661213-git-send-email-ynvich@gmail.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704260100.31035.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+WBNlWe4834ni3eBzF7gAHjdMGv4Jk9x+0T+D
 HqdzhP0+8nUuCvNO4ks1Vnw/ADnKcw6wZWcYKOZeHztMS87498
 msl3GO+wwcmfilpoWjz8g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 April 2007, Sergey Yanovich wrote:

> First, I tried to replace 'mdelay' with 'msleep' and put it after
> 'unlock'. It gives a certain oops.
> 
> With the delay of 50 msec driver remains stable. It has something
> to do with hardware initialization, so this value should not be
> affected by CPU speed. I hope so.
> 
> Signed-off-by: Sergey Yanovich <ynvich@gmail.com>

No, 50ms is still too much, I'd consider every instance of 'mdelay'
to be a bug in general, except maybe with exceptionally broken
hardware, which I don't think this is.

The reason that it gave you an oops is that you call it from
a tasklet. You have to convert the tasklet to a workqueue at the
same time if you want to sleep inside it. In fact, it might
be a good idea to convert all the tasklets in that driver
to use schedule_work instead.

	Arnd <><
