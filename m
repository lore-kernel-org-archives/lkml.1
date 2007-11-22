Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbXKVDES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbXKVDES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 22:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbXKVDEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 22:04:04 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47583 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbXKVDEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 22:04:01 -0500
Date: Thu, 22 Nov 2007 12:06:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com
Subject: Re: 2.6.24-rc3-mm1 (sync is slow ?)
Message-Id: <20071122120643.c293c617.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071121004909.6157bb9a.akpm@linux-foundation.org>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<20071121174215.caff4551.kamezawa.hiroyu@jp.fujitsu.com>
	<20071121004909.6157bb9a.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 00:49:09 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 21 Nov 2007 17:42:15 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > Hi, Andrew
> > 
> > I got following result in 'sync' command.
> > It was too slow. (memory controller config is off ;)
> > I attaches my .config.
> > ==
> > [2.6.24-rc3-mm1]
> > [kamezawa@dr-test2 ~]$ dd if=/dev/zero of=./tmpfile bs=4096 count=100000
> > 100000+0 records in
> > 100000+0 records out
> > 409600000 bytes (410 MB) copied, 1.46706 seconds, 279 MB/s
> > [kamezawa@dr-test2 ~]$ time sync
> > 
> > real    3m6.440s
> > user    0m0.000s
> > sys     0m0.133s

> Well I wonder how we did that.
> 
> It seems OK here from a quick test (i386, ext3-on-IDE).
> 
> Maybe device driver/block breakage?
> 

I confirmed This slowdown is caused by git-scsi-misc.patch.
I'm sorry that I can't chase more and will be offline in this weekend.

This is scsi_mod information in /proc/modules
=
scsi_mod 409416 8 mptctl,sg,lpfc,scsi_transport_fc,mptspi,mptscsih,scsi_transport_spi,sd_mod, Live 0xa000000202818000
=

What information should I provide more ?

Thanks,
-Kame


