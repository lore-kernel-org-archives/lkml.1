Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbXFCVoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbXFCVoW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 17:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbXFCVoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 17:44:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:59265 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbXFCVoI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 17:44:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@lazybastard.org>
Subject: Re: [Patch 04/18] include/linux/logfs.h
Date: Sun, 3 Jun 2007 23:42:25 +0200
User-Agent: KMail/1.9.6
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Weinehall <tao@acc.umu.se>, Willy Tarreau <w@1wt.eu>,
       Kyle Moffett <mrmacman_g4@mac.com>, Dongjun Shin <djshin90@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, Bill Davidsen <davidsen@tmr.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
References: <20070603183845.GA8952@lazybastard.org> <20070603184205.GE8952@lazybastard.org>
In-Reply-To: <20070603184205.GE8952@lazybastard.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706032342.27252.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18W/7c1hjcF2K/wDwOWw1B1aXWKflCjmPP+Fvn
 bqwUGOerX9EwbOtx8U4oU02Hpc4RIFaqRh7U7RyI92/LT9H6L4
 jrx2XK+s7fWbhToJRWIuQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 June 2007, Jörn Engel wrote:
> +struct logfs_je_spillout {
> +       __be64  so_segment[0];
> +}__packed;

All the on-disk data structures you define in this file have naturally
aligned members, so the __packed attribute is not needed.

However, I think it causes gcc to generate larger and slower code
on some architectures, because now it has to assume that the data
structure itself has no more than byte alignment.

I'd simply remove all instances of __packed therefore. In order
to verify that you got it right in all cases, build with
'-Wpadded -Wpacked'.

	Arnd <><
