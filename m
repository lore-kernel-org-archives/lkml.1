Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbXI1XyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbXI1XyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 19:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbXI1XyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 19:54:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:52481 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbXI1XyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 19:54:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: [COMPAT] Add compat_merge64 helper
Date: Sat, 29 Sep 2007 01:38:23 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070831.706792)
References: <1191018832-18069-1-git-send-email-kyle@mcmartin.ca>
In-Reply-To: <1191018832-18069-1-git-send-email-kyle@mcmartin.ca>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709290138.24562.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/CmPcW0Mq4qFqJtR3XuvO5V4YjQAdzmgO22As
 qgkAEYasOMR9DOj4Ku3PRAPFzCqreGhmY0o/oXkkl1wxnyNrSo
 GjzxQy9a/0mO6KderWNZw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 September 2007, you wrote:
> +static inline u64 compat_merge64(u32 left, u32 right)
> +{
> +#if defined(__BIG_ENDIAN)
> +       return ((u64)left << 32) | right;
> +#else /* defined (__LITTLE_ENDIAN) */
> +       return ((u64)right << 32) | left;
> +#endif
> +}

Looks good, if we can guarantee that

1. Byte order matches the order in which 64 bit arguments are split
   in system call conventions on all platforms.
2. Every user of compat_merge64() includes asm/byteorder.h

Both should be easy to prove, but I'm not convinced until someone
actually does it.

	Arnd <><
