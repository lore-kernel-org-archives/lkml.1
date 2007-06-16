Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbXFPLVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbXFPLVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 07:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbXFPLVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 07:21:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60212 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbXFPLVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 07:21:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
Date: Sat, 16 Jun 2007 13:21:35 +0200
User-Agent: KMail/1.9.6
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200706150159.l5F1xNgM000459@hera.kernel.org> <1181986686.25228.639.camel@pmac.infradead.org> <200706161226.40875.arnd@arndb.de>
In-Reply-To: <200706161226.40875.arnd@arndb.de>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706161321.35940.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+Wdvjn8AoKzGf4QqynAzfUMH/SQQim4uRl9T5
 s1soWjeS+qJ6ErnIawkB7qS9kb8z1Qz/s0IXAm1qgUdlNJPRXZ
 XNGdA5/5wOQuDsKz+xnnQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 June 2007, Arnd Bergmann wrote:
> On Saturday 16 June 2007, David Woodhouse wrote:
> > Will GCC know that it needs to emit code to handle that (mis)alignment?
> 
> I've tested this with gcc-4.0.3, and it does the right thing, which
> is to split a 4 byte aligned 64 bit load/store into two 32 bit accesses,
> if you pass -mstrict-align.

I just realized this was correct but slightly misleading. On powerpc, we
don't set the 'attribute((aligned(4)))' on compat_64, so there is never
a reason to handle the misalignment, even though it would work.

On x86_64, misaligned loads are always ok, so gcc never needs to
care about this, even attribute((packed)) does not cause byte access
here.

	Arnd <><
