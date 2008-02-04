Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbYBDOtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbYBDOtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 09:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbYBDOtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 09:49:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:58668 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751162AbYBDOtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 09:49:22 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19CXdM8JcFClXJkFDKXsFoOehFb1uTmHE9/B/AKUD
	TDerX3Tij5lpoh
Subject: Re: 2.6.24 regression: pan hanging unkilleable and un-straceable
From: Mike Galbraith <efault@gmx.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Frederik Himpe <fhimpe@telenet.be>, linux-kernel@vger.kernel.org
In-Reply-To: <1200980828.4643.11.camel@homer.simson.net>
References: <1200949086.6648.19.camel@Anastacia>
	 <200801221105.11413.nickpiggin@yahoo.com.au>
	 <1200978207.3944.8.camel@homer.simson.net>
	 <200801221625.58615.nickpiggin@yahoo.com.au>
	 <1200980828.4643.11.camel@homer.simson.net>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 15:49:18 +0100
Message-Id: <1202136558.7282.18.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-22 at 06:47 +0100, Mike Galbraith wrote:
> On Tue, 2008-01-22 at 16:25 +1100, Nick Piggin wrote:
> > On Tuesday 22 January 2008 16:03, Mike Galbraith wrote:
> 
> > > I've hit same twice recently (not pan, and not repeatable).
> > 
> > Nasty. The attached patch is something really simple that can sometimes help.
> > sysrq+p is also an option, if you're on a UP system.
> 
> SMP (P4/HT imitating real cores)
> 
> > Any luck getting traces?
> 
> We'll see.  Armed.

Hm.  ld just went loopy (but killable) in v2.6.24-6928-g9135f19.  During
kbuild, modpost segfaulted, restart build, ld goes gaga.  Third attempt,
build finished.  Not what I hit before, but mentionable.


[  674.589134] modpost[18588]: segfault at 3e8dc42c ip 0804a96d sp af982920 error 5 in modpost[8048000+9000]
[  674.589211] mm/memory.c:115: bad pgd 3e081163.
[  674.589214] mm/memory.c:115: bad pgd 3e0d2163.
[  674.589217] mm/memory.c:115: bad pgd 3eb01163.

[ 1407.322144]  =======================
[ 1407.322144] ld            R running      0 21963  21962
[ 1407.322144]        db9d7f1c 00200086 c75f9020 b1814300 b0428300 b0428300 b0428300 c75f9280 
[ 1407.322144]        b1814300 00000001 db9d7000 00000000 d08c2f90 dba4f300 00000002 00000000 
[ 1407.322144]        b1810120 dba4f334 00200046 ffffffff db9d7000 c75f9020 db9d7f30 b02f333f 
[ 1407.322144] Call Trace:
[ 1407.322144]  [<b02f333f>] preempt_schedule_irq+0x45/0x5b
[ 1407.322144]  [<b0117a10>] ? do_page_fault+0x0/0x470
[ 1407.322144]  [<b0104d6e>] need_resched+0x1f/0x21
[ 1407.322144]  [<b0117a10>] ? do_page_fault+0x0/0x470
[ 1407.322144]  [<b0117a5c>] ? do_page_fault+0x4c/0x470
[ 1407.322144]  [<b0117a10>] ? do_page_fault+0x0/0x470
[ 1407.322144]  [<b02f4a3a>] ? error_code+0x72/0x78
[ 1407.322144]  [<b02f0000>] ? init_transmeta+0xcf/0x22f <== zzt P4


