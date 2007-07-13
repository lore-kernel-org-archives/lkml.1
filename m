Return-Path: <linux-kernel-owner+w=401wt.eu-S1760624AbXGMOio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624AbXGMOio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 10:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933960AbXGMOiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 10:38:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:56544 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761021AbXGMOiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 10:38:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
Date: Fri, 13 Jul 2007 16:19:54 +0200
User-Agent: KMail/1.9.6
Cc: James Bottomley <James.Bottomley@steeleye.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alessandro Rubini <rubini@vision.unipv.it>,
       Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>
References: <20070704132212.726923000@pademelon.sonytel.be> <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be> <1184335333.3402.20.camel@localhost.localdomain>
In-Reply-To: <1184335333.3402.20.camel@localhost.localdomain>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707131619.54898.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18iulA2NcYJrcpOV973qVDnaa7PncCC/nZmYkd
 B/K2XeXEUqbol3EFf+P/T3tOEogntuhh49LssmJQ12CILkYphD
 W/eqANSlIMlZDHOp54LXQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 July 2007, James Bottomley wrote:
> 
> > IC.
> > 
> >   - flush_kernel_dcache_page() is a no-op on ppc64
> >     (ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE is defined on parisc only).
> > 
> >   - For reference, drivers/scsi/ipr.c (another ppc64 driver) just uses a plain
> >     kmap/memcpy/kunmap sequence
> > 
> > So what should I do?
> 
> Ask someone who knows the architecture ... Anton, Paulus or Benh ... I'm
> fairly certain PPC is VIPT and will need some kind of alias
> resolution ... perhaps its associative enough not to let the aliases be
> a problem.

I'm pretty sure that no ppc64 machine needs alias resolution in the kernel,
although some are VIPT. Last time we discussed this, Segher explained it
to me, but I don't remember which way Cell does it. IIRC, it automatically
flushes cache lines that are accessed through aliases.

It's probably a good idea to have the flush_kernel_dcache_page() in there
anyway, if only to serve as an example for people that copy it into
architecture-independent drivers, same as what we do for the
k{,un}map_atomic() that is also not required on ppc64.

	Arnd <><
