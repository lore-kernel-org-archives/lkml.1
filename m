Return-Path: <linux-kernel-owner+w=401wt.eu-S2993147AbXBRCRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993147AbXBRCRJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 21:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993150AbXBRCRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 21:17:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:56315 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993147AbXBRCRI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 21:17:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 41/44 take 2] [UBI] gluebi unit header
Date: Sun, 18 Feb 2007 03:15:23 +0100
User-Agent: KMail/1.9.5
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <200702172214.55654.arnd@arndb.de> <20070218020429.GE1038@crusty.rchland.ibm.com>
In-Reply-To: <20070218020429.GE1038@crusty.rchland.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
X-Legal: Vorsitzender des Aufsichtsrats: Johann Weihen=0A=0D Gesch=E4ftsf=FChrung: Herbert Kircher=0A=0D Sitz der Gesellschaft: B=F6blingen=0A=0D Registergericht: Amtsgericht Stuttgart, HRB 243294
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702180315.25067.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX18SYG1hsL6ZxwQyy5ZPxs/XwjBI6N8x47ZTNPpHNeu78GO1O+q+K8emmtLYbdgT++5XehHELqpII/bbainmZ4WCX5y9nc2azFl9gbkOBVZtlA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 February 2007 03:04, Josh Boyer wrote:
> No, the MTD interface isn't flawed.  gluebi is present to make things like
> JFFS2 work on top of UBI volumes with very little adaptations.  If you go
> changing _every_ MTD user to now use either an MTD device or a native UBI
> device, then the code for those users just gets bloated.

Right, that was my point. If the MTD API in the kernel is not flawed, why
do we need the 'native' UBI interface? Just merge gluebi into UBI and
get rid of the extra abstraction.

> Assuming your SD card isn't doing wear-leveling itself within the device,
> yes that is what you would get.  

While probably all modern SD cards have some amount of wear leveling
built in, I wouldn't want to rely on that for anything but the simple
large-file-on-fatfs (jpeg or mp3) case. Using UBI on top of the
native wear-leveling sounds like the right solution.

> Or you could do something slightly more sane 
> and use:
> 
> 1. MMC
> 2. block2mtd
> 3. JFFS2

Not on a 4GB SD medium, with the current jffs2 version. The problem
is that jffs2 doesn't scale that well, so you want a different fs.
Since logfs isn't stable yet, you end up with something like ext3,
which in turn means that you need a UBI-like concept to avoid
wearing out the blocks that store your metadata.

	Arnd <><
