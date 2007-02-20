Return-Path: <linux-kernel-owner+w=401wt.eu-S964855AbXBTNSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855AbXBTNSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 08:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964857AbXBTNSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 08:18:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:56614 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964855AbXBTNSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 08:18:11 -0500
From: Arnd Bergmann <arnd.bergmann@de.ibm.com>
To: dedekind@infradead.org
Subject: Re: [PATCH 03/44 take 2] [UBI] user-space API header
Date: Tue, 20 Feb 2007 14:17:40 +0100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <200702172227.28708.arnd@arndb.de> <1171976833.4039.30.camel@sauron>
In-Reply-To: <1171976833.4039.30.camel@sauron>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
X-Legal: Vorsitzender des Aufsichtsrats: Johann Weihen=0A=0D Gesch=E4ftsf=FChrung: Herbert Kircher=0A=0D Sitz der Gesellschaft: B=F6blingen=0A=0D Registergericht: Amtsgericht Stuttgart, HRB 243294
Organization: IBM Deutschland Entwicklung GmbH, Vorsitzender des Aufsichtsrats: Johann Weihen, Geschaeftssfuerung: Herbert Kircher, Sitz der Gesellschaft: Boelingen, Registergericht: Amtsgericht Stuttgart, HRB 243294
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702201417.42872.arnd.bergmann@de.ibm.com>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX18+KxHBVsqJj+2P5/hGg6AmICmdMZ10mP2DBXRD0OC8VV2aSjjblyQUwtUjjKOCyTDbeyMmrPaTJOl5ZZwc6i2tYGF0HmDmmCX/8TIhs8Zs2A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 February 2007 14:07, Artem Bityutskiy wrote:
> 
> > This structure is not suitable for an ioctl call, because it has
> > incompatible layout between 32 and 64 bit processes. The easiest
> > fix for this would be to change the 'name' field to an array
> > instead of a pointer.
> 
> Will be fixed thanks. Just out of curiosity, could you please provide an
> example when this may be a problem.

On a 64 bit process with a 32 bit user app calling this ioctl, the kernel
would read the pointer value from the 8 bytes at the end, which means that
it will read four bytes after the end of the structure and interpret
whatever it finds as a pointer, instead of using only the first four
bytes as the lower half.

	Arnd <><
