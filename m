Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYCRJsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYCRJsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 05:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbYCRJrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 05:47:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45234 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbYCRJru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 05:47:50 -0400
Date: Tue, 18 Mar 2008 18:46:58 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.25-rc5-mm1][regression?] BUG: spinlock wrong CPU, modprobe
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080318001720.9b6aea83.akpm@linux-foundation.org>
References: <20080317120848.7B3F.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080318001720.9b6aea83.akpm@linux-foundation.org>
Message-Id: <20080318182845.0E0D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew

> > Call Trace:
> >  [<a000000100015f00>] show_stack+0x80/0xa0
> >                                 sp=e00001609262fbd0 bsp=e000016092620fd8
> >  [<a000000100015f50>] dump_stack+0x30/0x60
> >                                 sp=e00001609262fda0 bsp=e000016092620fc0
> >  [<a0000001004674a0>] spin_bug+0x1a0/0x1c0
> >                                 sp=e00001609262fda0 bsp=e000016092620f90
> >  [<a000000100467590>] _raw_spin_unlock+0xd0/0x120
> >                                 sp=e00001609262fda0 bsp=e000016092620f60
> >  [<a00000010082bfe0>] _spin_unlock+0x20/0x40
> >                                 sp=e00001609262fda0 bsp=e000016092620f40
> >  [<a000000100138100>] do_wp_page+0x500/0xfe0
> >                                 sp=e00001609262fda0 bsp=e000016092620ed8
> >  [<a00000010013c560>] handle_mm_fault+0xe80/0x10e0
> >                                 sp=e00001609262fda0 bsp=e000016092620e50
> >  [<a00000010006c140>] ia64_do_page_fault+0x600/0xa40
> >                                 sp=e00001609262fda0 bsp=e000016092620df0
> >  [<a00000010000abe0>] ia64_leave_kernel+0x0/0x270
> >                                 sp=e00001609262fe30 bsp=e000016092620df0
> > 
> 
> I'm unaware of any other reports of anything like this so yes, please do
> bisect it if you have the time.

sorry, my report was uncleared.
I already did bisect and found the bug in git-ia64.patch.
and already reported Tony Luck.

that mail is quote following.

> Hi
> 
> if revert following patch
> 
>     [IA64] Multiple outstanding ptc.g instruction support
> 
> then this problem doesn't reproduce.
> 
> I attached that revert patch.
> Thanks!


Thanks.


