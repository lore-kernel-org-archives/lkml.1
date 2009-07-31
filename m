Return-Path: <linux-kernel-owner+w=401wt.eu-S1751673AbZGaHJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbZGaHJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 03:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbZGaHJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 03:09:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46677 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbZGaHJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 03:09:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 31 Jul 2009 16:07:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mike Smith <scgtrp@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: [BUGFIX][PATCH 0/3] fix bug for /proc/kcore causes panic  (Was:
 [Bugme-new] [Bug 13850] New: reading /proc/kcore causes oops
Message-Id: <20090731160748.279845da.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090729123209.690baa48.kamezawa.hiroyu@jp.fujitsu.com>
References: <bug-13850-10286@http.bugzilla.kernel.org/>
	<20090728160527.1da52682.akpm@linux-foundation.org>
	<20090729084825.1363c880.kamezawa.hiroyu@jp.fujitsu.com>
	<525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com>
	<20090729123209.690baa48.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009 12:32:09 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 28 Jul 2009 22:46:56 -0400
> Mike Smith <scgtrp@gmail.com> wrote:
> 
> > > What's layout of memory does your server have ?
> > The log I gave was from my desktop, so I'll assume you wanted that
> > instead of the server:
> > [mike: mike in ~]$ grep "System RAM" /proc/iomem
> > 00010000-0009efff : System RAM
> > 00100000-1dedffff : System RAM
> > 
> From this, your kernel's valid direct-map address range will be
> 
> c0010000-c009efff
> c0100000-ddedffff
> 
Ok, I reproduced the bug on x86-32 and here is a fix.

I reproduced the bug on x86-32 host with mem=512M boot option.

As I expected, the bug is from holes in vmalloc area.
(This hole means thera are a memory hole withing [start ...start+size-PAGE_SIZE) 
 of valid vm_struct.)

For review, I divided all into 3 patches. all series will be reply to this email.

Thanks,
-Kame

