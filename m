Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbXGOXSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbXGOXSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757682AbXGOXSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:18:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61100 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757791AbXGOXSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:18:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH/RFC] msleep() with hrtimers
Date: Mon, 16 Jul 2007 01:10:56 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
References: <19044.1184539364@lwn.net>
In-Reply-To: <19044.1184539364@lwn.net>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707160110.56810.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Md8t9/ykXh2d9nq55P7eJ6E5rqOuKEvat9NR
 RQnC1MeFXiIUfZvUFdnlEneQeSfb46ZE6Ueulb1Sf7lgMfSbCI
 D67PYwLkEIFgpeJaEj18g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 July 2007, Jonathan Corbet wrote:
> Here's another approach: a reimplementation of msleep() and
> msleep_interruptible() using hrtimers.  On a system without real
> hrtimers this code will at least drop down to single-jiffy delays much
> of the time (though not deterministically so).  On my x86_64 system with
> Thomas's hrtimer/dyntick patch applied, msleep(1) gives almost exactly
> what was asked for.

This reminds me of a patch I did some time ago, without ever getting
any feedback on it:

http://lkml.org/lkml/2007/3/4/165

In addition to just msleep, it converted all users of schedule_timeout()
as well as sys_*select(). I actually ran with that patch on my
main worstation for a few weeks, and while it did not crash, I
saw some strange behaviour after all.

	Arnd <><
