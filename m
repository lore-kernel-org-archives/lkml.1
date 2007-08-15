Return-Path: <linux-kernel-owner+w=401wt.eu-S932761AbXHOOw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761AbXHOOw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932601AbXHOOwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:52:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49785 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765163AbXHOOv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:51:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 6/24] make atomic_read() behave consistently on frv
Date: Wed, 15 Aug 2007 15:29:43 +0200
User-Agent: KMail/1.9.6
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Herbert Xu <herbert@gondor.apana.org.au>, csnook@redhat.com,
       dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com
References: <20070811042943.GA13410@linux.vnet.ibm.com> <200708150001.58217.arnd@arndb.de> <20070814224354.GE8243@linux.vnet.ibm.com>
In-Reply-To: <20070814224354.GE8243@linux.vnet.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708151529.46780.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19NvfpWFSjPcOkZKK8rtN8x7NvhaTcx2micNX1
 pMFygKca9j2yKAT/fLP8DmMu8vtF9WQjrjSBEGrRNebzh0/ufj
 dyZ0ltXUgabLrOQs3Qj/A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 August 2007, Paul E. McKenney wrote:

> ACCESS_ONCE() is indeed intended to be used when actually loading or
> storing the variable.  That said, I must admit that it is not clear to me
> why you would want to add an extra order() rather than ACCESS_ONCE()ing
> one or both of the adjacent accesses to that same variable.
> 
> So, what am I missing?

You're probably right, the only case I can construct is something like

	if (ACCESS_ONCE(x)) {
		...
		ACCESS_ONCE(x)++;
	}

which would be slightly less efficient than

	if (x)
		x++;
	order(x);

because in the first case, you need to do two ordered accesses
but only one in the second case. However, I can't think of a case
where this actually makes a noticable difference in real life.

	Arnd <><
