Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbXJaBNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbXJaBNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 21:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbXJaBM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 21:12:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51697 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbXJaBM5 convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 21:12:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: dev_ifname32() fails on 32->64bit calls in copy_in_user().
Date: Wed, 31 Oct 2007 02:12:42 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linux Netdev <linux-netdev@vger.kernel.org>,
       Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <20071031003850.GE7517@tasint.org>
In-Reply-To: <20071031003850.GE7517@tasint.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710310212.42674.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+jLJiVffipDPd+7QWUH3oLxkmPF4Kd576XjCg
 /yWFmEKxnPFh4ss79H+s2nUwe4Y2MnT4M9tfZycsKwg/5Afskc
 408+ULIbKPH4+IWeekFgA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2007, Joel Becker wrote:
> 
>         Instrumenting the kernel with printks, the EFAULT comes from
> the first copy_in_user() at line 325 of fs/compat_ioctl.c (in
> dev_ifname32()).  I put some access_ok() checks in, and they do not
> trigger (access is ok).  The call never even gets into sys_ioctl().

Can you printk the pointers (arg and uifr) as well? Maybe the end up
unaligned or otherwise corrupted for some reason.

Does the same thing happen when you try the ioctl on something that
is not even a socket? E.g.

#include <whatever you need...>
int main(void)
{
	struct ifreq ifr = {};
	ioctl(0 /* standard input! */, SIOCGIFNAME, &ifr);
	perror("ioctl");
}

	Arnd <><
