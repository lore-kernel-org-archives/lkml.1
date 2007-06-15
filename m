Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbXFOPYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbXFOPYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbXFOPYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:24:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:65262 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbXFOPYW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:24:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: vtaras@openvz.org
Subject: Re: [PATCH] diskquota: 32bit quota tools on 64bit architectures
Date: Fri, 15 Jun 2007 17:24:16 +0200
User-Agent: KMail/1.9.6
Cc: Mikael Pettersson <mikpe@it.uu.se>, akpm@linux-foundation.org, dev@sw.ru,
       devel@openvz.org, jack@suse.cz, linux-kernel@vger.kernel.org,
       nataliep@google.com, vvs@sw.ru
References: <200706151003.l5FA3vd6008194@harpo.it.uu.se> <200706151243.02186.arnd@arndb.de> <1181918882.3241.48.camel@dhcp0-149.sw.ru>
In-Reply-To: <1181918882.3241.48.camel@dhcp0-149.sw.ru>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706151724.17094.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/J+jNR4ETfm+5JpY03H/02rBAsa2H3/hq2/1A
 vJXqsoZfngGPgDm8UAASnIejcaq1Xoz+kO/dI3AF5ItVy80e7G
 +cHHzFPl/dKHUaBsZKCgQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007, Vasily Tarasov wrote:
> I just noticed that we can not avoid the addition of packed attribute.
> Look, for example:
> 
> struct if_dqblk {
>         __u64 dqb_bhardlimit; 
>         __u64 dqb_bsoftlimit;
>         __u64 dqb_curspace;
>         __u64 dqb_ihardlimit;
>         __u64 dqb_isoftlimit;
>         __u64 dqb_curinodes; 
>         __u64 dqb_btime;
>         __u64 dqb_itime;
>         __u32 dqb_valid;
> };
> 
> sizeof(if_dqblk) = 0x48
> On 32 bit: 0x44
> 
> If I replace __u64/__u32 with compat equivalents - it will not help!
> alligned attribute can _only_ _increase_ the size of structure, but not
> decrease it.

No, the gcc documentation isn't quite clear there, see the discussion about
compat_u64 and compat_s64 types. It actually does the right thing when
you use 'typedef __u64 __attribute__((aligned(64))) compat_64', as my
patch does.

	Arnd <><
