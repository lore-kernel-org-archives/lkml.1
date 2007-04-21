Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbXDUXUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbXDUXUO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 19:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbXDUXUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 19:20:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:53455 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbXDUXUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 19:20:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 7/8] Kconfig: silicon backplane dependency.
Date: Sun, 22 Apr 2007 01:19:32 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       akpm@linux-foundation.org, mb@bu3sch.de, linville@tuxdriver.com
References: <20070420113505.GH3738@skybase>
In-Reply-To: <20070420113505.GH3738@skybase>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704220119.32729.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/j1+mmtAMw0v1vWuP5peswlhO9bCTUXGzzbTp
 8TBwTDILR2LJqFm9ixbLfPlqTjrli0On2ibUt/jPEbtEPk+KDn
 jcvs6pKWWA3vn6XlPE1/g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2007, Martin Schwidefsky wrote:
> 
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Make the "Sonics Silicon Backplane" menu dependent on the two buses
> it can be found on.
> Goes on top of git-wireless.patch.
> 
> Cc: Michael Buesch <mb@bu3sch.de>
> Cc: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
> 
>  drivers/ssb/Kconfig |    1 +
>  1 files changed, 1 insertion(+)
> 
> diff -urpN linux-2.6/drivers/ssb/Kconfig linux-2.6-patched/drivers/ssb/Kconfig
> --- linux-2.6/drivers/ssb/Kconfig       2007-04-19 15:24:40.000000000 +0200
> +++ linux-2.6-patched/drivers/ssb/Kconfig       2007-04-19 15:55:44.000000000 +0200
> @@ -1,4 +1,5 @@
>  menu "Sonics Silicon Backplane"
> +       depends on PCI || PCMCIA

No, this doesn't look right. There are other devices that come with
SiliconBackplane but are not PCI or PCMCIA style devices.

I'd make this 'depends on MMIO' as well if you add that option.

	Arnd <><
