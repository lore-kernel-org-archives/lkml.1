Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbXJLGFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbXJLGFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 02:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756875AbXJLGFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 02:05:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35217 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731AbXJLGFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 02:05:30 -0400
Date: Fri, 12 Oct 2007 08:05:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: poison <rc.poison@gmail.com>
Cc: Helmut Toplizer <bgrpt@toplitzer.net>, linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.23 - acting funny
Message-ID: <20071012060516.GA26074@elte.hu>
References: <200710111409.13854.bgrpt@toplitzer.net> <200710120053.20202.rc.poison@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710120053.20202.rc.poison@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* poison <rc.poison@gmail.com> wrote:

> Also the transfer rate didn't degrade too much for copying directly 
> from reiserfs to reiserfs and not using encfs:
> 
> dd if=/mnt/.backup/2CpGkrxvz6wgA0b0xloz8PavzMLrMymOgi9 of=/mnt/.tdata/test
> 1033+0 records in
> 1033+0 records out
> 1083179008 bytes (1.1 GB) copied, 16.9303 s, 64.0 MB/s
> 
> Plus the transfer rate doesn't increase if I start a CPU hog while 
> copying between reiserfs.
> 
> So it looks more to me like theres a bad interaction between the new 
> scheduler, fuse and encfs ...

i have no quick ideas - the behavior you are seeing is quite unexpected.
Could you try the current sched-devel code:

  http://redhat.com/~mingo/cfs-scheduler/devel/sched-devel-combo-v2.6.23.patch

since this version of CFS does various things differently then the one 
in v2.6.23, lets see whether perturbing it makes any difference to your 
throughput.

you could also try the scheduler backport to v2.6.22.10, at:

  http://redhat.com/~mingo/cfs-scheduler/

that would establish whether it's the changes in scheduling that cause 
this or something else. Plus please enable CONFIG_SCHED_DEBUG and 
CONFIG_SCHEDSTATS and run this debug script while such a transfer is 
going on:

  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

and send me the resulting file.

	Ingo
