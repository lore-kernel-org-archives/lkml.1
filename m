Return-Path: <linux-kernel-owner+w=401wt.eu-S932915AbXBQVPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915AbXBQVPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 16:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932920AbXBQVPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 16:15:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:55101 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932915AbXBQVPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 16:15:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Artem Bityutskiy <dedekind@infradead.org>
Subject: Re: [PATCH 41/44 take 2] [UBI] gluebi unit header
Date: Sat, 17 Feb 2007 22:14:54 +0100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165751.5845.28503.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165751.5845.28503.sendpatchset@localhost.localdomain>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
X-Legal: Vorsitzender des Aufsichtsrats: Johann Weihen=0A=0D Gesch=E4ftsf=FChrung: Herbert Kircher=0A=0D Sitz der Gesellschaft: B=F6blingen=0A=0D Registergericht: Amtsgericht Stuttgart, HRB 243294
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702172214.55654.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1+M2NRu+sJOWnfj1aVQ+PswX/iRjn6adRi/cXNB7paJzMpEATi7NySLY1Rj1nSPi8R8rk/9naaf2/5fMdlOsxQu8Z7n4HBdwx/xi+T3KEPwpw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 February 2007 17:57, Artem Bityutskiy wrote:
> + * This unit is responsible for emulating MTD devices on top of UBI devices.
> + * This sounds strange, but it is in fact quite useful to make legacy software
> + * work on top of UBI. New software should use native UBI API instead.
> + *
> + * Gluebi emulated MTD devices of "MTD_UBIVOLUME" type. Their minimal I/O unit
> + * size (mtd->writesize) is equivalent to the underlying flash minimal I/O
> + * unit. The eraseblock size is equivalent to the logical UBI volume eraseblock
> + * size.

This approach doesn't seem to make sense at all. If the MTD device interface
is flawed, the right approach should be to fix that instead. After all,
there are not many users of the MTD interface, so you should be able to
adapt them.

In fact, I would expect that there is much more reason to merge the existing
MTD interface with the block interface in the kernel, but you now introduce
a third interface that is unrelated to the first two, and make another
conversion to convert it back?

Let's assume I want to use the wear levelling capabilities of UBI on top
of an SD card, and use the ext3 file system on top of it. I get a stack of

1. MMC
2. block2mtd
3. UBI
4. gluebi
5. mtdblock
6. VFS

when in an ideal world, it should just be

1. MMC
2. UBI
3. VFS

	Arnd <><
