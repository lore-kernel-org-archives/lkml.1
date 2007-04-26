Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbXDZViI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbXDZViI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbXDZViI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:38:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:51847 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbXDZViG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:38:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Fulghum <paulkf@microgate.com>
Subject: Re: compat_ioctl question
Date: Thu, 26 Apr 2007 23:37:55 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1177620717.5060.11.camel@amdx2.microgate.com>
In-Reply-To: <1177620717.5060.11.camel@amdx2.microgate.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704262337.56240.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/4HzXH2vsu6IyFC7cwxMmhF7Ny4IFtLivJy76
 RXzvneBjAujzbGyU3AavG3MnbXrQFK9uAKlB4H+JCs2NF5uSWj
 2nQ+mvvr+JAj2OYnxcDOw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 April 2007, Paul Fulghum wrote:
> I need to add ioctl translations for my driver to
> allow 32 bit access on 64 bit systems.
> 
> After digging through the kernel code there seems to be
> 3 methods of doing this:
> 
> 1. define compat_ioctl() file operation for device and
>     implement translation code in individual driver
> 2. add COMPATIBLE_IOCTL entry to include/linux/compat_ioctl.h
>     to mark an ioctl code as the same in any environment
> 3. add HANDLE_IOCTL entry to fs/compat_ioctl.c with translation code
>     implemented in the same file
> 
> There is no way to implement #1 for a tty driver without
> modifying the kernel tty code to allow registration of a
> compat_ioctl() handler.
> 
> #3 would put a lot of driver specific stuff in a common
> kernel file. This method also seems to break if there
> is an ioctl code collision.
> 
> All of these methods involve changes to code outside of my driver.
> 
> --
> 
> Before I spend a lot of time on this I need to know what the
> officially sanctioned method is. I haven't found any definitive
> documentation and a review of mailing list archives does not
> suggest a prevailing opinion.
> 
> Does anyone have pointers on which way would be most likely
> to be accepted as a patch?

It depends a lot on what your specific driver does in the ioctl
handler, but normally you should define a compat_ioctl() function.
What driver are you talking about?

	Arnd <><
