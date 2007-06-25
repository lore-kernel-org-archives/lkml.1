Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbXFYBgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbXFYBgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 21:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbXFYBge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 21:36:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:51434 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbXFYBgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 21:36:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] pcmcia: ppc64 needs 32-bit ioaddr_t
Date: Mon, 25 Jun 2007 03:35:56 +0200
User-Agent: KMail/1.9.6
Cc: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, akpm@osdl.org, paulus@samba.org
References: <20070625005439.GA31289@lixom.net>
In-Reply-To: <20070625005439.GA31289@lixom.net>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706250335.56739.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+r0CE15oTZmPvi2J/xVJskZ1mkQGu/aaxsRfT
 3EFPp3BQoe62ryreKVQLGwUwPKISQtPrjx5lEPCCMLt86z5yQH
 SfocsOJJOU2tLbGvJNMUw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 June 2007, Olof Johansson wrote:
> ppc64 really needs ioaddr_t to be 32-bit, since I/O addresses really are
> MMIO addresses, and remapped at an offset that's well above 16 bits in
> some cases.
> 
> While the type is exported to userspace, there hasn't been any platforms
> with PCMCIA on 64-bit powerpc until now, so changing it won't regress
> any existing users.

I just realized that this argument is bogus, because the user space tools
are probably, or at least potentially, built as 32 bit binaries, which
means that any interface using these _will_ break.

However, I could not find any actual user space interfaces in 2.6.22-rc
that are built around ioaddr_t. What are they, or have the been removed
by now?

	Arnd <><
