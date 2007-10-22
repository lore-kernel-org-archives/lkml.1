Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbXJVVfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbXJVVfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 17:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbXJVVf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 17:35:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:50658 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbXJVVfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 17:35:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
Date: Mon, 22 Oct 2007 23:34:45 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linus Torvalds <torvalds@linux-foundation.org>, matthew@wil.cx,
       ralf@linux-mips.org, adobriyan@gmail.com, viro@ftp.linux.org.uk,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
References: <20071020235546.GB1825@martell.zuzino.mipt.ru> <alpine.LFD.0.999.0710221254550.30120@woody.linux-foundation.org> <20071022130223.f7d75c31.akpm@linux-foundation.org>
In-Reply-To: <20071022130223.f7d75c31.akpm@linux-foundation.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710222334.45667.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX194l6MFv7FjTmjCsUnHHVmg8AiV8VO8wqffgO/
 YL1PKk/s50OLWSxZ5Zox5+DS43VcKdyJ6C6c2vk4ifmJkm1hLO
 lOMJ1AfYH37oJA2JX+6iQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 October 2007, Andrew Morton wrote:
> It's almost always a bug to do spin_lock_irq() when local interrupts are
> disabled.  However iirc when we've tried to add runtime debugging to catch
> that, it triggered false-positives which made the idea unworkable.  I forget
> where.

I tried this as well a few years ago, and I think I hit a few places in
the early initialization, but nothing unfixable.

> However what we could do is to add a new
> spin_lock_irq_tell_me_if_i_goofed() which would perform that runtime check. 

How about the opposite? We could have a raw_spin_lock_irq() in places where
there are valid uses of spin_lock_irq() with irqs disabled and the same
for spin_unlock_irq with interrupts already enabled.

I can try to come up with a new implementation, including some rate-limiting,
which I think my first attempt was missing.

	Arnd <><
