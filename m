Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbXFOKoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbXFOKoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 06:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbXFOKoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 06:44:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:57199 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbXFOKoF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 06:44:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [PATCH] diskquota: 32bit quota tools on 64bit architectures
Date: Fri, 15 Jun 2007 12:43:01 +0200
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, vtaras@openvz.org, dev@sw.ru, devel@openvz.org,
       jack@suse.cz, linux-kernel@vger.kernel.org, nataliep@google.com,
       vvs@sw.ru
References: <200706151003.l5FA3vd6008194@harpo.it.uu.se>
In-Reply-To: <200706151003.l5FA3vd6008194@harpo.it.uu.se>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706151243.02186.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19cS/ror81kDlJWA7u5VsS2JGyhWYrohUrQV57
 E+eQicFpn8IDmBurdjNBVUUF6Wdnm/bmxLPt2209+XiiKocQmX
 NBJQ3Ptu6n8XJPvbh3VuQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007, Mikael Pettersson wrote:
> > --- linux-2.6.22-rc4-fixed/fs/quota.c.orig    2007-06-14 15:55:26.000000000 +0400
> > +++ linux-2.6.22-rc4-fixed/fs/quota.c 2007-06-14 19:50:13.000000000 +0400
> ...
> > +#if defined(CONFIG_X86_64) || defined(CONFIG_IA64)
> > +/*
> > + * This code works only for 32 bit quota tools over 64 bit OS (x86_64, ia64)
> > + * and is necessary due to alignment problems.
> > + */
> 
> The #ifdef looks way too arch-specific. And isn't there a shared
> compat.c module somewhere that this should go into?
> 

Only x86_64 and ia64 have this particular problem, the other architectures,
and hopefully all future 64 bit platforms with 32 bit user space use
the same alignment rules in elf32 and elf64.

Still, the patch should be converted to use the compat_u64 type and not
add an 'attribute((packed))' so that you _can_ use the same code on all
architectures. See my 'Introduce compat_u64 and compat_s64 types' patch
that I just posted in another thread.

	Arnd <><
