Return-Path: <linux-kernel-owner+w=401wt.eu-S933544AbXCEQns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544AbXCEQns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933559AbXCEQnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:43:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:65320 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933544AbXCEQnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:43:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: bryan.wu@analog.com
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
Date: Mon, 5 Mar 2007 17:43:21 +0100
User-Agent: KMail/1.9.6
Cc: Aubrey Li <aubreylee@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1172722480.5264.75.camel@roc-desktop> <200703050947.10379.arnd@arndb.de> <1173086398.5264.194.camel@roc-desktop>
In-Reply-To: <1173086398.5264.194.camel@roc-desktop>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703051743.22095.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1+X3mPW7xHjO+y9mrOSJVx72W+1UghrUG8fjDR
 AScChy0kufv5XHmDZIW3GkrvInIosqgHNc98w5ti3wBl8xRk22
 lK840591oZCaJ5kO8Nmaw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007, Wu, Bryan wrote:
> Maybe NUMA is a solution, but it is not a wonderful solution.

NUMA doesn't help you. Linux only runs on cache-coherent NUMA,
which this isn't.

> In some application product, BF561 core A is running Linux kernel
> +Applications while BF561 core B is just for some complicated
> video/audio codec algorithm.
> 
> Any Linux multicore solution in BF561 situation is highly welcome.

You definitely can't use the cache mode in this case, but one idea
that should make atomic instructions work is to always do these
on one of the two cores, and use cross-core interrupts to trigger
an update. It's probably pretty inefficient and you also need to
do something about atomic updates (spinlock_t and atomic_t) when
interrupts are disabled.
 
> Another question: when is the merge point from -mm to linus mainline, is
> it the same as the merge window after 2.6.21 released?

It's the same.

	Arnd <><
