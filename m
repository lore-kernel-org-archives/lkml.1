Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbXFPKch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbXFPKch (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 06:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbXFPK1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 06:27:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55907 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbXFPK1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 06:27:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
Date: Sat, 16 Jun 2007 12:26:40 +0200
User-Agent: KMail/1.9.6
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200706150159.l5F1xNgM000459@hera.kernel.org> <200706151131.38429.arnd@arndb.de> <1181986686.25228.639.camel@pmac.infradead.org>
In-Reply-To: <1181986686.25228.639.camel@pmac.infradead.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706161226.40875.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/yP4sN5m0tHwr1cKyHnjnf3qEzU3gz8Z8BUzB
 NJo9oD7uYKS+pxHxLVzx0i2jO4pBHjQjmCykrrSqEqlF1I5bKT
 1x1iCE5TrI/FTbyh54Zsg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 June 2007, David Woodhouse wrote:
> Will GCC know that it needs to emit code to handle that (mis)alignment?

I've tested this with gcc-4.0.3, and it does the right thing, which
is to split a 4 byte aligned 64 bit load/store into two 32 bit accesses,
if you pass -mstrict-align.

> Preliminary tests show that it does load the value bytewise if we use
> the 'packed' attribute structure on ppc64, but doesn't if we use
> compat_u64. But then, I don't think it actually _needs_ to handle it n
> ppc64 anyway, so maybe that's not such a good test.

Right. Note that the behaviour of compat_u64 is the same as when you
pass attribute((packed,aligned(4))) to the structure, where it also won't
do byte accesses, and split the 64 bit access only if you pass
-mstrict-align.

	Arnd <><
