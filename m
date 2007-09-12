Return-Path: <linux-kernel-owner+w=401wt.eu-S1764396AbXILIul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764396AbXILIul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 04:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303AbXILIue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 04:50:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64749 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbXILIud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 04:50:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org, michael@ellerman.id.au
Subject: Re: [PATCH 15/15] Add DEFINE_SPUFS_ATTRIBUTE()
Date: Wed, 12 Sep 2007 10:47:04 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070831.706792)
Cc: Jeremy Kerr <jk@ozlabs.org>, linux-kernel@vger.kernel.org
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au> <f5fe712aef37d925902f3f6183f024b916cc89db.1189583010.git.michael@ellerman.id.au> <1189583353.17835.22.camel@concordia.ozlabs.ibm.com>
In-Reply-To: <1189583353.17835.22.camel@concordia.ozlabs.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709121047.05471.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX196byxUU68j+j4rJ2XkHg12+oYWRc7KjXVHKdm
 iPlD4LiZUyqEfPobmieNCwfJQE4xAdsC9QiPWAWoHhnjH9L+xG
 BopwzXK+W4cfPtPtqcNCA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007, Michael Ellerman wrote:
> On Wed, 2007-09-12 at 17:43 +1000, Michael Ellerman wrote:
> > This patch adds DEFINE_SPUFS_ATTRIBUTE(), a wraper around
> > DEFINE_SIMPLE_ATTRIBUTE which does the specified locking for the get
> > routine for us.
> > 
> > Unfortunately we need two get routines (a locked and unlocked version) to
> > support the coredump code. This patch hides one of those (the locked version)
> > inside the macro foo.

> 
> jk said:
> > "Good god man!"
> 
> Yeah, I'm a bit lukewarm on this one. But the diffstat is nice, 50% code
> reduction ain't bad :)

Have you looked at the change in object code size? I would expect the
object code to actually become bigger. I also think that it hurts
readability rather than help it.

Maybe a better solution is to change the core dump code to not
require the mutex to be held in the first place. By the time
we get to call the get functions, it should already be in
saved state and no longer be able to get scheduled, so we might
not actually need all the extra tricks with avoiding the
mutex to be taken again.

	Arnd <><
