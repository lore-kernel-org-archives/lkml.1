Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbXDVAcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbXDVAcX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 20:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbXDVAcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 20:32:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49707 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbXDVAcW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 20:32:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 2/8] Kconfig: unwanted menus for s390.
Date: Sun, 22 Apr 2007 02:32:09 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       akpm@linux-foundation.org
References: <20070420113248.GC3738@skybase> <200704220110.54587.arnd@arndb.de>
In-Reply-To: <200704220110.54587.arnd@arndb.de>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704220232.10219.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18OzBuNwtfkHthprOSUEcgvQKkR44wK57OiQbc
 HOAWQblsRJdsoIBzhlYra3qsieCG1YaN6jfhbtW4Lyi8nDROWc
 acvO3bE3Z8ylif0wmgxVA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 April 2007, Arnd Bergmann wrote:
> I would prefer to not have 'depends on !S390' but rather 'depends on MMIO',
> because that is what really drives stuff like IPMI: they expect the device
> to be reachable through the use of ioremap or inX/outX instructions, which
> don't exist on s390.
> 
> While it's unlikely that another architecture has the same restriction,
> it expresses much clearer what you mean.
> 
> In drivers/Kconfig, you can then simply add a
> 
> config MMIO
>         def_bool !S390

I just saw that we already have an option like that, with a slightly different
name.

arch/s390/Kconfig contains

config NO_IOMEM
	def_bool y

and lib/Kconfig contains

config HAS_IOMEM
	boolean
	depends on !NO_IOMEM
	default y

You should probably just use one of these two to disable any driver that
uses ioremap or similar.

	Arnd <><
