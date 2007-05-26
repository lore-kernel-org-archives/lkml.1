Return-Path: <linux-kernel-owner+w=401wt.eu-S1762211AbXEZP51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762211AbXEZP51 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 11:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbXEZP5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 11:57:20 -0400
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:53106 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223AbXEZP5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 11:57:20 -0400
Date: Sat, 26 May 2007 17:56:36 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Tommy Vercetti <vercetti@zlew.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.1 - 97% wait time on IDE operations
Message-ID: <20070526175636.54f5a0ea@localhost>
In-Reply-To: <200705261607.49416@gj-laptop>
References: <200705261505.38109@gj-laptop>
	<20070526155223.1bedba5a@localhost>
	<200705261607.49416@gj-laptop>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 May 2007 16:07:49 +0200
Tommy Vercetti <vercetti@zlew.org> wrote:

> > Anyway 97% is quite high... what CPU / Hard Disk do you have?  
> Intel(R) Pentium(R) M processor 1400MHz
> TOSHIBA MK8025GAS
> 
> > What kernel version?  
> 2.6.21.1
> > I/O scheduler? (cat /sys/block/DEVICE/queue/scheduler)  
> gj@puppet:~$ cat /sys/block/hda/queue/scheduler
> noop anticipatory deadline [cfq]
> 
> > Filesystem?  
> reiser3
> > And what time of "operations" are you doing?  
> apt-get install, vmware

It's probably just a slow disk... try hdparm as suggested by Ray and
see if they look sane (PS: just seen the numbers and looks sane to me).

If they are and you need more performance buy a better HD :)

Improvements from kernel side are possible but don't expect too much.


Things to check/try:

1) FS: is it in good shape? Or is it full and fragmented?

2) FS mount options, try adding everything that can reduce accesses
(noatime, nodiratime)

3) try experimental patches such as Adaptive Readahead, it seems to
help some workload (it was there in older -mm, now there's a much
simplier readahead replacement in 2.6.22-rc2-mm1 called "on-demand
readahead", maybe that helps too?)

-- 
	Paolo Ornati
	Linux 2.6.22-rc3-cfs-v14-gf193016a on x86_64
